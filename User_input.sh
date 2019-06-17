#!/bin/sh

#Title
    echo ;
    echo ------------------------------------------ ;
    echo MAC INSTALLER - COPY, PASTE, THEN INSTALL
    echo ------------------------------------------ ;
    echo ;

#1st Subtitle
echo =============== 1. Input Installer File =============== ;

    #Function to input path to the existing installer
    FirstUserInput () {
        echo _____________________ ;
        echo [suggestion] You may drag and drop the file into this terminal to add the address ;
        echo  ;
        read -p "Insert address to the installer file: " FULLPATH_ORIGINAL ;
        echo _____________________ ;
    }

    #Run the FirstUserInput function once then run the data validation on it until it succeeds
    FirstUserInput ;
    while [ ! -x $FULLPATH_ORIGINAL ] || [[ "$FULLPATH_ORIGINAL" == "" ]]; do
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

    echo ;
#2nd Subtitle
echo =============== 2. [Optional] Input Installer Directory =============== ;

    #Declare the DIRPATH_ORIGINAL by extracting the string prior to the last "/"
    SetOriginalDirpath() {
        DIRPATH_ORIGINAL="${FULLPATH_ORIGINAL%/*}" ;
        echo ; 
    }

    SetOriginalDirpath ;
    echo Currently, the directory to be copied is: $DIRPATH_ORIGINAL ;

    #Optional path if the installer is not a direct sub of the program's main directory
    SecondUserInput () {
        echo ;
        read -p "[optional] To change the directory you wish to copy, insert new value here: " DIRPATH_ORIGINAL ;
        if [[ "$DIRPATH_ORIGINAL" == "" ]] ; then
            SetOriginalDirpath ;
        fi
    }

    #Run the SecondUserInput function once then run the data validation on it until it succeeds
    #Data validation checks if the directory input by the user is a subdirectory of the original and
    #checks is the directory is a valid directory (prevents user from inputting incomplete portion of the directory)
    SecondUserInput ;
    while [[ "$FULLPATH_ORIGINAL" != "$DIRPATH_ORIGINAL"* ]] || [ ! -d "$DIRPATH_ORIGINAL" ] ; do
        echo [ERROR] The path you specified needs to be a parent to the installer file.
        echo Try again.
        echo  ;
    SecondUserInput ;
        echo _____________________ ;
    done ;

    echo Directory to be copied: $DIRPATH_ORIGINAL ;

    echo ;
#3rd Subtitle
echo =============== 3. Target Directory =============== ;
    #Input path to the directory where the installer will be copied to
    InputTargetDirectory() {
        echo ;
        echo [suggestion] To avoid errors, create the folder in your system then drag and drop it to this window. ;
        echo [info] If the path is valid but doesn\'t exist, you will be prompted to create it.
        echo ;
        read -p "Insert the path to the directory where the installer will be copied: " DIRPATH_CLONE ;
        echo _____________________ ;
        if [[ "$DIRPATH_CLONE" == "~/"* ]] ; then
            DIRPATH_CLONE="${DIRPATH_CLONE:1}"
            DIRPATH_CLONE="/Users/$(id -nu)""$DIRPATH_CLONE"
        fi
    }

    InputTargetDirectoryErr() {
        echo ;
        echo [ERROR] The path you specified is not a directory. ;
    }

    #Run the InputTargetDirectory function then run the validation rule.
    #Validation rule checks to see if the directory exists.
    InputTargetDirectory

    #If the directory doesn't exist, program checks if it is a valid directory path.
    #if it is, then it asks the user if they wish to create it. If the response is
    # not valid, the system will repeat the request until a valid input is provided.
    while [ ! -d "$DIRPATH_CLONE" ] ; do

        if [[ "$DIRPATH_CLONE" == "/"* ]] ; then
            InputTargetDirectoryErr ;
            VAR_CREATE="n" ;
            read -p "Would you like to create it, instead? (y/n): " VAR_CREATE ;

            while [[ "$VAR_CREATE" != "y" ]] && [[ "$VAR_CREATE" != "n" ]] ; do
                echo User input invalid. ;
                echo Try again! ;
                InputTargetDirectoryErr ;
            done ;

            if [[ "$VAR_CREATE" == "y" ]] ; then
                mkdir -p "$DIRPATH_CLONE" ;
                echo ;
                echo Directory $DIRPATH_CLONE created successfully ;
            elif [[ "$VAR_CREATE" == "n" ]] ; then
                echo ;
                echo Directory not created. ;
                echo _____________________ ;
                InputTargetDirectory ;
                continue
            fi
        #If the path starts with a ./, then the system gives an error and asks the user for a full path.
        elif [[ "$DIRPATH_CLONE" == "./"* ]] ; then
            echo current path shortcut './' is not supported in this program. ;
            echo please print the absolute or relative '~/' path instead. ;
            InputTargetDirectory ;
        else    
            echo ;
            echo [ERROR] The path specified cannot be a directory. Please insert a valid path. ;
            InputTargetDirectory ;
        fi

    done

    echo ;
#4th Subtitle
echo =============== 4. Cleanup Installer After Install =============== ;
    echo ;

    #option to delete installers once complete or not
    VAR_CLEANUP="y"
    read -p "Do you wish to cleanup the installer once the install process is complete? (y/n): " VAR_CLEANUP ;

    echo ;
#5th Subtitle
echo =============== 5. Enable Install Script =============== ;
    echo ;

    #option to enable the installer or keep it disabled
    read -p "Do you wish to activate this install procedure? (y/n)" VAR_ACTIVE ;

#Strip slashes from the end of the second and third input
#Input validation for the last two inputs.
