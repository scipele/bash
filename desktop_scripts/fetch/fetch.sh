#!/bin/bash

# Navigate to project directory
cd /home/dev/cpp/stock || exit

# Run the compiled C++ program
./fetch

# Define input and output file paths
CSV_FILE="/home/dev/cpp/stock/output/summary_all.csv"
HTML_FILE="/home/dev/cpp/stock/output/summary_report.html"

# Verify CSV exists before processing
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: $CSV_FILE not found!"
    exit 1
fi

# ============================================================
# Extract ticker lists from CSV sections
# ============================================================

get_tickers() {
    local section="$1"

    awk -v section="$section" '
        $0 == section {found=1; next}
        found && /^===/ {exit}
        found && /^Rank,/ {next}
        found && NF {
            split($0,a,",")
            printf "%s,", a[2]
        }
    ' "$CSV_FILE" | sed 's/,$//'
}

top_short=$(get_tickers "=== TOP 20 SHORT TERM ===")
top_long=$(get_tickers "=== TOP 20 LONG TERM ===")
top_combo=$(get_tickers "=== TOP 20 COMBINED ===")


# Start writing the HTML document
cat << EOF > "$HTML_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Stock Fetcher Summary Report</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: #f4f6f9; margin: 0; padding: 30px; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 { text-align: center; color: #1e293b; margin-bottom: 30px; font-weight: 700; }
        h2 { background-color: #2563eb; color: white; padding: 12px 20px; border-radius: 6px; margin-top: 40px; margin-bottom: 15px; font-size: 1.25rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .table-container { background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.95rem; }
        th { background-color: #f8fafc; color: #64748b; font-weight: 600; padding: 14px 20px; border-bottom: 2px solid #e2e8f0; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; }
        td { padding: 12px 20px; border-bottom: 1px solid #edf2f7; color: #334155; }
        tr:hover { background-color: #f8fafc; }
        tr:last-child td { border-bottom: none; }
        .num { font-variant-numeric: tabular-nums; text-align: right; }
        th.num { text-align: right; }
    </style>
</head>
<body>
<div class="container">

<h1>🚀 Stock Fetcher Analytics</h1>

<!-- Top ticker summary -->
<div class="table-container">
<table>
<thead>
<tr>
    <th>Category</th>
    <th>Tickers</th>
</tr>
</thead>
<tbody>
<tr>
    <td>Top Short</td>
    <td>${top_short}</td>
</tr>
<tr>
    <td>Top Long</td>
    <td>${top_long}</td>
</tr>
<tr>
    <td>Top Combo</td>
    <td>${top_combo}</td>
</tr>
</tbody>
</table>
</div>

EOF


# Parse the file line-by-line using a state machine loop
in_table=0

while IFS= read -r line || [ -n "$line" ]; do

    # Trim carriage returns if present
    line=$(echo "$line" | tr -d '\r')

    # Skip empty lines
    if [ -z "$line" ]; then
        continue
    fi

    # Detect section header
    if [[ "$line" =~ ===(.*)=== ]]; then

        if [ $in_table -eq 1 ]; then
            echo "</tbody></table></div>" >> "$HTML_FILE"
            in_table=0
        fi

        section_title="${BASH_REMATCH[1]}"
        echo "<h2>${section_title}</h2>" >> "$HTML_FILE"


    # Detect table header
    elif [[ "$line" =~ ^Rank, ]]; then

        in_table=1

        echo "<div class='table-container'><table><thead><tr>" >> "$HTML_FILE"

        IFS=',' read -r -a headers <<< "$line"

        for header in "${headers[@]}"; do

            if [[ "$header" != "Rank" && "$header" != "Ticker" ]]; then
                echo "<th class='num'>$header</th>" >> "$HTML_FILE"
            else
                echo "<th>$header</th>" >> "$HTML_FILE"
            fi

        done

        echo "</tr></thead><tbody>" >> "$HTML_FILE"


    # Process data rows
    elif [ $in_table -eq 1 ]; then

        echo "<tr>" >> "$HTML_FILE"

        IFS=',' read -r -a cells <<< "$line"

        count=0

        for cell in "${cells[@]}"; do

            if [ $count -gt 1 ]; then
                echo "<td class='num'>$cell</td>" >> "$HTML_FILE"
            else
                echo "<td>$cell</td>" >> "$HTML_FILE"
            fi

            ((count++))

        done

        echo "</tr>" >> "$HTML_FILE"

    fi

done < "$CSV_FILE"


# Close final table
if [ $in_table -eq 1 ]; then
    echo "</tbody></table></div>" >> "$HTML_FILE"
fi


cat << EOF >> "$HTML_FILE"

</div>
</body>
</html>

EOF


echo "HTML report compiled successfully at $HTML_FILE"


# Launch Google Chrome
google-chrome --new-window "$HTML_FILE" &