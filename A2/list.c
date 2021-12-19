//list.c
#include "list.h"
#include <stdio.h>
#include <stdlib.h>

//Initialize the array structure to the length of int size
void initialize(array *list, int size){
        list->maxSize=size;
        //malloc is used to dynamically allocate the memory for list structure because it will not always be the max length
        list->entry=(int *) malloc (size * sizeof(int));
        //the index start as 0 since no elements have been added to the list
        list->index=0;
}

//Add a new integer element to as the 'last' element of the list
void add(array *list, int elem){
        //Checks if the list is already at max capacity if it is not the intger element is allowed to be added
        if (list->maxSize != list->index){
                list->entry[list->index]=elem;
                //The index memeber is increase by one in order for the next element to be assigned to that index
                list->index++;
        }
}

//Checks if the integer element appears in the list returning 1 if it does appaer and 0 if it does not
int check(array *list, int elem){
    int i;
    //for loops the list up to the last index with an assigned element to check if int elem appears in list
    for (i=0; i < list->index; i++){
        if (list->entry[i] == elem) return 1;
    }
    return 0;
}

//Prints all the elements of the list along an letter 'L', 'I', 'N', 'U' or 'X' respective to their range
void print(array *list){
    int i;
    //for loops the list up to the last index with an assigned element
    for (i=0; i < list->index; i++){
        //The letter 'L', 'I', 'N', 'U' or 'X' is printed infront of the element assigned to the current list index if the element is within their range
        if (list->entry[i] <= 75 && list->entry[i] > 60) printf("X%d ", list->entry[i]);
        else if (list->entry[i] <= 60 && list->entry[i] > 45) printf("U%d ", list->entry[i]);
        else if (list->entry[i] <= 45 && list->entry[i] > 30) printf("N%d ", list->entry[i]);
        else if (list->entry[i] <= 30 && list->entry[i] > 15) printf("I%d ", list->entry[i]);
        //'%02d' is used because all the elements being printed should be formatted as a letter along with 2 digits, ie 5 should be printed as L05
        else if (list->entry[i] <= 15 && list->entry[i] > 0) printf("L%02d ", list->entry[i]);

    }
}
