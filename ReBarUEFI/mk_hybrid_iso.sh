#!/bin/bash -e

WORKSPACE="$(pwd)"
ISO_NAME="ReBarGrubShellEfi.iso"
ISO_STAGE="${WORKSPACE}"/iso_stage
IMG_STAGE="${WORKSPACE}"/img_stage
EFI_CONTENT="content"
EFI_BOOT_STRUCT="EFI/BOOT"
IMG_NAME="efi.img"
IMG_SIZE_MB=10
LABEL="ESP"

ISOLINUX_BIN="/usr/lib/ISOLINUX/isolinux.bin"
ISOHDPFX_BIN="/usr/lib/ISOLINUX/isohdpfx.bin"

echo "########################## INIT ##########################"

if [ ! -f "${ISOLINUX_BIN}" ]; then
    echo "${ISOLINUX_BIN} not found. Aborting..."
    exit 1
elif [ ! -f "${ISOHDPFX_BIN}" ]; then
    echo "${ISOHDPFX_BIN} not found. Aborting..."
    exit 1
fi

# Cleanup ISO STAGE
echo "Cleanup ${ISO_STAGE}"
rm -rf "${ISO_STAGE}"
mkdir -p "${ISO_STAGE}"

echo "Cleanup ${IMG_STAGE}"
rm -rf "${IMG_STAGE}"
mkdir -p "${IMG_STAGE}"

echo "########################## EFI.IMG ##########################"

echo "Create ${ISO_STAGE}/${IMG_NAME}"
dd if=/dev/zero of="${ISO_STAGE}"/"${IMG_NAME}" bs=1M count=$IMG_SIZE_MB

echo "Formatting IMAGE: ${ISO_STAGE}/${IMG_NAME}"
sudo mkfs.vfat -F16 -n "${LABEL}" "${ISO_STAGE}/${IMG_NAME}"

echo "Mounting IMAGE: ${IMG_NAME} -> ${IMG_STAGE}"
sudo mount -o loop,user,umask=0000 "${ISO_STAGE}/${IMG_NAME}" "${IMG_STAGE}"

echo "ADD CONTENT INTO IMAGE: ${ISO_STAGE}/${IMG_NAME}"
mkdir -p "${IMG_STAGE}"/"${EFI_BOOT_STRUCT}"
cp -r "${EFI_CONTENT}"/modGRUBShell.efi "${IMG_STAGE}"/"${EFI_BOOT_STRUCT}"/bootx64.efi
sync

echo "Unmounting IMAGE: ${ISO_STAGE}/${IMG_NAME}"
sudo umount "${IMG_STAGE}"

echo "########################## ISO STAGE ##########################"

echo "Copy 'isolinux.bin' into ${ISO_STAGE}..."
cp -r "${ISOLINUX_BIN}" "${ISO_STAGE}/"

echo "Build ISO ${ISO_NAME}..."
xorriso -as mkisofs -isohybrid-mbr "${ISOHDPFX_BIN}" \
    -b isolinux.bin \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-alt-boot \
    -e efi.img \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -o "${ISO_NAME}" \
    "${ISO_STAGE}"

echo "Cleanup ${ISO_STAGE}"
rm -rf "${ISO_STAGE}"

echo "Cleanup ${IMG_STAGE}"
rm -rf "${IMG_STAGE}"

echo "Build ISO ${ISO_NAME}...DONE!"


exit 0
