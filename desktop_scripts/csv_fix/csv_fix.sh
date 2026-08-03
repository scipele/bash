#!/bin/bash

read -p "Enter the full path of the input CSV file: " input_file

if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found."
    exit 1
fi

read -p "Maximum table width (press Enter for automatic): " max_width


gawk -v MAX_WIDTH="$max_width" '

##################################################
# Trim whitespace
##################################################

function trim(s)
{
    gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", s)
    return s
}


##################################################
# CSV parser supporting quoted commas
##################################################

function parse_csv(line, fields,    i,c,quote,value,count)
{
    quote=0
    value=""
    count=0

    for(i=1;i<=length(line);i++)
    {
        c=substr(line,i,1)

        if(c=="\"")
        {
            quote=!quote
        }
        else if(c=="," && !quote)
        {
            count++
            fields[count]=trim(value)
            value=""
        }
        else
        {
            value=value c
        }
    }

    count++
    fields[count]=trim(value)

    return count
}


##################################################
# Determine wrapped lines
##################################################

function wrap_text(text,width,arr,    words,i,line,count)
{
    delete arr

    if(width < 1)
        width=1

    count=0
    line=""

    n=split(text,words," ")

    for(i=1;i<=n;i++)
    {
        if(line=="")
        {
            line=words[i]
        }
        else if(length(line " " words[i]) <= width)
        {
            line=line " " words[i]
        }
        else
        {
            count++
            arr[count]=line
            line=words[i]
        }
    }

    if(line!="")
    {
        count++
        arr[count]=line
    }

    if(count==0)
    {
        count=1
        arr[1]=""
    }

    return count
}


##################################################
# Print table separator
##################################################

function print_separator(    c,j)
{
    for(c=1;c<=cols;c++)
    {
        printf "+"

        for(j=1;j<=width[c]+2;j++)
            printf "-"

    }

    print "+"
}


##################################################
# Print one table row
##################################################

function print_row(r,    line,c,value)
{

    for(line=1; line<=row_height[r]; line++)
    {

        for(c=1;c<=cols;c++)
        {

            printf "| "

            if(line <= line_count[r,c])
                value=wrapped[r,c,line]
            else
                value=""


            if(r>1 && value ~ /^[+-]?[0-9]*\.?[0-9]+$/)
            {
                printf "%*s", width[c], value
            }
            else
            {
                printf "%-" width[c] "s", value
            }

            printf " "

        }

        print "|"

    }
}


##################################################
# Read CSV
##################################################

{
    n=parse_csv($0,tmp)

    if(n>cols)
        cols=n

    for(i=1;i<=n;i++)
    {
        data[NR,i]=tmp[i]

        if(length(tmp[i]) > width[i])
            width[i]=length(tmp[i])

        if(NR==1)
            header[i]=length(tmp[i])
    }

    rows=NR
}


##################################################
# Optimize widths
##################################################

END {

    ##################################################
    # Optimize widths
    ##################################################

    total=1

    for(i=1;i<=cols;i++)
        total+=width[i]+3


    if(MAX_WIDTH!="" && MAX_WIDTH>0)
    {

        while(total>MAX_WIDTH)
        {

            largest=1

            for(i=2;i<=cols;i++)
            {
                if(width[i]>width[largest])
                    largest=i
            }


            minimum=header[largest]

            if(minimum<10)
                minimum=10


            if(width[largest]<=minimum)
                break


            width[largest]--
            total--

        }
    }


    ##################################################
    # Prepare wrapped rows
    ##################################################

    for(r=1;r<=rows;r++)
    {

        max_lines=1

        for(c=1;c<=cols;c++)
        {

            count=wrap_text(data[r,c],width[c],wrap)

            line_count[r,c]=count


            for(x=1;x<=count;x++)
                wrapped[r,c,x]=wrap[x]


            if(count>max_lines)
                max_lines=count

        }

        row_height[r]=max_lines

    }


    ##################################################
    # Print table
    ##################################################

    print_separator()


    for(r=1;r<=rows;r++)
    {

        print_row(r)


        if(r==1)
            print_separator()

    }


    print_separator()

}


' "$input_file"

echo "Width calculation complete."

read -p "Press Enter to exit..."