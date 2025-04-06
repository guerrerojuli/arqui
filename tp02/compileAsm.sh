#!/bin/bash

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <argument>"
    exit 1
fi

# Assign the first argument to a variable
FILE="$1"
NAME="${FILE%.asm}"

nasm -g -f elf32 "$NAME".asm -o out/"$NAME".o
if [ $? -ne 0 ]; then
	exit 1
fi

nasm -g -f elf32 lib.asm -o out/lib.o
if [ $? -ne 0 ]; then
	exit 1
fi

ld -m elf_i386 out/"$NAME".o out/lib.o -o bin/"$NAME"
if [ $? -ne 0 ]; then
	exit 1
fi

chmod u+x bin/"$NAME"
echo "$NAME" "compiled sucessfully you can find it on" "bin/$NAME" 
