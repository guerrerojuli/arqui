#!/usr/bin/env bash

# Script: build.sh
# Usage: ./build.sh [-o output_binary] file1.asm file2.c file3.asm ...
#
# This script compiles assembly (.asm) and C (.c) files into object files,
# storing them in the "out/" directory, then links them into a binary
# stored in the "bin/" directory. If no output binary name is provided with -o,
# the default name "program" is used.

# Exit immediately if any command fails.
set -e

# Default binary name
BIN_NAME="program"

# Process optional output binary name (-o)
while getopts "o:" opt; do
  case $opt in
    o)
      BIN_NAME="$OPTARG"
      ;;
    *)
      echo "Usage: $0 [-o output_binary] file1.asm file2.c ..."
      exit 1
      ;;
  esac
done

# Shift out the processed options
shift $((OPTIND - 1))

# Ensure at least one source file is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 [-o output_binary] file1.asm file2.c ..."
  exit 1
fi

# Create directories for object files and binary if they don't exist
mkdir -p out bin

# Array to hold the object file paths
OBJ_FILES=()

# Iterate over each provided source file
for SRC_FILE in "$@"; do
  # Check if the file exists
  if [ ! -f "$SRC_FILE" ]; then
    echo "File not found: $SRC_FILE"
    continue
  fi

  # Determine file extension and base name
  EXT="${SRC_FILE##*.}"
  BASENAME=$(basename "$SRC_FILE" ."$EXT")
  OBJ_FILE="out/${BASENAME}.o"

  case "$EXT" in
    asm)
      echo "Assembling $SRC_FILE -> $OBJ_FILE"
      nasm -f elf32 "$SRC_FILE" -o "$OBJ_FILE"
      OBJ_FILES+=("$OBJ_FILE")
      ;;
    c)
      echo "Compiling $SRC_FILE -> $OBJ_FILE"
      gcc -m32 -c "$SRC_FILE" -o "$OBJ_FILE"
      OBJ_FILES+=("$OBJ_FILE")
      ;;
    *)
      echo "Skipping unknown file type: $SRC_FILE"
      ;;
  esac
done

# Link all object files into the final binary
echo "Linking object files into bin/$BIN_NAME..."
gcc -m32 -no-pie "${OBJ_FILES[@]}" -o "bin/${BIN_NAME}"

echo "Build complete. Run bin/${BIN_NAME} to execute."
