#!/bin/bash

# Project number
project="project4"

# Function to display help
show_help() {
  echo "Usage: $0 [-h] <student_number>"
  echo "Compress 'src' directory and 'report.pdf' for submission."
  echo "Example: $0 1234-56789"
  echo "Options:"
  echo "  -h    Show this help message"
}

# Check if -h option is provided
if [[ "$1" == "-h" ]]; then
  show_help
  exit 0
fi

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
  show_help
  exit 1
fi

# Check the current directory
if [[ $(basename "$PWD") != "$project" ]]; then
  echo "$0: Please run this script from the ${project} directory"
  exit 1
fi

# Check if src directory exists
if [ ! -d "src" ]; then
  echo "$0: Cannot find src directory. Please make sure it exists in the ${project} directory."
  exit 1
fi

reportfile=$(find . -name "report.pdf") # Report

if ! echo ${reportfile} | grep -q .; then
  echo "$0: Cannot find report.pdf. Please make sure it is placed in the ${project} or its subdirectories."
  exit 1
fi

zipfile=${project}_${1}.zip # Compressed file name

pushd src > /dev/null && \
make clean

if ! make; then
  echo "$0: Cannot compile. Please make sure your code compiles successfully."
  exit 1
fi

make clean && \
popd > /dev/null && \
rm -f ${zipfile} && \
zip -r ${zipfile} src && \
zip -j ${zipfile} ${reportfile}

if [[ "$?" = "0" ]] ; then
  echo "Prepared for submission. Please submit ${zipfile} on eTL."
fi
