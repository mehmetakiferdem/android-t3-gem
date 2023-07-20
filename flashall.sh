#!/bin/bash
set -e
set -u
set -o pipefail

function usage {
	echo "Usage: sudo flashall.sh <options>";
	echo "options:";
	echo "  --board To select good bootloader, board supported: am62x-sk, am62x-lp-sk"
	echo "  --help Show this message and exit"
	exit 1;
}

function main {
	local opts_args="sdcard:,help,hsfs,board:"
	local opts=$(getopt -o '' -l "${opts_args}" -- "$@")
	eval set -- "${opts}"

	local board=""
	local sd_dev=""
	local hsfs="false"
	while true; do
		case "$1" in
			--board) board="$2"; shift 2 ;;
			--sdcard) sd_dev="$2"; shift 2 ;;
			--hsfs) hsfs="true"; shift ;;
			--help) usage; exit 0 ;;
			--) shift; break;;
		esac
	done
	echo "board: ${board}"
	if  [ -z "${board}" ]; then
		echo "Error you need to specify board name"
		usage
	fi

    export PRODUCT_OUT=${PRODUCT_OUT-"./"}
	# Create the filename
	if [[ "${hsfs}" == "true" ]]; then
		tiboot3bin="${PRODUCT_OUT}tiboot3-${board}-hsfs.bin"
	else
		tiboot3bin="${PRODUCT_OUT}tiboot3-${board}.bin"
	fi
	
	if  ! [ -z "${sd_dev}" ]; then
		if [ "$EUID" -ne 0 ]
		then echo "Please run as root/sudo"
		exit
		fi

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << FDISK_CMDS  | fdisk ${sd_dev}
g      # create new GPT partition
n      # add new partition
2      # partition number
8192	# first sector
+1MiB # partition size
n      # add new partition
1      # partition number
10240	# default - first sector
+8Mib	# default - last sector
w      # write partition table and exit
FDISK_CMDS

		parted --align optimal --script  ${sd_dev} \
			name 2 tiboot3 \
			name 1 bootloader

		dd if=${tiboot3bin} of=${sd_dev}2
		sync
		mkfs.vfat -F 32 -n "boot" "${sd_dev}1"
		mkdir boot
		mount  ${sd_dev}1 boot/
		cp ${tiboot3bin} boot/tiboot3.bin
		cp tispl-${board}.bin boot/tispl.bin
		cp u-boot-${board}.img boot/u-boot.img
		umount boot
		rm -r boot
		echo "Insert SD card on board, Power ON and interrupt U-Boot to go in console to do this command:"
		echo "=> mmc dev 0 0"
		echo "=> mmc erase 0 0x10000"
		echo "=> mmc dev 0 1"
		echo "=> mmc erase 0 0x10000"
		echo "=> env default -a"
		echo "=> setenv mmcdev 1; saveenv; reset;"
		echo " Interrupt U-boot  to go in console:"
		echo "=> fastboot 0"
		echo "When it's Done"
		read -p "Press any key to continue... " -n1 -s
	fi
		dd if=/dev/zero of=bootloader-${board}.img bs=1048576 count=8
		mkfs.vfat bootloader-${board}.img
		mcopy -i bootloader-${board}.img tispl-${board}.bin ::tispl.bin
		mcopy -i bootloader-${board}.img u-boot-${board}.img ::u-boot.img
		# Pre-packaged DB
		if [[ -x "fastboot" ]] && [[ ! -v FASTBOOT ]]; then
			export FASTBOOT="./fastboot"
		fi
		export FASTBOOT=${FASTBOOT-$(which fastboot)}
		export LD_LIBRARY_PATH=./

		echo "Fastboot: $FASTBOOT"
		echo "Image location: $PRODUCT_OUT"


		# =============================================================================
		# pre-run
		# =============================================================================

		# Verify fastboot program is available
		# Verify user permission to run fastboot
		# Verify fastboot detects a device, otherwise exit
		if [ -f ${FASTBOOT} ]; then
			fastboot_status=`${FASTBOOT} devices 2>&1`
			if [ `echo $fastboot_status | grep -wc "no permissions"` -gt 0 ]; then
				cat <<-EOF >&2
				-------------------------------------------
				Fastboot requires administrator permissions
				Please run the script as root or create a
				fastboot udev rule, e.g:

				% cat /etc/udev/rules.d/99_android.rules
				SUBSYSTEM=="usb",
				SYSFS{idVendor}=="0451"
				OWNER="<username>"
				GROUP="adm"
				-------------------------------------------
				EOF
				exit 1
			elif [ "X$fastboot_status" = "X" ]; then
				echo "No device detected. Please ensure that" \
					"fastboot is running on the target device"
						exit -1;
			else
				device=`echo $fastboot_status | awk '{print$1}'`
				echo -e "\nFastboot - device detected: $device\n"
			fi
		else
			echo "Error: fastboot is not available at ${FASTBOOT}"
				exit -1;
		fi

		# Create the filename
		if [[ "${hsfs}" == "true" ]]; then
			tiboot3bin="${PRODUCT_OUT}tiboot3-${board}-hsfs.bin"
		else
			tiboot3bin="${PRODUCT_OUT}tiboot3-${board}.bin"
		fi
		bootloaderimg="${PRODUCT_OUT}bootloader-${board}.img"
		userdataimg="${PRODUCT_OUT}userdata.img"
		superimg="${PRODUCT_OUT}super.img"
		bootimg="${PRODUCT_OUT}boot.img"
		vbmetaimg="${PRODUCT_OUT}vbmeta.img"
		dtboimg="${PRODUCT_OUT}dtbo.img"
		dtbouimg="${PRODUCT_OUT}dtbo-unsigned.img"
		persistimg="${PRODUCT_OUT}persist.img"

		# Verify that all the files required for the fastboot flash
		# process are available

		if [ ! -e "${tiboot3bin}" ] ; then
		echo "Missing ${tiboot3bin}"
		exit -1;
		fi
		if [ ! -e "${bootloaderimg}" ] ; then
		echo "Missing ${bootloaderimg}"
		exit -1;
		fi
		if [ ! -e "${superimg}" ] ; then
		echo "Missing ${superimg}"
		exit -1;
		fi
		if [ ! -e "${userdataimg}" ] ; then
		echo "Missing ${userdataimg}"
		exit -1;
		fi
		if [ ! -e "${bootimg}" ] ; then
		echo "Missing ${bootimg}"
		exit -1;
		fi
		if [ ! -e "${persistimg}" ] ; then
		echo "Missing ${persistimg}"
		exit -1;
		fi

		echo "Create GPT partition table"
		${FASTBOOT} oem format

		sleep 3

		echo "Flashing tiboot3....."
		echo "   tiboot3bin:     ${tiboot3bin}"
		${FASTBOOT} flash tiboot3	${tiboot3bin}

		sleep 3
		echo "   bootloader:  ${bootloaderimg}"
		${FASTBOOT} flash bootloader	${bootloaderimg}

		echo "Flash android partitions"
		${FASTBOOT} flash super	${superimg}

		echo "Flashing Boot Image"
		${FASTBOOT} flash boot_a ${bootimg}
		${FASTBOOT} flash boot_b ${bootimg}

		echo "Flashing userdata Image"
		${FASTBOOT} flash userdata ${userdataimg}

		if [ -e "${vbmetaimg}" ] ; then
			if [ ! -e "${dtboimg}" ] ; then
				echo "Missing ${dtboimg}"
				exit -1;
			fi
			echo "Flashing vbmeta Image"
			${FASTBOOT} flash vbmeta_a ${vbmetaimg}
			${FASTBOOT} flash vbmeta_b ${vbmetaimg}
			echo "Flashing DTBO Image"
			${FASTBOOT} flash dtbo_a ${dtboimg}
			${FASTBOOT} flash dtbo_b ${dtboimg}
		else
			if [ ! -e "${dtbouimg}" ] ; then
			echo "Missing ${dtbouimg}"
			exit -1;
			fi
			echo "Flashing DTBO Image Unsigned"
			${FASTBOOT} flash dtbo_a ${dtbouimg}
			${FASTBOOT} flash dtbo_b ${dtbouimg}
		fi

		echo "Flashing persist partition"
		${FASTBOOT} flash persist ${persistimg}

		echo "Erasing misc partitions"
		${FASTBOOT} erase misc

		echo "Formatting metadata partition"
		set +e
		${FASTBOOT} format metadata
		if [ $? -eq 1 ]; then
			echo "formating failed"
			${FASTBOOT} erase metadata

		fi
		set -e
}

if [ "$0" = "$BASH_SOURCE" ]; then
    main "$@"
fi
