#!/bin/sh

#Input path to the existing installer
echo You may drag and drop the file into this terminal to quickly generate the installer path
read -p "Insert the address to the installer file: " FULLPATH_ORIGINAL

#Optional path if the installer is not a direct sub of the program's main directory
echo if the installer file is nested deeper than directly in the program\'s parent directory, insert the path you wish
echo to copy on your system containing the installer. The system will check to ensure this path is parent to the previous
echo input.
read -p "[optional] Insert the path to the main directory containing the installer file: " DIRPATH-PARENT-ORIGINAL

#Input path to the directory where the installer will be copied to
echo To avoid errors, it is recommended to create, locate then drag and drop the folder to this window.
read -p "Insert the path to the directory where the installer will be copied: " DIRPATH_CLONE

#option to delete installers once complete or not
read -p "Do you wish to cleanup the installer once the install process is complete? (y/n): " VAR_CLEANUP

#option to activate the installer or keep it inactive
read -p "Do you wish to activate this install procedure? (y/n)" VAR_ACTIVE

#Strip slashes from the end of the second and third input
#Input validation for the last two inputs.
