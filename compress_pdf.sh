#!/bin/bash


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


#/usr/bin/gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dFirstPage=$FROM -dLastPage=$TO -sOutputFile=$FILE $1 2>&1 | xargs -I %  zenity --width=250 --height=250 --info --text=%

CMD_OUT=$(/usr/bin/gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$FILE" "$1")
if (($? != 0))
then
        zenity --error --title "Ghostscript error" --text="$CMD_OUT"
fi
