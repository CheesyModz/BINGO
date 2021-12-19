#include <stdio.h>     // for printf
#include <stdlib.h>    // for exit
#include <ctype.h>     // for toupper, tolower, isdigit, etc
#include <string.h>    // for strcpy, strcat, strcmp, strlen, etc
#include "list.h"      // for list ADT

//Declaring functions
//Will be explained in the actual function
void printMatrix(array *callList, int matrix[5][5], int markMatrix[5][5]);

int checkMatch(int number, array *callList);

int winCondition(int markMatrix[5][5]);

//main function with 2 parameters int argc as the seed number and char *argc[] as the input file
int main(int argc, char *argv[]) {

        // Checks if there are wrong number of command-line arguments
        if (argc != 3){
                fprintf(stderr, "Usage: %s seed cardFile \n", argv[0]);
                exit(1);
        }

        // Checks if the seed is an integer
        int i;
        for (i = 0; i < strlen(argv[1]); i++){
                if (isdigit(argv[1][i]) == 0){
                        fprintf(stderr, "Expected integer seed, but got %s \n", argv[1]);
                        exit(2);
                }
        }

        FILE *fp;
        // Checks if the file is not readable
        if ((fp=fopen(argv[2], "r"))==NULL){
                fprintf(stderr, "%s is nonexistent or unreadable \n", argv[2]);
                exit(3);
        }

        int linesCount = 1;
        int numPerLine = 1;
        char ch;

        // Checks if the file contains more than 5 lines or more than 5 numbers per line
        while ((ch=fgetc(fp)) != EOF){
                if (ch == '\n') {
                        linesCount++;
                        numPerLine = 1;
                }
                else if (linesCount > 5 || numPerLine > 5){
                        fprintf(stderr, "%s has bad format \n", argv[2]);
                        exit(4);
                }
                else if (ch == ' ') {
                        numPerLine++;
                }
                // Checks if the card number is digit
                else if (isdigit(ch) == 0){
                        fprintf(stderr, "%s has bad format \n", argv[2]);
                        exit(4);
                }
        }

        fp=fopen(argv[2], "r");
        int counter = 0;
        char word[3];
        int inputNumbers[25];
        // Checks CardFile format lines and stores numbers in the CardFile in inputNumbers array
        while (fscanf(fp, "%s", word) != EOF){
                inputNumbers[counter] = atoi(word);
                counter++;
                if (counter > 25){
                        fprintf(stderr, "%s has bad format \n", argv[2]);
                        exit(4);
                }

        }

        //Use a nested for loop to create a 2D array and assign the values with inputNumbers
        int matrix[5][5];
        int row, column;
        int pos=0;
        for (row = 0; row < 5; row++){
                for (column = 0; column < 5; column++){
                        matrix[row][column] = inputNumbers[pos];
                        pos++;
                }
        }
        int min = 1, max = 15;


        //Checks if all the numbers in are all within range ie column 1 should only contain numbers from 1-15
        for (column = 0; column < 5; column++){
                for (row = 0; row < 5; row++){
                        if (max < matrix[row][column] || matrix[row][column] < min){
                                //Adds an exception for the center of matrix as it has to be out of the range
                                if (row == 2 && column == 2){
                                        continue;
                        }
                                fprintf(stderr, "%s has bad format \n", argv[2]);
                                exit(4);
                        }
                        //The format requires the center of the matrix has to be 0
                        else if (matrix[2][2] != 0){
                                fprintf(stderr, "%s has bad format \n", argv[2]);
                                exit(4);
                        }
                }
        //Increase the min and max variable by 15 each loop since the range also increases by increments of 15
        min += 15;
        max += 15;
        }

        //Checks if the input file contains any duplicate numbers
        for (row=0; row<25; row++){
                 for (column=0; column<25; column++){
                        if (row == column){
                                continue;
                        }
                        else if (inputNumbers[row] == inputNumbers[column]){
                                fprintf(stderr, "%s has bad format\n", argv[2]);
                                exit(4);
                        }
                }
        }


//-------------------------------------------------------------------------------
        unsigned int seed;
        seed = atoi(argv[1]);
        srand(seed);
        //The maximum user input is set to 100 char
        char s[100];

        int times;
        int random;

        //Initialize the callList
        array callList;
        initialize(&callList, 75);

        //Mark the center of the matrix
        int markMatrix[5][5];
        markMatrix[2][2] = 1;

        //Prints the first display when A2 is first executed
        printMatrix(&callList, matrix, markMatrix);
        printf("enter any non-enter key for Call (q to quit): ");

        //A while loop that displays the callList and matrix and only ends if either the user enters "q" or the user sastify the win condition
        while (scanf("%s", s)){
                if (strcmp(s, "q") == 0) break;
                //Adds the same amount of random numbers (within the range of 1-75) as the length of the user input to callList
                for (times=0; times < strlen(s); times++){

                        random = (rand() % 75) + 1;
                        while (check(&callList, random) == 1){
                                random = (rand() % 75) + 1;
                        }
                        add(&callList, random );
                }

                printMatrix(&callList, matrix, markMatrix);

                if (winCondition(markMatrix)){
                        printf("WINNER\n");
                        break;
                }
                else printf("enter any non-enter key for Call (q to quit): ");
        }
//-------------------------------------------------------------------------------
        free((&callList)->entry);
        fclose(fp);
        exit(0);
}

//Displays the callList, the marked matrix, and updates the markMatrix array if an element in it's position have been marked
void printMatrix(array *callList, int matrix[5][5], int markMatrix[5][5]){
        system("clear");
        int i;
        printf("Call list: ");

        //Uses the print function from list.h to print all the assigned element in callList
        print(callList);

        printf("\n\n");
        printf("L   I   N   U   X\n");
        int row, column;
        //Print the marked matrix
        for (row=0; row<5; row++){
                for(column=0;column<5;column++){
                        //Marks the element in the matrix if it has been called in callList or if it is the middle of the matrix(00) with a 'm' at the end
                        if ((checkMatch(matrix[row][column], callList)) == 1 || (row == 2 && column == 2)){
                                //'%02d' is used because all the elements being printed should be formatted as a letter along with 2 digits, ie 5 should be printed as L05
                                printf("%02dm ", matrix[row][column]);
                                //Updates the markedMatrix array if the element in that position have been marked
                                markMatrix[row][column] = 1;
                        }
                        else printf("%02d  ", matrix[row][column]);
                }
                printf("\n");
        }

}
//Checks if the integer number is called in the callList, return 1(true) if it appears in callList or 0(false) if it has not
int checkMatch(int number, array *callList){
        int i;
        for (i=0; i < callList->index; i++){
                if (callList->entry[i] == number) return 1;
                else if (i == (callList->index - 1))  return 0;
        }
}

//Checks the markMatrix array to see if it has met any of the win conditions
//If the horizontal, vertical, or the four corners conditions have been met return 1 (true)
int winCondition(int markMatrix[5][5]){
        int row, column, count=0;
        //Counts the number of marked element(1) in each row of the markMatrix array and if the count has reached 5 in any of the rows return 1
        for (row=0; row < 5; row++){
                //Resets count to 0 every time a new row is being counted
                count=0;
                for (column=0; column < 5; column++){
                        //markMatrix array define 1 as being marked
                        if (markMatrix[row][column] == 1){
                                count++;
                        }
                }
                if (count == 5) return 1;
        }

        //Counts the number of marked element(1) in each column of the markMatrix array and if the count has reached 5 in any of the columns return 1
        for (column=0; column < 5; column++){
                count=0;
                for (row=0; row < 5; row++){
                        if (markMatrix[row][column] == 1){
                                count++;
                        }
                }
                if (count == 5) return 1;
        }

        //If all four corners of the markMatrix array have been marked (1) return 1
        if (markMatrix[0][0] == 1 && markMatrix[4][0] == 1 && markMatrix[0][4] == 1 && markMatrix[4][4] == 1) return 1;

        return 0;
}
