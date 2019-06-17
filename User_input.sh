#!/bin/sh

#0. Title
    echo ;
    echo ------------------------------------------ ;
    echo MAC INSTALLER - COPY, PASTE, THEN INSTALL
    echo ------------------------------------------ ;
    echo ;

#1. Input Installer File
    echo =============== 1. Input Installer File =============== ;
    #[FUNCTION] - Input path to the existing installer
        Fn_FirstUserInput () {
            echo _____________________ ;
            echo [suggestion] You may drag and drop the file into this terminal to add the address ;
            echo  ;
            read -p "Insert address to the installer file: " FULLPATH_ORIGINAL ;
            echo _____________________ ;
        }
    #[PROCEDURE] - Run the function and validation rules
        Fn_FirstUserInput ;
        while [ ! -x $FULLPATH_ORIGINAL ] || [[ "$FULLPATH_ORIGINAL" == "" ]]; do
            echo !!!!;
            echo [ERROR] The path you specified does not point to an executable file. ;
            echo Please insert a valid address. ;
            echo !!!!;
            Fn_FirstUserInput ;
        done

    #[PROCEDURE] - Set Filename and the Filetype variables
            FILENAME_ORIGINAL="${FULLPATH_ORIGINAL##*/}" ;
            FILETYPE="${FULLPATH_ORIGINAL##*.}" ;
    #[STATUS] - Provide user with status of current configs
        echo ;
        echo Full path set to $FULLPATH_ORIGINAL ;
        echo Filename set to $FILENAME_ORIGINAL ;
        echo Filetype set to $FILETYPE ;

    echo ;
#2. [Optional] Input Installer Directory
    echo =============== 2. [Optional] Input Installer Directory =============== ;
    #[FUNCTION] - Extract installer direct parent directory & echo status
        Fn_SetOriginalDirpath() {
            DIRPATH_ORIGINAL="${FULLPATH_ORIGINAL%/*}" ;
            echo ; 
        }
        Fn_SetOriginalDirpath ;
        echo Currently, the directory to be copied is: $DIRPATH_ORIGINAL ;

    #[FUNCTION] - Declare custpm path if user wishes to change directory to be copied
        SecondUserInput () {
            echo ;
            read -p "[optional] To change the directory you wish to copy, insert new value here: " DIRPATH_ORIGINAL ;
            if [[ "$DIRPATH_ORIGINAL" == "" ]] ; then
                Fn_SetOriginalDirpath ;
            fi
        }

    #[PROCEDURE] - Run function and validation rules
        #Run the SecondUserInput function once then run the data validation on it until it succeeds
        #Data validation checks if the directory input by the user is a subdirectory of the original and
        #checks is the directory is a valid directory (prevents user from inputting incomplete portion of the directory)
        SecondUserInput ;
        while [[ "$FULLPATH_ORIGINAL" != "$DIRPATH_ORIGINAL"* ]] || [ ! -d "$DIRPATH_ORIGINAL" ] ; do
            echo ;
            echo [ERROR] The path you specified needs to be a parent to the installer file.
            echo Try again.
            echo  ;
            SecondUserInput ;
            echo _____________________ ;
        done ;

    #[STATUS] - Provide user with status of current configs
        echo Directory to be copied: $DIRPATH_ORIGINAL ;
    echo ;
#3. Target Directory
    echo =============== 3. Target Directory =============== ;
    #[FUNCTION] - Input path to the directory where the installer will be copied to
        Fn_InputTargetDirectory() {
            echo ;
            echo [suggestion] To avoid errors, create the folder in your system then drag and drop it to this window. ;
            echo [info] If the path is valid but doesn\'t exist, you will be prompted to create it.
            echo ;
            read -p "Insert the path to the directory where the installer will be copied: " DIRPATH_CLONE ;
            echo _____________________ ;
            #If the path contains ~, this if statement will resolve it to an absolute path
                if [[ "$DIRPATH_CLONE" == "~/"* ]] ; then
                    DIRPATH_CLONE="${DIRPATH_CLONE:1}"
                    DIRPATH_CLONE="/Users/$(id -nu)""$DIRPATH_CLONE"
                fi
        }

    #[FUNCTION] - Report error in case the directory input by user doesn't exist
        InputTargetDirectoryErr() {
            echo ;
            echo [ERROR] The path you specified is not a directory. ;
        }

    #[PROCEDURE] - Run function and validation rules
        
        Fn_InputTargetDirectory
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
                    Fn_InputTargetDirectory ;
                    continue
                fi
            #If the path starts with a ./, then the system gives an error and asks the user for a full path.
            elif [[ "$DIRPATH_CLONE" == "./"* ]] ; then
                echo current path shortcut './' is not supported in this program. ;
                echo please print the absolute or relative '~/' path instead. ;
                Fn_InputTargetDirectory ;
            else    
                echo ;
                echo [ERROR] The path specified cannot be a directory. Please insert a valid path. ;
                Fn_InputTargetDirectory ;
            fi

        done

    #[STATUS] - Provide user with status of current configs
        echo Current target directory is $DIRPATH_CLONE
    echo ;
#4. Cleanup Installer After Install
    echo =============== 4. Cleanup Installer After Install =============== ;
    #[FUNCTION] - Option to delete installers once complete
        Fn_Cleanup() {
            echo ;
            read -p "Do you wish to cleanup the installer once the install process is complete? (y/n): " VAR_CLEANUP ;
        }
    #[PROCEDURE] - Run function & validation rules
        VAR_CLEANUP="y" ;
        Fn_Cleanup ;
        while [[ "$VAR_CLEANUP" != "y" ]] && [[ "$VAR_CLEANUP" != "n" ]] ; do
            echo User input invalid. ;
            echo Try again! ;
            Fn_Cleanup ;
        done
    #[STATUS] - Provide user with status of current configs
        if [[ "$VAR_CLEANUP" == "y" ]] ; then
            echo Cleanup enabled ;
        elif [[ "$VAR_CLEANUP" == "n" ]] ; then
            echo Cleanup disabled ;
        fi        

    echo ;
#5. Enable Install Script
    echo =============== 5. Enable Install Script =============== ;
    #[FUNCTION] - Option to enable the script for the ScriptRunner.sh
        Fn_Enable() {
            echo ;
            echo [INFO] By enabling the installer script, the script runner will run this Script
            echo        along with all the other enabled script. If the script is disabled, it can still
            echo        be run manually.
            echo ;
            read -p "Do you wish to enable this installer script? (y/n): " VAR_ENABLE ;
        }
    #[PROCEDURE] - Run function & validation rules
        VAR_ENABLE="y" ;
        Fn_Enable ;
        while [[ "$VAR_ENABLE" != "y" ]] && [[ "$VAR_ENABLE" != "n" ]] ; do
            echo User input invalid ;
            echo Try again! ;
            Fn_Enable ;
        done
    #[STATUS] - Provide user with status of current configs
        if [[ "$VAR_ENABLE" == "y" ]] ; then
            echo ;
            echo Script enabled ;
        elif [[ "$VAR_ENABLE" == "n" ]] ; then
            echo Script disabled ;
            echo ;
        fi 
    echo ;

#6. Generate Install Script
#Extra Comments
    #Strip slashes from the end of the second and third input
    #Input validation for the last two inputs.
    #Limit file types (validation for header 1)