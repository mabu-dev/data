#!/bin/bash
set -xe

# Call all the fetch data scripts and aggregate them into a single CSV file

BASE_DIR=`dirname "$0"`

# Delete all prior data from output folder
rm -rf "$BASE_DIR"/../output/*.csv "$BASE_DIR"/../output/*.json

# Run all fetch scripts from the input folder
TMP_FILE=`mktemp`
OUT_FILE="$BASE_DIR/../output/minimal.csv"
cat "$BASE_DIR/output_columns.csv" > $OUT_FILE
FETCH_SCRIPT_LIST="$BASE_DIR/fetch_data_*.sh"
for FETCH_SCRIPT in $FETCH_SCRIPT_LIST; do
    sh $FETCH_SCRIPT >> $TMP_FILE
done

# Aggregate all outputs into a single CSV file
sort -u $TMP_FILE >> $OUT_FILE

# TMP: Avoid deleting the old data.csv file in case someone was using it
python "$BASE_DIR"/format_data.py
