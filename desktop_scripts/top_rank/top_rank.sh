echo "This script will display the top-ranked stocks based on recent performance."
TOP_RANK_FILE_PATH="/home/dev/stock/buy_opp/output"

read -p "How many top stocks would you like to see? " num_stocks

if ! [[ "$num_stocks" =~ ^[0-9]+$ ]]; then
    echo "Please enter a valid number."
    exit 1
fi

echo "Fetching the top $num_stocks stocks..."

# Get the top-ranked stocks from the summary_all.csv file, 
# skipping the header and extracting the third column (stock names),
# then limiting the output to the specified number of stocks and formatting it as a comma-separated list.
# NR>1 ensures that the header row is skipped, and paste -sd "," - combines the output into a single line with commas.
# head -n "$num_stocks" limits the output to the specified number of stocks.

awk -F ',' 'NR>1 {print $3}' "$TOP_RANK_FILE_PATH/summary_all.csv" | head -n "$num_stocks" | paste -sd "," -

read -p "Press any key to exit..."
