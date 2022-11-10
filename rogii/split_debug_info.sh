#!/bin/bash
# Function split the source binary with debug info to binary w/o it and debug info file
# like pdb files on windows. 
# Parameters: $1 - source binary file pathname.
# output: $1 - source binary without debug info
#           $1.dSYM - debug info

if [ -z "$1" ] ; then
    echo "ERROR: split_dbginfo: Parameter #1 is zero length."
    exit 0
fi

if [ ! -e "$1" ] ; then
    echo "ERROR: split_dbginfo: file '$1' does not exist!"
    exit 0
fi

FILE_TO_STRIP_PATH="$1"

LANG=C file -L $FILE_TO_STRIP_PATH | grep -v 'not stripped' > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${1} does not contain any debug information."
    exit 0
fi

TO_STRIP_PATH=`dirname "$FILE_TO_STRIP_PATH"`
TO_STRIP_FILE_NAME=`basename "$FILE_TO_STRIP_PATH"`

DEBUGINFO_FILENAME=`echo ${TO_STRIP_FILE_NAME} |sed 's/\.so\($\|\.\)/\.dSYM\1/'`
if [ x$DEBUGINFO_FILENAME == x$TO_STRIP_FILE_NAME ]; then
    DEBUGINFO_FILENAME=${TO_STRIP_FILE_NAME}.dSYM
fi

pushd "$TO_STRIP_PATH" > /dev/null 2>&1

objcopy --only-keep-debug "${TO_STRIP_FILE_NAME}" "${DEBUGINFO_FILENAME}"
strip --strip-debug --strip-unneeded "${TO_STRIP_FILE_NAME}"
objcopy --add-gnu-debuglink="./${DEBUGINFO_FILENAME}" "${TO_STRIP_FILE_NAME}"
chmod -x "./${DEBUGINFO_FILENAME}"

popd > /dev/null 2>&1