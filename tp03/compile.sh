#!/usr/bin/env bash

# Script: build.sh
# Uso: ./build.sh [-o output_binary] [-a 32|64] file1.asm file2.c file3.asm ...
#
# Este script compila archivos de ensamblador (.asm) y C (.c) en archivos objeto,
# almacenándolos en el directorio "out/", y luego los enlaza en un binario
# almacenado en el directorio "bin/". Si no se proporciona un nombre de salida con -o,
# se utiliza "program" por defecto. Por defecto compila para 32 bits, pero se puede
# cambiar a 64 bits con la opción -a.

# Salir inmediatamente si algún comando falla.
set -e

# Nombre binario por defecto
BIN_NAME="program"
# Arquitectura por defecto
ARCH="32"

# Procesar opciones: -o para el nombre del binario, -a para la arquitectura (32 o 64)
while getopts "o:a:" opt; do
  case $opt in
    o)
      BIN_NAME="$OPTARG"
      ;;
    a)
      if [ "$OPTARG" != "32" ] && [ "$OPTARG" != "64" ]; then
        echo "La arquitectura debe ser 32 o 64."
        exit 1
      fi
      ARCH="$OPTARG"
      ;;
    *)
      echo "Uso: $0 [-o output_binary] [-a 32|64] file1.asm file2.c ..."
      exit 1
      ;;
  esac
done

# Eliminar las opciones procesadas
shift $((OPTIND - 1))

# Verificar que se haya proporcionado al menos un archivo fuente
if [ $# -lt 1 ]; then
  echo "Uso: $0 [-o output_binary] [-a 32|64] file1.asm file2.c ..."
  exit 1
fi

# Crear directorios para archivos objeto y el binario si no existen
mkdir -p out bin

# Array para almacenar las rutas de los archivos objeto
OBJ_FILES=()

# Determinar las banderas y formato según la arquitectura
if [ "$ARCH" = "64" ]; then
  NASM_FORMAT="elf64"
  GCC_FLAG="-m64"
else
  NASM_FORMAT="elf32"
  GCC_FLAG="-m32"
fi

# Procesar cada archivo fuente proporcionado
for SRC_FILE in "$@"; do
  # Comprobar si el archivo existe
  if [ ! -f "$SRC_FILE" ]; then
    echo "Archivo no encontrado: $SRC_FILE"
    continue
  fi

  # Determinar la extensión y el nombre base
  EXT="${SRC_FILE##*.}"
  BASENAME=$(basename "$SRC_FILE" ."$EXT")
  OBJ_FILE="out/${BASENAME}.o"

  case "$EXT" in
    asm)
      echo "Ensamblando $SRC_FILE -> $OBJ_FILE"
      nasm -f "$NASM_FORMAT" "$SRC_FILE" -o "$OBJ_FILE"
      OBJ_FILES+=("$OBJ_FILE")
      ;;
    c)
      echo "Compilando $SRC_FILE -> $OBJ_FILE"
      gcc "$GCC_FLAG" -c "$SRC_FILE" -o "$OBJ_FILE"
      OBJ_FILES+=("$OBJ_FILE")
      ;;
    *)
      echo "Omitiendo archivo de tipo desconocido: $SRC_FILE"
      ;;
  esac
done

# Enlazar todos los archivos objeto en el binario final
echo "Enlazando archivos objeto en bin/$BIN_NAME..."
gcc "$GCC_FLAG" -no-pie "${OBJ_FILES[@]}" -o "bin/${BIN_NAME}"

echo "Compilación completada. Ejecuta bin/${BIN_NAME} para iniciar el programa."
