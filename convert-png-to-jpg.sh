#!/bin/bash

while (( "$#" )); 
do 
  convert $1 -background white -flatten $(basename $1 .png).jpg
  shift 
done
