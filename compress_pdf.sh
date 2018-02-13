#!/bin/bash

opt1="screen"
opt2="ebook"
opt3="printer"
opt4="prepress"
opt5="default"
PRESET=$(zenity --height=275 --list --radiolist --text 'Select the preset to be used:' --column 'Selection' --column 'Preset' FALSE "$opt1" FALSE "$opt2" TRUE "$opt3" FALSE "$opt4" FALSE "$opt5")
if [ -z $PRESET ]
then
    exit -1
fi


FILE=$OUTPUT

NEW_FILENAME=$(basename "$1" .pdf)_compressed.pdf
OUTPUT=$(zenity --file-selection --save --title="Save to new pdf" --filename=$NEW_FILENAME)
accepted=$?
if ((accepted != 0)); then
    exit -1
fi
FILE=$OUTPUT

if [ -e $FILE ]
then
        zenity --question --title "File exists" --text "Overwrite $FILE?"
        accepted=$?
        if ((accepted != 0)); then
                exit -1
        fi
fi

FILES=""
 
while (( "$#" )); do 
  FILES="$FILES $(printf '%q' "$1")"
  shift 
done

#/usr/bin/gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dFirstPage=$FROM -dLastPage=$TO -sOutputFile=$FILE $1 2>&1 | xargs -I %  zenity --width=250 --height=250 --info --text=%

CMD_OUT=$(/usr/bin/gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$PRESET -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$FILE" $FILES)
if (($? != 0))
then
        zenity --error --title "Ghostscript error" --text="$CMD_OUT"
fi
