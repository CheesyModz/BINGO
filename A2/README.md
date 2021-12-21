# A2 (BINGO)
<pre>
Group assignment - Coded by Gary Huang, Mark Belleza, Si Yuan Yue (Ricky)
</pre>
# What does this program do?
<pre>
Reads input from a file that a LINUX card
Each time a key or multiple keys that is not "q" or "Q" is entered, it keeps calling a random number until theres one of the following:
5 "m" marked in a row
5 "m" marked in a column
4 "m" marked in the corners
Basically Bingo
</pre>

# Preview
https://user-images.githubusercontent.com/49135331/146989419-3af0a590-7e80-4ea9-a65b-dfd27f36a356.mp4

# What do download?
<pre>
1. A2.c A2Makefile list.c list.h
2. GoodInputs file
3. (Optional) BadInputs file
</pre>
# How to run - Good Inputs (To play)
<pre>
For good inputs that contain correct LINUX cards and seed numbers do
"make -f A2Makefile"
"./A2 seedNumber file"

For example
"make -f A2Makefile"
"./A2 1063 goodInput0"

</pre>
# How to run - Bad Inputs (To test program)
<pre>
For bad inputs that contain incorrect LINUX cards and seed numbers do
"make -f A2Makefile"
"./A2 seedNumber file"

For example
"make -f A2Makefile"
"./A2 1063 badInput1"
</pre>

# After playing
Do the following command to remove all .o files and A2 
"make clean -f A2Makefile"

# Want to make your own good input files? 
<pre>
meet the following conditions listed below

1. The file contains 5 lines
2. 1-5 line contains the card format and meet the following conditions:
  2.1 Middle is 00
  2.2 5 numbers per row
  2.3 Contains a number within the range:
    2.3.1 Column 1: Range 1-15
    2.3.2 Column 2: Range 16-30
    2.3.3 Column 3: Range 31-45
    2.3.4 Column 4: Range 46-60
    2.3.5 Column 5: Range 61-75
  2.4 No duplicate numbers
  2.5 Numbers less than 10 contain a zero before ( 0n , where n is the digit)
  2.6 Only numbers
  2.7 Number and a space between them (Example: `11 27 39 59 63`)
</pre>

# Contact - For issues/support
<pre>
Email: Garyhuang325@gmail.com
Discord: @ƙag ItsCheeseModz#1997
</pre>






