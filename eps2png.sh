
#!/usr/bin/env bash

set -euo pipefail

DIR="${1:-screenshots}"
DPI="${2:-300}"

find "$DIR" -type f -iname "*.eps" -print0 |
while IFS= read -r -d '' file; do
    folder=$(basename "$(dirname "$file")")
    filename=$(basename "${file%.*}")

    output="$(dirname "$file")/${folder}_${filename}.png"

    echo "Converting: $file"
    echo "       ->   $output"

    gs -dSAFER -dBATCH -dNOPAUSE -dQUIET \
       -dEPSCrop \
       -sDEVICE=pngalpha \
       -r"$DPI" \
       -sOutputFile="$output" \
       "$file"
done

echo "Conversion complete!"
