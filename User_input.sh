#!/bin/sh

#Function to input path to the existing installer
FirstUserInput () {
    echo _____________________ ;
    echo [suggestion] You may drag and drop the file into this terminal to add the address ;
    echo  ;
    read -p "Insert address to the installer file: " FULLPATH_ORIGINAL ;
    echo _____________________ ;
}
FirstUserInput ;
while [ ! -x $FULLPATH_ORIGINAL ] ; do
    echo !!!!;
    echo [ERROR] The path you specified does not point to an executable file. ;
    echo Please insert a valid address. ;
    echo !!!!;
    FirstUserInput ;
done

#Set the filename and the filetype variables
FILENAME_ORIGINAL="${FULLPATH_ORIGINAL##*/}" ;
FILETYPE="${FULLPATH_ORIGINAL##*.}" ;
echo ;
echo Filename set to $FILENAME_ORIGINAL ;
echo Filetype set to $FILETYPE ;

echo _____________________ ;
#Declare the DIRPATH_ORIGINAL by extracting the string prior to the last "/"
DIRPATH_ORIGINAL="${FULLPATH_ORIGINAL%/*}" ;
echo Currently, the directory to be copied is: $DIRPATH_ORIGINAL ;

#Optional path if the installer is not a direct sub of the program's main directory
SecondUserInput () {
echo ;
read -p "[optional] If you wish to change the directory to copy, insert new value here: " DIRPATH_ORIGINAL ;
echo _____________________ ;
}

SecondUserInput ;
while [[ "$FULLPATH_ORIGINAL" != "$DIRPATH_ORIGINAL"* ]] || [ ! -d "$DIRPATH_ORIGINAL" ] ; do
echo [ERROR] The path you specified needs to be a parent to the installer file.
echo Try again.
echo  ;
SecondUserInput ;
echo _____________________ ;
done ;

#Input path to the directory where the installer will be copied to
echo To avoid errors, it is recommended to create, locate then drag and drop the folder to this window. ;
read -p "Insert the path to the directory where the installer will be copied: " DIRPATH_CLONE ;

#option to delete installers once complete or not
read -p "Do you wish to cleanup the installer once the install process is complete? (y/n): " VAR_CLEANUP ;

#option to activate the installer or keep it inactive
read -p "Do you wish to activate this install procedure? (y/n)" VAR_ACTIVE ;

#Strip slashes from the end of the second and third input
#Input validation for the last two inputs.
