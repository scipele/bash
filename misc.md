# Some Useful Bash Terminal Commands


## A
```bash
awk -F ',' '{print $1, $4}' users.csv  # print 2nd/4th columns using 'commas separ', use the -F flag to tell awk to split columns:
# awk stands for the last names of the three computer scientists who created it at Bell Labs in 1977:Aho (Alfred Aho)Weinberger (Peter # Weinberger)Kernighan (Brian Kernighan)
```
## B
```bash
bc                                    # calculator  '+/-' add/sub, '*/' mult/div, '^' pwr, sqrt(2.0000), % mod
bc -l                                 # invokes extended math functions
echo "scale=4; 10 / 3" | bc           # Out: 3.3333
pi=$(bc -l <<< "scale=15; 4 * a(1)")  # Computes pi and assigns to var 'pi'
echo "scale=15; s($pi / 4)" | bc -l   # .707106781186547, see above for 'pi' assignment
echo "2*c(30*$pi/180)" | bc -l        # Out: 1.73205080756887749994, Solves 30-60-90 Triangle for sqrt(3) side len = sqrt(3)
echo "scale = 15; sqrt(3)" | bc -l    # Out: 1.732050807568877
echo "scale=15; 4*a(1)" | bc -l       # 3.14159265358976 (PI)
```
## C
```bash
# The following requires installation of ncal
cal -y        # Display's a year calendar
cal -y 2027   # Display's a year calendar for a specific year

# merge all into one single file, keep the header from the first file and append only the data from the second file.
cat f1.csv <(tail -n +2 f2.csv) > combined.csv

# lists the text in a file, then sorts the lines, provides only the unique lines (required prior sort)
cat f1.csv | sort | uniq

# Create a new text file and add content to it, you can use the following command:
cat > filename.txt # Then type text that you want to add on as many lines as you want
Line 1
Line 2
# Press Ctrl+D to save and exit.

# To append content to an existing text file, you can use the following command:
cat >> filename.txt
  Add Line 3
  Add Line 4
  ## Press Ctrl+D to save and exit.

# changing file permissions:
chmod 777 fileName  # Changes file priveledges for all users to read/write/execute (Usually frowned upon for security reasons)
#     |||
#     ||+------------------ Represents the Owner of the file
#     |+------------------- Respresents the Group the file belongs to
#     +-------------------- Represents Others (anyone else on the system)
#  Numeric Values are octal representations with the following meanings:
# The numbers are calculated by adding the assigned octal values for Read (4), Write (2), and Execute (1).
#                           Description               (chr)   (octal)   
# 0 ----------------------- No permissions            (---)   (0)
# 1 ----------------------- Execute only              (--x)   (1)
# 2 ----------------------- Write only                (-w-)   (2)
# 3 ----------------------- Write and Execute         (-wx)   (1+2=3)
# 4 ----------------------- Read only                 (r--)   (4)
# 5 ----------------------- Read and Execute          (r-x)   (4+1=5)
# 6 ----------------------- Read and Write            (rw-)   (4+2=6)
# 7 ----------------------- Read, Write, and Execute  (rwx)   (1+2+4=7)

# setting permissions with octal values directly
chmod 664 fileName          
# '-rw-rw-r--'              # properties show in this letter format when using ls -l
#   || || |
#   || || +---------------- others read
#   || |+------------------ group write
#   || +------------------- group read
#   |+--------------------- owner write
#   +---------------------- owner read
chmod 644 document.txt      # Owner can read and write; Group and Others can only read
chmod 600 private.key       # Owner can read and write; Group and Others have zero access
chmod -R 755 /var/www/html  # Applies the permissions to the folder, subfolders, and all contained files

# using letter designations to change permissions:
chmod u+x file.sh           # Add execute permission for the owner
chmod g+w file.txt          # Add write permission for the group
chmod o+r file.txt          # Add read permission for others
chmod a+x script.sh         # Add execute permission for everyone
chmod +x script.sh          # Adds execute permission for all users
chmod u+w report.txt        # Adds write permission for the owner only
chmod g-w,o-r data.log      # Removes group write and removes others read simultaneously
chmod o=r public.txt        # Sets others permission strictly to read-only

# using numeric octal addition to change permissions:
chmod +111 file             # Add execute permission for owner, group, and others
chmod -022 file             # Remove write permission for group and others
chmod +004 file             # Add read permission for others

clear                       # clears the screen

# navigating file paths:
cd ~/Documents              # Changes the current path to ('~' Shortcut to User) and other folder
cd ..                       # Go Back one level
cd                          # Go back to home folder
cd ~                        # Go Back to home folder
cd ../.. – Moves up two levels at once.
```
## D
```bash
# date usage
echo $(( ( $(date -d "2026-12-25" +%s) - $(date -d "2026-07-19" +%s) ) / 86400 )) # Computes number of days between two dates
# you can also download 'dateutils'
```
## E
```bash
echo "text to be added to the file" > f1.txt # places text in a text file
```
## F
```bash
find . -type f -exec stat --printf='%y %12s %n\n' {} + #
# .  Starts a search in the current directory (.)
# -type f: Filters the search to look only for regular files (excluding directories or links).
# -exec ... {} +: Runs the specified command (stat) on all the files found, grouping them together for speed.stat:
#     A utility used to display detailed file or file system status.
# --printf="...": Formats the output using specific placeholders (similar to the programming language C):
# %y: Displays the human-readable date and time of the last data modification. %12s: Displays the file size in bytes, padded with spaces to be exactly 12 characters wide 
# %n: Displays the file name (including its relative path).\n: Moves to a new line for each file.

find . -type f,             # This recursively finds all regular files (excluding directories) starting from the current directory (.).
find . -name "my_file.txt"  # find file by name
find . -type f -exec sha1sum {} + | sort | uniq -w 40 -D  # hash files showing only duplicates

# remove duplicates recursively based on sha1 hashes
find . -type f -exec sha1sum {} + | sort | awk 'BEGIN {FS="  "} {hash=$1; file=substr($0, 43); if (seen[hash]++) { print "Deleting: " file; system("rm \"" file "\"") } else { print "Keeping:  " file }}'

# list bare file names only (without paths) in the current directory and its subdirectories:
find . -type f -printf "%f\n" > list.txt
# find .,                   # Searches recursively starting from the current directory (.).
# -type f,                  Restricts the results to only files (excluding directories).
# -printf "%f\n",           Prints only the bare filename (%f) followed by a newline character (\n) for each result. 
# > list.txt,               Redirects the output to a file named 'list.txt'.

# List the file name and the content of each file
for file in f1.csv f2.csv; do echo "Filename: $file"; cat "$file"; echo ""; done
```
## G
```bash
grep -r "search_string" .   # search string in files within the current dir and its subdirectories (-r):
```
## H
```bash
head -n 10 filename.txt     # Displays the first 10 lines of the file
```
## I
```bash
info                        # Reads documentation and manuals in the Info format (similar to man).
```
## J
```bash
join -t, file1.csv file2.csv
join  # Merges lines of two sorted files based on a common database field.
```
## K
```bash
kill # : Sends a specific signal (like termination or manual stop) to a running process ID (PID).
```
## L
```bash
locate ls

ls                          # lists files
ls -l                       # lists files long format
ls -1                       # lists files vertically
ls -R                       # lists files recursively
ls -lR                      # lists files in long format and recursively
ls -laR                     # lists files in long format and recursively
ls -R /path/to/directory    # Target a specific path
```
## M
```bash
mkdir "my folder name"      # create folder that has spaces in it
mkdir my_folder             # create folder that does not have spaces in it
```
## N
```bash
nano filename.txt           # edit a text file
nl | grep -n "hat" *.txt    # shows the line number of any *.txt
```
## O
```bash
# Operator '>'
> 'out.txt'     # Redirects the output from the terminal to a file

# pipe operator ('|') sends the output of the first command as the input to the second command
ls | grep "contact" # list file names in the current path that contain 'contact' in the filename 
```
## P
```bash
pwd       # Print Working Directory
```
## Q
```bash
q         # quits while viewing manual
quit      # exits the bc calculator
```
## R
```bash
rmdir "my folder name"      # remove folder that has spaces in it
rmdir my_folder             # remove folder that does not have spaces in it
```
## S
```bash
sha1sum * # hashes files in the current path
sudu      # Superuser Do, Linux equivalent of clicking "Run as Administrator" in Windows

# find and replace using 'sed'
sed -i 's/old_string/new_string/g' filename.txt
sort f1.csv | uniq
```

## T
```bash
tail -n 10 filename.txt   # Displays the last 10 lines of the file
tail -n +2 f1.csv | sort | uniq  # Skips the line 1( i.e. header) with number of lines 2 and greater ('-n +2'), sorts, shows unique only

# tape archive
tar -cvf zp.tar *.pdf   # zips pdfs to an archive named zp.tar  see typical flags as noted below
#-c: Create a new archive
#-x: Extract files from an existing archive
#-t: List contents of an archive without extracting it
#-v: Verbose mode; displays progress and file names on-screen
#-f: Specifies the archive's filename (must always be placed immediately before the filename)
#-z: Compresses or decompresses using Gzip (.tar.gz or .tgz)
# -j: Compresses or decompresses using Bzip2 (.tar.bz2)
```
## U
```bash
uptime              # shows the uptime for the current user
uniq                # see usage in other piped commands
unzip bu.zip *.csv  # unzips the archive into the current path
unzip ../bu.zip     # unzips the archive in the parent folder to the current folder
```
## V
```bash
# Vim is a text editor that requires a download
vim f1.csv
x: Delete the single character under the cursor.dd: Delete (cut) the entire current line.u: Undo the last action.Ctrl + r: Redo the last undone action
.yy: Copy (yank) the current line.p: Paste the copied text below the current line.
# Saving and Quitting (From Normal Mode) To type these, press
: first to open the command line at the bottom of the screen
::w: Save the file (write).
:q: Quit Vim (fails if you have unsaved changes)
:wq: Save and quit at the same time.
:q!: Quit without saving (discards all changes).
```
## W
```bash
whoami          # echo the user name
whereis g++     # provides the path of any file
wc -c f1.csv    # counts characters
wc -l f1.csv    # counts lines
wc -w names.txt # counts words
```
## X
```bash
xxd f1.csv                          # Creates a hex dump of a given file or standard input
xxd -r hex_output.txt restored.bin  # Convert Hex Back to Binary:The -r flag stands for "reverse"
xxd -b example.bin                  # displays the binary content of the file
```
## Y
```bash
yes | rm -i *.txt # Repeatedly outputs a string (or "y" by default) until killed. Used to automate interactive prompts.
```
## Z
```bash
zip bu.zip f1.csv f2.csv  # creates a zip of named files
```

