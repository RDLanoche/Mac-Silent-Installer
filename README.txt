Overall intent of the program is to copy a file from one directory to another
then run the installer file.

The program is useful when working in an enterprise in which multiple computers
pull files from one centralized repository such as a NAS.

The program's ultimate goal is to have the user input the path of the original file
describe the file extension, and provide the directory where it will be installed.
Additional arguments will include arguments necessary for silent install or special
install parameters, and path extensions that may be necessary to run an installer from
an extracted package file (more details on this later).

Program Architecture

User_input
Script_runner
PKG_install_fn
dmg_install_fn
user input parser
    -extracts the filename and the necessary directory information from the user input
    -set the varibles used for the install functions

