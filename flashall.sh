#!/bin/bash

usage ()
{
	echo "Usage: sudo flashall.sh <options>";
	echo "options:";
	echo "  --help Show this message and exit"
	exit 1;
}

#no args case
if [ "$1" = "--help" ] ; then
	usage
fi

# Pre-packaged DB
export FASTBOOT=${FASTBOOT-$(which fastboot)}
export PRODUCT_OUT=${PRODUCT_OUT-"./"}
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

# make bootloader image
# bootloader.img is FAT Image consisting
# u-boot.img and tispl.bin
dd if=/dev/zero of=bootloader.img bs=1048576 count=8
mkfs.vfat bootloader.img
mcopy -i bootloader.img tispl.bin ::tispl.bin
mcopy -i bootloader.img u-boot.img ::u-boot.img

## poll the board to find out its configuration
cpu=`${FASTBOOT} getvar cpu 2>&1         | grep cpu     | awk '{print$2}'`
cputype=`${FASTBOOT} getvar secure 2>&1  | grep secure  | awk '{print$2}'`
boardrev=`${FASTBOOT} getvar board_rev 2>&1  | grep board_rev  | awk '{print$2}' | cut -b 1`

# Create the filename
tiboot3bin="${PRODUCT_OUT}tiboot3.bin"
bootloaderimg="${PRODUCT_OUT}bootloader.img"
userdataimg="${PRODUCT_OUT}userdata.img"
superimg="${PRODUCT_OUT}super.img"
bootimg="${PRODUCT_OUT}boot.img"
vbmetaimg="${PRODUCT_OUT}vbmeta.img"

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
  echo "Flashing vbmeta Image"
  ${FASTBOOT} flash vbmeta_a ${vbmetaimg}
  ${FASTBOOT} flash vbmeta_b ${vbmetaimg}
fi

echo "Erasing misc partitions"
${FASTBOOT} erase misc

echo "Formatting metadata partition"
${FASTBOOT} format metadata
