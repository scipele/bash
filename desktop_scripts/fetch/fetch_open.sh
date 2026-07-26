#!/bin/bash

# Define  file paths
HTML_FILE="/home/dev/cpp/stock/output/summary_report.html"

echo "Open previously generated HTML report: $HTML_FILE"

# Launch Google Chrome in a new window with the generated HTML page
google-chrome --new-window "$HTML_FILE" &
