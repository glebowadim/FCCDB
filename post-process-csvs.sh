#!/bin/bash
if [ "$#" -lt 1 ]
then
    echo "Usage: $0 <CSV files path>"
    exit 1
fi

SCRIPT_DIR="$(realpath "$(dirname "$0")")"

# Init config
source "$SCRIPT_DIR/config.sh"

CSV_PATH="$1"

function remove_tmp_files() {
    find "$CSV_PATH" -name '*.tmp' -delete || exit 40
}
trap remove_tmp_files EXIT

if [ "$(find "$CSV_PATH" -name '*.csv' | wc -l)" -eq 0 ]
then
    echo "No CSV files found."
    exit 0
fi

echo "Renaming CSV files for make correct imports run order..."

for CSV_FILE in $CSV_PATH/*.csv
do
    CSV_FNAME="$(basename "$CSV_FILE")"
    CSV_FNAME="${CSV_FNAME%.csv}"

    echo "Removing empty lines from $CSV_FNAME..."
    CSV_TMP_FILE="${CSV_FILE}.tmp"
    grep -v '^$' "$CSV_FILE" > "$CSV_TMP_FILE"
    rm -f "$CSV_FILE" || exit 41

    ORDER_NUM="${IMP_ORDER[$CSV_FNAME]}"
    if [ "$ORDER_NUM" != "" ]
    then
        echo "Setting order $ORDER_NUM for $CSV_FNAME..."
        mv "$CSV_TMP_FILE" "$CSV_PATH/${ORDER_NUM}_${CSV_FNAME}.csv" || exit 42
    else
        mv "$CSV_TMP_FILE" "$CSV_FILE" || exit 42
    fi
done
