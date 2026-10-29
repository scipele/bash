#!/bin/bash

# Navigate to the directory where your files are located (optional)
# cd /path/to/your/folder

# Delete files matching the transactions pattern
rm -f /home/ts/Downloads/*_Transactions_*.csv

# Delete files matching the positions pattern
rm -f /home/ts/Downloads/*-Positions-*.csv

echo "Cleanup complete!"
