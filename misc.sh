# Bash Terminal

## remove duplicates recursively based on sha1 hashes
find . -type f -exec sha1sum {} + | sort | awk 'BEGIN {FS="  "} {hash=$1; file=substr($0, 43); if (seen[hash]++) { print "Deleting: " file; system("rm \"" file "\"") } else { print "Keeping:  " file }}'

## hash files in path
sha1sum *

## hash files showing only duplicates
find . -type f -exec sha1sum {} + | sort | uniq -w 40 -D

## hash files recursively

## Various Commands
Command to list all files in the current directory and its subdirectories,displaying their last modification date, size, and name.  
-   find . -type f -exec stat --printf='%y %12s %n\n' {} +
-   Explanation of the command components:
-   find . -type f,        This recursively finds all regular files (excluding directories) starting from the current directory (.).
-   find . -type f,        This recursively finds all regular files (excluding directories) starting from the current directory (.).
-   -exec ... {} +,        This executes the specified stat command for the found files. Using + is more efficient than ; as it passes multiple file names at once.
-   stat --printf='...',   The GNU stat command's --printf option allows for highly customizable output using format specifiers.
-   %Y-%m-%d %H:%M:%S,     Formats the file's modification date and time into YYYY-MM-DD HH:MM:SS format.
-   %12s,                  Prints the file size in bytes, right-aligned with a minimum width of 12 characters.
-   %n,                    Prints the file name.
-   \n,                    Inserts a newline character at the end of each line for proper formatting. 

## Command to save the output to a file named 
- > 'out.txt'

## list bare file names only (without paths) in the current directory and its subdirectories:
- find . -type f -printf "%f\n" > list.txt
- Explanation of the command components:
- find .,                Searches recursively starting from the current directory (.).
- -type f,               Restricts the results to only files (excluding directories).
- -printf "%f\n",        Prints only the bare filename (%f) followed by a newline character (\n) for each result. 
- > list.txt,            Redirects the output to a file named 'list.txt'.

## search for a file named 'my_file.txt' in the current directory and its subdirectories:
- find . -name "my_file.txt"

## Edit a text file
- nano filename.txt

## To create a new text file and add content to it, you can use the following command:
- cat > filename.txt
# Add Line 1
# Add Line 2
# Press Ctrl+D to save and exit.

## To append content to an existing text file, you can use the following command:
- cat >> filename.txt
# Add Line 3
# Add Line 4
# Press Ctrl+D to save and exit.

## find and replace a string in a text file using sed:
- sed -i 's/old_string/new_string/g' filename.txt   

## using grep to search for a specific string in all files within the current directory and its subdirectories:
- grep -r "search_string" .

## use combination of nl and grep to search for a specific string in all files 
# within the current directory and its subdirectories, while also displaying line numbers:
# how about the working director only? use -maxdepth 1 to limit the search to the current directory only
- nl -ba -s ': ' $(find . -maxdepth 1 -type f) | grep "search_string"

## Using head/tail to view the first or last few lines of a file:
- head -n 10 filename.txt   # Displays the first 10 lines of the file
- tail -n 10 filename.txt   # Displays the last 10 lines of the file
