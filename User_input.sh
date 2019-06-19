!/bin/sh
cd "$(dirname "$0")"

#0.1 Import Source Shells
    source Pretty_Bash.sh
#0.2 Declare Global Variables
    ARR_SUPPORTED_FILETYPE=(pkg dmg)
#0.3 Global Functions
#1. Title
    Pretty_title "MAC INSTALLER - COPY, PASTE, THEN INSTALL"
#2. Input Installer File
    Pretty_header "Input Installer File"
    #[FUNCTION] - Input path to the existing installer
        Fn_FirstUserInput () {
            var_s1="$PrettySuggestion You may drag and drop the file into this terminal to add the address"
            var_s2="$PrettyInfo The current version only handles $(IFS=/; echo "${ARR_SUPPORTED_FILETYPE[*]}") file extensions."
            Pretty_2statements  "$var_s1" "$var_s2" ;
            echo ;
            Pretty_break
            read -p "Insert address to the installer file: " FULLPATH_ORIGINAL ;
             #Trim Response so that spaces don't compromise comparisons
            FULLPATH_ORIGINAL="$(echo "${FULLPATH_ORIGINAL}" | sed -e 's/[[:space:]]*$//')" ;
            Pretty_break
        }
    #[PROCEDURE] - Run the function and validation rules
        Fn_FirstUserInput ;
        #Validation loop, breaks if file is exist and of valid file type.
            while [[ "$FILETYPE_VALID" != "True" ]] ; do
                #Check if the file exists and is an executable
                    while [ ! -x "$FULLPATH_ORIGINAL" ] ; do
                        var_s1="[ERROR] The path you specified does not point to an executable file."
                        var_s2="Please insert a valid address. ;"
                        Pretty_2results "$var_s1" "$var_s2"
                        Fn_FirstUserInput ;
                    done

            #[PROCEDURE] - Set Filename and the Filetype variables
                FILENAME_ORIGINAL="${FULLPATH_ORIGINAL##*/}" ;
                FILETYPE="${FULLPATH_ORIGINAL##*.}" ;
                #Convert filetype to lowercase so it can be compared to supported filetype array
                FILETYPE=$(echo "$FILETYPE" | tr '[:upper:]' '[:lower:]')
            #[PROCEDURE] - Evaluate validation for supported filetypes only
                IFS=@
                case "@${ARR_SUPPORTED_FILETYPE[*]}@" in
                    *"@$FILETYPE@"*)
                        FILETYPE_VALID="True" 
                        break ;;
                    *)
                        FILETYPE_VALID="False" 
                        Pretty_1statement "$FILETYPE file type not supported"
                        Fn_FirstUserInput ;;
                esac
            done
    #[STATUS] - Provide user status of current configs
        echo ;
        echo Full path set to: $FULLPATH_ORIGINAL ;
        echo Filename set to: $FILENAME_ORIGINAL ;
        echo Filetype set to: $FILETYPE ;
#3. [Optional] Input Installer Directory
    Pretty_header "[Optional] Input Installer Directory" ;
    #[FUNCTION] - Extract installer direct parent directory & echo status
        Fn_SetOriginalDirpath() {
            DIRPATH_ORIGINAL="${FULLPATH_ORIGINAL%/*}" ;
            echo ; 
        }
        Fn_SetOriginalDirpath ;
        echo Currently, the directory to be copied is: $DIRPATH_ORIGINAL ;

    #[FUNCTION] - Declare custom path if user wishes to change directory to be copied
        SecondUserInput () {
            echo ;
            read -p "[optional] To change the directory you wish to copy, insert new value here: " DIRPATH_ORIGINAL ;
            if [[ "$DIRPATH_ORIGINAL" == "~/"* ]] ; then
                DIRPATH_ORIGINAL="${DIRPATH_ORIGINAL:1}" ;
                DIRPATH_ORIGINAL="/Users/$(id -nu)""$DIRPATH_ORIGINAL" ;
            fi

            #Trim Response so that spaces don't compromise comparisons
            DIRPATH_ORIGINAL="$(echo "${DIRPATH_ORIGINAL}" | sed -e 's/[[:space:]]*$//')" ;

            #If left blank set to default.
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
            var_s1="[ERROR] The path you specified needs to be a parent to the installer file."
            var_s2="Try again."
            Pretty_2results "$var_s1" "$var_s2" ;
            SecondUserInput ;
            echo ------------------- ;
        done ;

    #[STATUS] - Provide user with status of current configs
        echo Directory to be copied: $DIRPATH_ORIGINAL ;
#4. Target Directory
    Pretty_header "Target Directory"
    #[FUNCTION] - Input path to the directory where the installer will be copied to
        Fn_InputTargetDirectory() {

            var_s1="[suggestion] To avoid errors, create the folder in your system then drag and drop it to this window."
            var_s2="[info] If the path is valid but doesn't exist, you will be prompted to create it."
            Pretty_2statements "$var_s1" "$var_s2"
            Pretty_break

            read -p "Insert the path to the directory where the installer will be copied: " DIRPATH_CLONE ;

            #Trim Response so that spaces don't compromise comparisons
            DIRPATH_CLONE="$(echo "${DIRPATH_CLONE}" | sed -e 's/[[:space:]]*$//')" ;

            Pretty_break

            #If the path contains ~, this if statement will resolve it to an absolute path for validation
            if [[ "$DIRPATH_CLONE" == "~/"* ]] ; then
                REL_DIRPATH="$DIRPATH_CLONE"
                DIRPATH_CLONE="${DIRPATH_CLONE:1}"
                DIRPATH_CLONE="/Users/$(id -nu)""$DIRPATH_CLONE"
                IS_REL_PATH="True"
            else
                IS_REL_PATH="False"
            fi
        }

    #[FUNCTION] - Report error in case the directory entered doesn't exist
        InputTargetDirectoryErr() {
            Pretty_1statement "[ERROR] The path you specified is not a directory."
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
                    var_s1="User input invalid." ;
                    var_s2="Try again!" ;
                    Pretty_2results "$var_s1" "$var_s2"
                    InputTargetDirectoryErr ;
                done ;

                if [[ "$VAR_CREATE" == "y" ]] ; then
                    mkdir -p "$DIRPATH_CLONE" ;
                    Pretty_1result "Directory $DIRPATH_CLONE created successfully"
                elif [[ "$VAR_CREATE" == "n" ]] ; then
                    Pretty_1result "Directory not created."
                    Fn_InputTargetDirectory ;
                    continue
                fi
            #If the path starts with a ./, then the system gives an error and asks the user for a full path.
            elif [[ "$DIRPATH_CLONE" == "./"* ]] ; then
                var_s1="current path shortcut './' is not supported in this program."
                var_s2="please print the absolute or relative '~/' path instead."
                Pretty_2results "$var_s1" "$var_s2" ;
                Fn_InputTargetDirectory ;
            else    
                Pretty_1result "[ERROR] The path specified cannot be a directory. Please insert a valid path."
                Fn_InputTargetDirectory ;
            fi

        done

        #Convert back to relative directory
        if [ "$IS_REL_PATH"=="True" ]; then
            DIRPATH_CLONE="$REL_DIRPATH" ;
        fi

    #[STATUS] - Provide user with status of current configs
        Pretty_1result "Current target directory is $DIRPATH_CLONE"
#5. Cleanup After Install
    Pretty_header "Cleanup After Install"
    #[FUNCTION] - Option to delete installers once complete
        Fn_Cleanup() {
            Pretty_break ;
            read -p "Do you wish to cleanup the installer once the install process is complete? (y/n): " VAR_CLEANUP ;
        }
    #[PROCEDURE] - Run function & validation rules
        VAR_CLEANUP="y" ;
        Fn_Cleanup ;
        while [[ "$VAR_CLEANUP" != "y" ]] && [[ "$VAR_CLEANUP" != "n" ]] ; do
            var_s1="User input invalid."
            var_s2="Try again!"
            Pretty_2results "$var_s1" "$var_s2"
            Fn_Cleanup ;
        done
    #[STATUS] - Provide user with status of current configs
        if [[ "$VAR_CLEANUP" == "y" ]] ; then
            Pretty_1result "Cleanup enabled" ;
        elif [[ "$VAR_CLEANUP" == "n" ]] ; then
            Pretty_1result "Cleanup disabled" ;
        fi        
#6. Enable Install Script
    Pretty_header "Enable Install Script"
    #[FUNCTION] - Option to enable the script for the ScriptRunner.sh
        Fn_Enable() {
            var_s1="[INFO] By enabling the installer script, the script runner will run this Script"
            var_s2="along with all the other enabled scripts. If the script is disabled, it can still"
            var_s3="be run manually."
            Pretty_3statements "$var_s1" "$var_s2" "$var_s3"
            Pretty_break
            read -p "Do you wish to enable this installer script? (y/n): " VAR_ENABLE ;
            Pretty_break
        }
    #[PROCEDURE] - Run function & validation rules
        VAR_ENABLE="y" ;
        Fn_Enable ;
        while [[ "$VAR_ENABLE" != "y" ]] && [[ "$VAR_ENABLE" != "n" ]] ; do
            var_s1="User input invalid."
            var_s2="Try again!"
            Pretty_2results "$var_s1" "$var_s2"
            Fn_Enable ;
        done
    #[STATUS] - Provide user with status of current configs
        if [[ "$VAR_ENABLE" == "y" ]] ; then
            Pretty_1result "Script enabled"
        elif [[ "$VAR_ENABLE" == "n" ]] ; then
            Pretty_1result "Script disabled"
        fi 
#7. Summary of current configurations
    Pretty_header "Summary of current configurations"
#8. Generate Install Script
    Pretty_header "Generate Install Script"
#9. Summary
    Pretty_header "Current Configurations"
    echo Installer: $FULLPATH_ORIGINAL ;
    echo Directory to copy: $DIRPATH_ORIGINAL ;
    echo Target directory: $DIRPATH_CLONE ;
    echo Cleanup after install? $VAR_CLEANUP ;
    echo Install script enabled? $VAR_ENABLE ;
#Extra Comments
    #Strip slashes from the end of the second and third input
    #Input validation for the last two inputs.
    #Limit file types (validation for header 1)
