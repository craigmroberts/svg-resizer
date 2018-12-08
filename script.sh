#!/bin/bash

cwd=$(pwd)
size="$1"
which rsvg-convert > /dev/null 2>&1
if [[ ! $? -eq 0 ]]; then
    echo "rsvg-convert not installed."
    exit 1
elif [[ -z "$size" ]]; then
    echo "Please specify a size."
    exit 1
else

    echo "Starting to resize SVG files.."

    rm -rf "$size"

    old_ifs=${IFS}
    IFS=$'\n'

    echo "Copying folder structure"
    for directory in $( find . -type d ); do
      new_directory=$( echo ${directory} | sed "s%\./%$size/%" )
      mkdir -p "${new_directory}"
    done
    echo "Folder structure copied"

    echo "Resizing SVGs"
    IFS=${old_ifs}

      find . -maxdepth 10 -type f -name "*.svg" -print0 | while IFS= read -r -d '' file; do

          if [[ ! -h "$file" ]]; then

              comments=$(grep -o "<!--.*-->" "$file")

              rsvg-convert "$file" -w "$size" -h "$size" -f svg -o "$size/$file"

              #sed -i -e "s/<[?]\?xml[^>]*>//g" -e "s/${size}pt/${size}px/g" -e "1s/^/${comments}/" "$size/$file"
              echo "$file"
          else
              cp -rdf "$file" "${cwd}/${size}/"
          fi
      done

      echo "Resizing complete!"

      exit 0
fi
