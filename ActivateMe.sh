#!/bin/bash

cd "$(dirname "$0")"

for file in ./*.sh ; do 
    chmod +x "$file"
done
