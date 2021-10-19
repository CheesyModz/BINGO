#!/bin/bash
#exit 1 if there is no file
if [ $# -eq 0 ]; then
      echo "input file missing or unreadable" >/dev/stderr
      exit 1
fi

#exit 1 if the file cannot be read
if [ ! -r $1 ]; then
        echo "input file missing or unreadable" >/dev/stderr
        exit 1
fi

#exit 5 if the input is not a file
if [ ! -f $1 ]; then
        echo "input is not a file" >/dev/stderr
        exit 5
fi

#exit 6 if there is more than 1 input
if [ $# -gt 1 ]; then
        echo "more than 1 input file entered" >/dev/stderr
        exit 6
fi

#use word count to check the number of lines in input file. If it is not 5 then exit 2
if [ ! "`wc -l $1 | grep 6`" ]; then
       echo "input file must have 6 lines" >/dev/stderr
        exit 2
fi

#reads the first line of the input file
read seedNum < $1
#puts the seed number "first line" into a txt file so that it can be checked
echo $seedNum >seedNumFile

#exit 3 if there are any characters that is not a digit
if [ "`echo $seedNum | grep '[^0-9]'`" ]; then
        echo "seed line format error" >/dev/stderr
        #remove the temporary seedNumFile as it is no longer needed
        rm seedNumFile
        exit 3
#exit 3 if there are more than 1 set of numbers for line 1
elif [[ $( wc -w < seedNumFile ) -gt 1 ]]; then
        echo "seed line format error" >/dev/stderr
        rm seedNumFile
        exit 3
fi

#create an associative array called matrix to store the numbers
declare -A matrix
#put the last 5 lines, "the matrix", into a txt file so that the values of the matrix can be retrived
touch "input1.txt"
echo "$(tail -5 $1)" >> input1.txt
input1=input1.txt

#while loop to read all the lines of input1.txt "the matrix"
while read -r line ; do
        #the tempRowFile contains only the current line of the loop
        echo $line > tempRowFile
        # if the current row is not equal to 5 elements then exit 4
        if [[ $( wc -w < tempRowFile ) -ne 5 ]]; then
                echo "card format error" >/dev/stderr
                #remove all tempoary files before exiting
                rm seedNumFile input1.txt tempRowFile
                exit 4
        #if the current row contains anything that is not a digit then exit 4
        elif [ "`echo $line | sed -e "s/ //g" | grep '[^0-9]'`" ]; then
                echo "card format error" >/dev/stderr
                rm seedNumFile input1.txt tempRowFile
                exit 4
        fi
done < input1.txt

#create an integer to keep track of the current row
typeset -i countRow=0
#for loop that checks if the numbers within each column is within range.
for ((i=1;i<6;i++)) do
        #cut each row from the input1.txt, "matrix", and puts it into the columnFile.txt so that we may evalutate
        echo "$( cut -d' ' -f$i input1.txt )" >columnFile.txt
        #each time we move the next column we reset the current row position to 0
        countRow=0
        #while loop that checks each number of the current column to see if the numbers are within range
        while read -r line; do
                #beacuse the range increase by an incriment of 15 we times the variables by 15 as the current range
                if [ $line -gt $((i*15)) ] || [ $line -lt $(((i-1)*15)) ]; then
                        #create an exception for 00 in the middle of the matrix as it is out side of the range of that column
                        if [ $i -eq 3 ] && [ $countRow -eq 2 ]; then
                                #after exempting 00 in the middle of matrix, countRow serves it's purpose and become obsolete so we increase it to an integer that would not affect the rest of the search
                                countRow=countRow+1
                                continue
                        #if the number is found to be outside the range of the column and it is not 00 in the middle of the matrix exit 5
                        else
                                countRow=0
                                echo "card format error" >/dev/stderr
                                rm seedNumFile input1.txt tempRowFile columnFile.txt
                                exit 4
                        fi
                fi
                #after reaching the last row reset countRow to its inital position of 0. Else we increase the countRow by one as we are moving to the next row of numbers
                if [ $countRow -eq 5 ]; then
                        countRow=0
                else
                        countRow=countRow+1
                fi
        done < columnFile.txt
done

#create a regular array to simply store each number in the input1.txt, "matrix", into the array
declare -a inputArray
inputArray=(`cat "$input1"`)
#the current variable keeps track of the current position of the the number being stored
typeset -i current=0
#we use the nested for loop to create a 2D array and assign the values with inputArray
for ((i=0;i<5;i++)) do
    for ((j=0;j<5;j++)) do
        matrix[$i,$j]=${inputArray[$current]}
        current=current+1
    done
done

#if the middle of the matrix is not 00 then exit 4
if [ ${matrix[2,2]} != "00" ]; then
        echo "card format error" >/dev/stderr
        rm seedNumFile input1.txt tempRowFile columnFile.txt
        exit 4
fi

#CHECK FOR DUPLICATES IN THE MATRIX
#compare each value in the inputArray, the array with all the values of the matrix, and see if there are duplicates
for ((i=0;i<25;i++)) do
        for ((j=0;j<25;j++)) do
                #if the two indexes are the same we skip it since it's the same number
                if [ $i -eq $j ]; then
                        continue
                #for any number that are equal to each other and are not in the same position exit 4
                elif [ ${inputArray[$i]} -eq ${inputArray[$j]} ]; then
                        echo 'card format error' >/dev/stderr
                        rm seedNumFile input1.txt tempRowFile columnFile.txt
                        exit 4
               fi
        done
done


RANDOM=$seedNum
#numbers is an array that stores the called numbers
declare -a numbers
#numbersLetters is an array that stores the Letter eg. 'L', 'I', 'N', 'U', 'X' and the numbers as a single string eg. 'L01' and is used to display the called numbers
declare -a numbersLetters
#markedNumbers is an associative array that marks the numbers in the matrix that was called
declare -A markedNumbers
typeset -i lettersIndex=0

#initialize the markedNUmbers to be the same size as our matrix and makes all the values 0 as we only need this array to identify the postions
for ((i=0;i<5;i++)) do
        for ((j=0;j<5;j++)) do
                markedNumbers[$i,$j]=0
        done
done

#Displays the CALL List, the matrix and marks the matrix if the numebrs have been called
printMatrix () {
        #clears the previous display and updates it
        clear
        #generates a randomnumber between 1 to 75 (inclusive) based on the seed number
        randomNum=$((1 + $RANDOM % 75))
        if [ $randomNum -lt 10 ]; then
                #if randomNum satisfy the condtions we add the letters within the respective range with the randomNum to numbersLEtters Array
                numbersLetters[lettersIndex]="L$randomNum"
                #if the numbers are single digit we have to add a 0 infront of the randomNum and then add it to the numbers array. Otherwise, we just add the randomNum to the numbers array.
                numbers[lettersIndex]="0$randomNum"
                lettersIndex=lettersIndex+1
        elif [ $randomNum -le 15 -a $randomNum -ge 10 ]; then
                numbersLetters[lettersIndex]="L$randomNum"
                numbers[lettersIndex]=$randomNum
                lettersIndex=lettersIndex+1
        elif [ $randomNum -gt 15 -a $randomNum -le 30 ]; then
                numbersLetters[lettersIndex]="I$randomNum"
                numbers[lettersIndex]=$randomNum
                lettersIndex=lettersIndex+1
       elif [ $randomNum -gt 30 -a $randomNum -le 45 ]; then
                numbersLetters[lettersIndex]="N$randomNum"
                numbers[lettersIndex]=$randomNum
                lettersIndex=lettersIndex+1
        elif [ $randomNum -gt 45 -a $randomNum -le 60 ]; then
                numbersLetters[lettersIndex]="U$randomNum"
                numbers[lettersIndex]=$randomNum
                lettersIndex=lettersIndex+1
        else
                numbersLetters[lettersIndex]="X$randomNum"
                numbers[lettersIndex]=$randomNum
                lettersIndex=lettersIndex+1
        fi
        #display the CALL LIST and echo all the values in the numbersLetters array
        echo -ne "CALL LIST: ${numbersLetters[*]}   \n"
        echo " L   I   N   U   X"
        #a nested for loop to check if the randomNum matches any numbers in the associative matrix array and prints the matrix everytime its called
        for ((i=0;i<5;i++)) do
                for ((j=0;j<5;j++)) do
                        #mark the middle of the matrix 00 by default
                        if [  $i = 2 ] && [ $j = 2 ]; then
                                echo -n "${matrix[2,2]}m "
                                markedNumbers[2,2]="m"
                        #if the randomNum matches with the number in the matrix array then mark it in markedNumbers
                        elif [[ ${numbers[*]} =~ ${matrix[$i,$j]} ]]; then
                                echo -n "${matrix[$i,$j]}m "
                                markedNumbers[$i,$j]="m"
                        else
                                echo -n "${matrix[$i,$j]}  "
                        fi
                done
                echo
        done
}

#checks the markedNumbers array to see if any of the conditions have been satisfied. If any of the condtions, horizontal, vertical, four courners, have been satisfied return true
checkWinner () {
        typeset -i count=0
        # Row Check
        #if the count of m goes up to 5 in any of the rows return true
        for ((i=0;i<5;i++)) do
                count=0
                for ((j=0;j<5;j++)) do
                        if [ "${markedNumbers[$i,$j]}" = 'm' ]; then
                                count=count+1
                        fi
                done
                if [ $count -eq 5 ];then
                        return 0
                fi
        done
        count=0
        # check column
        #if the count of m goes up to 5 in any of the columns return true
        for ((i=0;i<5;i++)) do
                count=0
                for ((j=0;j<5;j++)) do
                        if [ "${markedNumbers[$j,$i]}" = 'm' ]; then
                                count=count+1
                        fi
                done
                if [ $count -eq 5 ];then
                        return 0
                fi
        done
        count=0
        # check corner
        #if all of the four courners have been marked return true
        if [ "${markedNumbers[0,0]}" = 'm' ] && [ "${markedNumbers[0,4]}" = 'm' ]; then
                if [ "${markedNumbers[4,0]}" = 'm' ] && [ "${markedNumbers[4,4]}" = 'm' ]; then
                        return 0
                fi
        fi
        return 1
}

#initiate the first instance of the game before the player starts playing
clear
echo "CALL LIST: "
echo " L   I   N   U   X"
for ((i=0;i<5;i++)) do
        for ((j=0;j<5;j++)) do
                if [  $i = 2 ] && [ $j = 2 ]; then
                        echo -ne "${matrix[2,2]}m "
                else
                        echo -ne "${matrix[$i,$j]}  "
                fi
        done
        echo
done
# Game loop - keep running until winner or quit
while [ true ]; do
        #if player enters q or Q the program ends
        echo -ne "enter any key to get a call or q to quit: "
        read input
        if [ $input = q -o $input = Q ]; then
                rm input1.txt tempRowFile seedNumFile
                break
        fi
        #if any other key is pressed calls printMatrix function to update the game with a new random number
        printMatrix
        #after the random number is called check if any of the win conditions have been satisfied
        if checkWinner; then
                #if the player wins. Print WINNER, breaks the loop, deletes all the temporary files and ends the program
                echo WINNER
                rm input1.txt tempRowFile seedNumFile
                break
        fi
done
