Overall intent of the program is to copy a file from one directory to another
then run the installer file.

The program is useful when working in an enterprise in which multiple computers
pull files from one centralized repository such as a NAS.

The program's ultimate goal is to have the user input the path of the original file
describe the file extension, and provide the directory where it will be installed.
Additional arguments will include arguments necessary for silent install or special
install parameters, and path extensions that may be necessary to run an installer from
an extracted package file (more details on this later).

Process for the user:

Use this command to activate the program:
- MyPath= <drag and drop this file in the terminal window then press enter>
- MyPath="${MyPath%/README.txt}" ; MyPath="$MyPath""/ActivateMe.sh" ; chmod +x $MyPath ; $MyPath 

Afterwards:
- Open the User_input.sh

- User_input:
    - [optional] User inputs the main folder that holds the installer.
    - User inputs the address of the installer that needs to be installed in the system.
    - User inputs the address of the directory in which the installer will be copied and
    installed
    - User selects whether the installer will be deleted after the install.
    - User will be prompted to activate the installer  
        - if the user answers yes, the file is placed in the active folder
        - if the user answers no, the file is placed in the inactive folder

- User can review active and inactive installers from a file
    - option to activate or deactivate installers

Background process:

- The name of the file will be trimmed, added an sh extension and used to store the 
parameter shell.

- The generated file will be added to a folder with all the installers that will be 
run by the Script_runner

- The Input_parser.sh will extract information from the user input:
    - The extension will determine the install function to be used
    - The string after the slash is used to determine the name of the file
    - Installer directory to be copied:
        - opt1: If the main folder option is detailed then that string is used as the folder to be copied
        - opt2: If the optional field is left empty, the string before the last slash is the directory that
            is copied
        - *The optional field needs to be contained in the original installer filepath
    - The second user input is left unchanged

- The DMG_install_fn.sh details the process to istall a DMG file
    - (idea) once completed, deactivate the installer it just ran

- The pkg_install_fn.sh details the process to install a pkg file
    - (idea) once completed, deactivate the installer it just ran

- The Cleanup_installer.sh removes the installer folder once the process is complete
    - The script is run only if the User_input enables the cleanup option

- The Script_runner.sh will run all the installers currently active
    - Run chmod on all sh files in the directory
    - Execute all active installers.


Program Architecture

User_input
Script_runner
PKG_install_fn
dmg_install_fn
user input parser
    -extracts the filename and the necessary directory information from the user input
    -set the varibles used for the install functions
    -option to delete original file or not
Cleanup_installer_fn


