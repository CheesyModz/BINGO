<pre>
# LINUX (BINGO)
Group assignment - Coded by Gary Huang, Mark Belleza, Si Yuan Yue (Ricky)

# What does this program do?
Reads input from a file that contains the RANDOM seed number and the LINUX card
Each time a key that is not 'q' or 'Q' is entered, it keeps calling a random number until theres one of the following:
5 `m` marked in a row
5 `m` marked in a column
4 `m` marked in the corners
Basically *Bingo*
</pre>

# Preview
https://user-images.githubusercontent.com/49135331/141492953-694bc43e-f28d-41c3-a987-e5cfcbfb607f.mp4

<pre>
# What do download?
1. LINUX.sh
2. GoodInputs file
3. (Optional) BadInputs file

# How to run - Good Inputs (To play)
For good inputs that contain correct LINUX cards and seed numbers do
`bash LINUX GoodInputs/fileName`

For example
`bash LINUX GoodInputs/badInput1`

# How to run - Bad Inputs (To test program)
For bad inputs that contain incorrect LINUX cards and seed numbers do
`bash LINUX BadInputs/fileName`
For example
`bash LINUX BadInputs/goodInput0`

# Want to make your own good input files? 
meet the following conditions listed below

1. The file contains 6 lines
2. First line of the file contains only the seed number
3. 2-6 line contains the card format and meet the following conditions:
  3.1 Middle is 00
  3.2 5 numbers per row
  3.3 Contains a number within the range:
    3.3.1 Column 1: Range 1-15
    3.3.2 Column 2: Range 16-30
    3.3.3 Column 3: Range 31-45
    3.3.4 Column 4: Range 46-60
    3.3.5 Column 5: Range 61-75
  3.4 No duplicate numbers
  3.5 Numbers less than 10 contain a zero before ( 0n , where n is the digit)
  3.6 Only numbers
  3.7 Number and a space between them (Example: `11 27 39 59 63`)
</pre>






