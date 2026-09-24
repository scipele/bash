#!/bin/bash

DOWNLOAD_DIR="/home/ts/Downloads"

# 1. Find the latest All-Accounts positions file
LATEST_FILE=$(ls -1t "$DOWNLOAD_DIR"/All-Accounts-Positions-*.csv 2>/dev/null | head -n 1)

if [[ -z "$LATEST_FILE" ]]; then
    echo "Error: No matching files found in $DOWNLOAD_DIR"
    read -p "Press Enter to close..."
    exit 1
fi

echo "Processing:"
echo "$LATEST_FILE"
echo

# 2. Remove blank lines, account-name lines, repeated headers,
#    cash rows, and Positions Total rows.
#
#    Output only the ticker from valid investment rows.

awk '
BEGIN {
    FS = ","
}
{
    # Remove CR from Windows-formatted files
    sub(/\r$/, "")

    # Remove completely empty lines
    if ($0 ~ /^[[:space:]]*$/)
        next

    # Remove the overall file title
    if ($0 ~ /^"Positions for All-Accounts/)
        next

    # Remove account-name lines
    if ($0 ~ /^"[^"]+ \.\.\.[0-9]+"/)
        next

    # Remove repeated column headers
    if ($0 ~ /^"Symbol","Description"/)
        next

    # Remove cash rows
    if ($0 ~ /^"Cash & Cash Investments"/)
        next

    # Remove totals rows
    if ($0 ~ /^"Positions Total"/)
        next

    # Get ticker
    ticker = $1

    # Remove quotes
    gsub(/"/, "", ticker)

    # Only output rows with a ticker
    if (ticker != "")
        print ticker
}
' "$LATEST_FILE" | paste -sd, -

echo
read -p "Press Enter to close..."