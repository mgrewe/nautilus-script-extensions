#!/bin/bash

FILE=$1

OUTPUT=$(zenity --forms --title="Extract PDF pages" --text="Select page range" --separator="," --add-entry="From:" --add-entry="To:")
accepted=$?
if ((accepted != 0)); then
    exit -1
fi

FROM=$(awk -F, '{print $1}' <<<$OUTPUT)
TO=$(awk -F, '{print $2}' <<<$OUTPUT)

NEW_FILENAME=$(basename $1 .pdf)_extracted.pdf
OUTPUT=$(zenity --file-selection --save --title="Save to new pdf" --filename=$NEW_FILENAME)
accepted=$?
if ((accepted != 0)); then
    exit -1
fi
FILE=$OUTPUT

if [ -e $FILE ]
then
        zenity --question --title "File exists" --text "Overwrite?"
        accepted=$?
        if ((accepted != 0)); then
                exit -1
        fi
fi


#/usr/bin/gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dFirstPage=$FROM -dLastPage=$TO -sOutputFile=$FILE $1 2>&1 | xargs -I %  zenity --width=250 --height=250 --info --text=%

CMD_OUT=$(/usr/bin/gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dFirstPage=$FROM -dLastPage=$TO -sOutputFile=$FILE $1)
if (($? != 0))
then
        zenity --error --title "Ghostscript error" --text="$CMD_OUT"
fi
