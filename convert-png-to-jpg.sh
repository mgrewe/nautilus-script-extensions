#!/bin/bash

while (( "$#" )); 
do 
  convert "$1" -background white -flatten "$1.jpg"
  shift 
done
