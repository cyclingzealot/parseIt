#!/bin/bash

while(true); do
    read file
    validateJSON.bash $file > /dev/null 2>&1
    validJSON=$?

    firstNonWhiteLine=`egrep -v '^[[:space:]]*$' $file`

    echo $firstNonWhiteLine | grep '{' > /dev/null 2>&1
    startsWithCurly=$?

    echo $firstNonWhiteLine | grep '<html>' > /dev/null 2>&1
    hasHTMLtag=$?

   
    if [ "$validJSON" -eq "0" ] ; then
        # If its valid json, then pretty print it
        jsonPrettyPrint.bash $file

    elif [ "$startsWithCurly" -eq "0" ] ; then
        # If it looks like JSON but non valid, show the validator output 
        echo
        validateJSON.bash $file
        echo

    elif [ "$hasHTMLtag" -eq "0" ] ; then
        # If it looks like HTML, send it to links
        cat $file | lynx --stdin

    else 
        less $file
        
    fi
done
