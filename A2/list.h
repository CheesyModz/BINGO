//list.h
#ifndef LIST_HEADER_FILE
#define LIST_HEADER_FILE
#include <stdio.h>
#include <stdlib.h>

//Structure for the call list referred to the name array
typedef struct{
        //Index of the latest number added to the list
        int index;
        //The maximum size of the list that will be used for allocating the memory for the space
        int maxSize;
        //Pointer for the list
        int *entry;
}array;

//Initialize the array structure to the length of size
void initialize(array *list, int size);
//Add a new integer element to as the 'last' element of the list
void add(array *list, int elem);
//Checks if the integer element appears in the list returning 1 if it does appaer and 0 if it does not
int check(array *list, int elem);
//Prints all the elements of the list along an letter 'L', 'I', 'N', 'U', 'X' respective to their range
void print(array *list);

#endif
