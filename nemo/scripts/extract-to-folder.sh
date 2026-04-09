#!/bin/bash
# Extract archive to a subfolder named after the archive

for FILE in "$@"; do
    DIR=$(dirname "$FILE")
    BASENAME=$(basename "$FILE")
    # Strip known archive extensions
    FOLDERNAME="${BASENAME%.zip}"
    FOLDERNAME="${FOLDERNAME%.tar.gz}"
    FOLDERNAME="${FOLDERNAME%.tar.bz2}"
    FOLDERNAME="${FOLDERNAME%.tar.xz}"
    FOLDERNAME="${FOLDERNAME%.tar.zst}"
    FOLDERNAME="${FOLDERNAME%.tar}"
    FOLDERNAME="${FOLDERNAME%.7z}"
    FOLDERNAME="${FOLDERNAME%.rar}"
    FOLDERNAME="${FOLDERNAME%.tgz}"

    DEST="$DIR/$FOLDERNAME"
    mkdir -p "$DEST"
    file-roller --extract-to="$DEST" "$FILE"
done
