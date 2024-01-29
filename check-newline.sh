#!/bin/bash

FILE=$1

echo -n ${FILE} " ";
if test $(tail -c 1 ${FILE} | wc -l) -eq 1; then
    echo OK; 
else 
    echo No newline at the end of the file;
    exit 1;
fi