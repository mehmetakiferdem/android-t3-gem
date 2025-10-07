#!/bin/bash
set -e
set -u
set -o pipefail

function usage {
	echo "Usage: sudo flashall.sh <options>";
	echo "options:";
	echo "  --board To select good bootloader, board supported: am62x-sk, am62x-lp-sk, am625-beagleplay, am62px-sk, am67a-evm, am67a-beagley-ai"
	echo "  --bootloader To flash bootloader only. Useful when partitioning changes occur"
	echo "  --hsfs for HS-FS devices which require bootloader authentication (default for am62px-sk)"
	echo "  --sdcard /dev/<SDCARD> to generate a bootable SD card"
	echo "  --disable-avb To disable Android Verified Boot (development build)"
	echo "  --help Show this message and exit"
	exit 1;
}

# The bootloader-${board}.img is a vfat partition with 2 files: tispl.bin and u-boot.img
# Both are flashed on the same partition in the User Data Area (UDA) labeled "bootloader"
function generate_bootloader_image {
	local board=$1
	local tisplbin=$2
	local ubootimg=$3
	echo "Generating bootloader-${board}.img ..."
	dd if=/dev/zero of=bootloader-${board}.img bs=1048576 count=8 status=none
	if [ "$board" == "am67a-beagley-ai" ]; then
		# Create FAT16 matching working parameters
		mkfs.vfat -F 16 -n "boot" -S 512 -s 1 -g 32/2 -h 8192 bootloader-${board}.img

		mcopy -i bootloader-${board}.img ${tiboot3bin} ::tiboot3.bin
		mcopy -i bootloader-${board}.img ${tisplbin} ::tispl.bin
		mcopy -i bootloader-${board}.img ${ubootimg} ::u-boot.img
	else
		mkfs.vfat bootloader-${board}.img
		mcopy -i bootloader-${board}.img ${tisplbin} ::tispl.bin
		mcopy -i bootloader-${board}.img ${ubootimg} ::u-boot.img
	fi
	echo "Generating bootloader-${board}.img: DONE"
}

function run_sdcard_creation {
	local sd_dev=$1
	local board=$2
	local tiboot3bin=$3
	local bootloader_only=$4

	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root/sudo"
		exit
	fi

	# use 21M size for installer.img
	if [ "$board" == "am67a-beagley-ai" ]; then
		dd if=/dev/zero of=./installer.img count=30720 status=none
	else
		dd if=/dev/zero of=./installer.img count=40960 status=none
	fi

	loopdev=$(sudo losetup -f)
	losetup "${loopdev}" installer.img
	parted "${loopdev}"  mktable gpt
	if [ "$board" == "am67a-beagley-ai" ]; then
		parted "${loopdev}"  mkpart primary fat16 4MiB 12MiB
		mkfs.vfat -F 16 -n "boot" -S 512 -s 1 -g 32/2 "${loopdev}p1"
		parted "${loopdev}"  set 1 boot on
		parted "${loopdev}"  set 1 bls_boot off
	else
		parted "${loopdev}"  mkpart primary fat32 5MiB 13MiB
		parted "${loopdev}"  mkpart primary 4MiB 5MiB
		mkfs.vfat -F 32 -n "boot" "${loopdev}p1"
		dd if=${tiboot3bin} of="${loopdev}p2" status=none
	fi
	sync
	mkdir -p boot
	mount  ${loopdev}p1 boot
	cp ${tiboot3bin} boot/tiboot3.bin
	cp tispl-${board}.bin boot/tispl.bin
	cp u-boot-${board}.img boot/u-boot.img
	umount boot
	losetup -d ${loopdev}
	dd if=installer.img of=${sd_dev} status=none
	rm -rf boot installer.img
	set +e
	eject ${sd_dev}
	set -e

	if [[ "$bootloader_only" == "true" ]]; then
		echo "Done preparing bootstrap SD Card"
		exit 0
	fi

	echo "Insert SD card on board, Power ON and interrupt U-Boot to go in console to do this command:"
	if [ "$board" != "am67a-beagley-ai" ]; then
		echo "=> mmc dev 0 0"
		echo "=> mmc erase 0 0x10000"
		echo "=> mmc dev 0 1"
		echo "=> mmc erase 0 0x10000"
		echo "=> env default -a"
		echo "=> setenv mmcdev 1; saveenv; reset;"
	fi
	echo " Interrupt U-boot  to go in console:"
	echo "=> fastboot 0"
	echo "When it's Done"
	read -p "Press any key to continue... " -n1 -s
}

function main {
	local opts_args="sdcard:,help,hsfs,board:,bootloader,disable-avb"
	local opts=$(getopt -o '' -l "${opts_args}" -- "$@")
	eval set -- "${opts}"

	local board=""
	local sd_dev=""
	local hsfs="false"
	local bootloader_only="false"
	local disable_avb="false"
	while true; do
		case "$1" in
			--board) board="$2"; shift 2 ;;
			--sdcard) sd_dev="$2"; shift 2 ;;
			--hsfs) hsfs="true"; shift ;;
			--bootloader) bootloader_only="true"; shift ;;
			--disable-avb) disable_avb="true"; shift;;
			--help) usage; exit 0 ;;
			--) shift; break;;
		esac
	done

	case "${board}" in
		"am62x-sk"|"am62x-lp-sk"|"am625-beagleplay") ;;
		"am62px-sk"|"am67a-evm"|"am67a-beagley-ai") hsfs="true";;
		*) echo "invalid board: $board"; usage;;
	esac

	echo "board: ${board}"

	tiboot3bin="tiboot3-${board}.bin"
	if [[ "${hsfs}" == "true" ]]; then
		tiboot3bin="tiboot3-${board}-hsfs.bin"
	fi
	tisplbin="tispl-${board}.bin"
	ubootimg="u-boot-${board}.img"

	required_bootloaders=("${tiboot3bin}" "${tisplbin}" "${ubootimg}")
	for img in ${required_bootloaders[@]}; do
		if [ ! -e "${img}" ] ; then
			echo "Missing ${img}"
			exit -1;
		fi
	done

	if  ! [ -z "${sd_dev}" ]; then
		run_sdcard_creation "${sd_dev}" "${board}" "${tiboot3bin}" "${bootloader_only}"
	fi

	if [[ -x "fastboot" ]] && [[ ! -v FASTBOOT ]]; then
		export FASTBOOT="./fastboot"
	fi
	export FASTBOOT=${FASTBOOT-$(which fastboot)}
	export LD_LIBRARY_PATH=./
	echo "Fastboot: $FASTBOOT"
	if [ ! -f ${FASTBOOT} ]; then
		echo "Error: fastboot is not available at ${FASTBOOT}"
		exit -1;
	fi

	generate_bootloader_image "${board}" "${tisplbin}" "${ubootimg}"
	bootloaderimg="bootloader-${board}.img"

	userdataimg="userdata.img"
	superimg="super.img"
	bootimg="boot.img"
	vendorbootimg="vendor_boot.img"
	initbootimg="init_boot.img"
	vbmetaimg="vbmeta.img"
	vbmetavendordlkmimg="vbmeta_vendor_dlkm.img"
	vbmetasystemdlkmimg="vbmeta_system_dlkm.img"
	dtboimg="dtbo.img"
	dtbouimg="dtbo-unsigned.img"
	persistimg="persist.img"
	metadataimg="metadata.img"

	# Verify that all the files required for the fastboot flash
	# process are available
	required_images=(
		"${tiboot3bin}"
		"${bootloaderimg}"
		"${superimg}"
		"${userdataimg}"
		"${bootimg}"
		"${vendorbootimg}"
		"${initbootimg}"
		"${persistimg}"
		"${metadataimg}"
		"${dtboimg}"
		"${vbmetaimg}"
		"${vbmetavendordlkmimg}"
		"${vbmetasystemdlkmimg}"
	)

	for img in ${required_images[@]}; do
		if [ ! -e "${img}" ] ; then
			echo "Missing ${img}"
			exit -1;
		fi
	done

	echo "Create GPT partition table"
	${FASTBOOT} oem format

	sleep 3

	if [ "$board" != "am67a-beagley-ai" ]; then
		echo "Flashing tiboot3....."
		echo "   tiboot3bin:  ${tiboot3bin}"
		${FASTBOOT} flash tiboot3 ${tiboot3bin}
	fi

	sleep 3
	echo "Flashing bootloader....."
	echo "   bootloader:  ${bootloaderimg}"
	${FASTBOOT} flash bootloader ${bootloaderimg}

	if [[ "$bootloader_only" == "true" ]]; then
		echo "Done flashing bootloaders"
		exit 0
	fi

	echo "Flashing Boot Image"
	${FASTBOOT} flash boot_a ${bootimg}
	${FASTBOOT} flash boot_b ${bootimg}

	echo "Flashing Vendor Boot Image"
	${FASTBOOT} flash vendor_boot_a ${vendorbootimg}
	${FASTBOOT} flash vendor_boot_b ${vendorbootimg}

	echo "Flashing Init Boot Image"
	${FASTBOOT} flash init_boot_a ${initbootimg}
	${FASTBOOT} flash init_boot_b ${initbootimg}

	echo "Flashing Userdata Image"
	${FASTBOOT} flash userdata ${userdataimg}

	if [[ "$disable_avb" == "true" ]]; then
	    echo "Flashing vbmeta Image (disabling AVB)"
	    ${FASTBOOT} flash --disable-verity --disable-verification vbmeta_a ${vbmetaimg}
	    ${FASTBOOT} flash --disable-verity --disable-verification vbmeta_b ${vbmetaimg}
	    echo "Flashing vbmeta vendor dlkm Image (disabling AVB)"
	    ${FASTBOOT} flash --disable-verity --disable-verification vbmeta_vendor_dlkm_a ${vbmetavendordlkmimg}
	    ${FASTBOOT} flash --disable-verity --disable-verification vbmeta_vendor_dlkm_b ${vbmetavendordlkmimg}
	    echo "Flashing vbmeta system dlkm Image (disabling AVB)"
	    ${FASTBOOT} flash --disable-verity --disable-verification vbmeta_system_dlkm_a ${vbmetasystemdlkmimg}
	    ${FASTBOOT} flash --disable-verity --disable-verification vbmeta_system_dlkm_b ${vbmetasystemdlkmimg}
	else
	    echo "Flashing vbmeta Image"
	    ${FASTBOOT} flash vbmeta_a ${vbmetaimg}
	    ${FASTBOOT} flash vbmeta_b ${vbmetaimg}
	    echo "Flashing vbmeta vendor dlkm Image"
	    ${FASTBOOT} flash vbmeta_vendor_dlkm_a ${vbmetavendordlkmimg}
	    ${FASTBOOT} flash vbmeta_vendor_dlkm_b ${vbmetavendordlkmimg}
	    echo "Flashing vbmeta system dlkm Image"
	    ${FASTBOOT} flash vbmeta_system_dlkm_a ${vbmetasystemdlkmimg}
	    ${FASTBOOT} flash vbmeta_system_dlkm_b ${vbmetasystemdlkmimg}
	fi
	echo "Flashing DTBO Image"
	${FASTBOOT} flash dtbo_a ${dtboimg}
	${FASTBOOT} flash dtbo_b ${dtboimg}

	echo "Flashing Persist Partition"
	${FASTBOOT} flash persist ${persistimg}

	echo "Erasing Misc Partition"
	${FASTBOOT} erase misc

	echo "Flashing metadata partition"
	${FASTBOOT} flash metadata ${metadataimg}

	echo "Flashing Android Super Image"
	${FASTBOOT} flash super	${superimg}

	if [ "$board" == "am67a-beagley-ai" ]; then
		rm ${bootloaderimg}
		echo "-------------------------------"
		echo "flashing done, you can issue the 'fastboot reboot' command"
	fi
}

if [ "$0" = "$BASH_SOURCE" ]; then
	main "$@"
fi
