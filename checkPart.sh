#! /bin/sh
# 2024-03-09	updated /boot/firmware/cmdline.txt

#	Check consistency of Disk identifier in cmdline.txt /etc/fstab

# Determine Disk identifier
DISKID=$(sudo fdisk -l /dev/mmcblk0 | awk '/Disk identifier/ {print $3};' | sed 's/0x//')


# Use sed to delete all BEFORE PARTUUID= and all AFTER -0  in cmdline.txt
if [ -e /boot/firmware/cmdline.txt ]; then
	ROOTPART=$(sed -e 's/^.*PARTUUID=//' -e 's/-0.*$'// /boot/firmware/cmdline.txt)
else
	ROOTPART=$(sed -e 's/^.*PARTUUID=//' -e 's/-0.*$'// /boot/cmdline.txt)
fi
echo "Disk ID\t\t"$DISKID
echo "root PARTUUID\t"$ROOTPART

# find first PARTUUID ext4 in /etc/fstab
EXISTFSTABPART=$(awk '/PARTUUID.*ext4/ {print $1; exit};' /etc/fstab | sed -e 's/^.*PARTUUID=//' -e 's/-0.*$'//)

echo "Existing fstab\t"$EXISTFSTABPART

if [ $DISKID = $EXISTFSTABPART ]; then
	echo "Looks OK!"
fi
