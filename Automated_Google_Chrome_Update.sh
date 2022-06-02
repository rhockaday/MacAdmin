#!/bin/bash

# This script will be used to automate the process of updating google chrome. 
# The script will check omahaproxy for the newest mac stable release version of google chrome and check it agains the current installed version on the machine. 
# It will then do a series of if-then statements to determine whether or not to install the newest version or exit.


#create variable desired_version for the requested app to be checked against.

desired_version=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac,stable/{print $3; exit}')

# Get line to match against with new variable called version_line. If version_line cannot be found. Google Chrome will be automatically installed. 



# Begin if then statement to determine if the app is installed or not
# remember [[ $? -ne 0 ]] is checking the standard output to see if the previous command completed based on STD output. A zero status usually means "success".
# in this case it is looking at grep to see if it exits with a zero status. Grep will only exit with a zero status if the match has been found.
# [[ $? = exit status ;  -ne = not equal ; 0 = the requested standard output [[ $? -ne 0 ]] ;
# If it is a sucess then it will move on to the next if then statement.

version_line=$(defaults read /Applications/Google\ Chrome.app/Contents/Info.plist CFBundleShortVersionString)
if [[ $? -ne 0 ]]; then
    version_line=$(defaults read /Applications/Google\ Chrome.app/Contents/Info.plist CFBundleShortVersionString)
    if [[ $? -ne 0 ]]; then #if it failed again, the app is not installed at that path
        echo "Google Chrome is not installed at all"
        echo "Google Chrome will install itself now"
        cd /Applications/
        curl -LO https://dl.google.com/chrome/mac/stable/accept_tos%3Dhttps%253A%252F%252Fwww.google.com%252Fintl%252Fen_ph%252Fchrome%252Fterms%252F%26_and_accept_tos%3Dhttps%253A%252F%252Fpolicies.google.com%252Fterms/googlechrome.pkg
        installer -pkg /Applications/googlechrome.pkg -target /Applications/
        echo "Newest Version of Google Chrome has been successfully installed."
        echo "Deleting Installer from Machine."
        rm -f /Applications/googlechrome.pkg
        echo "Installer has been successfully removed."
        exit 123456
    fi
fi


# Some text editing to get the real version number. Script will exit if the strings match. 

real_version=$(echo $version_line)
if [ "$real_version" = "$desired_version" ]; then
    echo "Google Chrome Version $desired_version is installed and is currently up to date"
    exit 0
fi

#If the versions do not match. The newest version will be downloaded from the website updating the older version. 

real_version=$(echo $version_line)
if [[ "$real_version" != "$desired_version" ]]; then
    echo "Installing Version of Newest Google Chrome Now"
    cd /Applications/
    curl -LO https://dl.google.com/chrome/mac/stable/accept_tos%3Dhttps%253A%252F%252Fwww.google.com%252Fintl%252Fen_ph%252Fchrome%252Fterms%252F%26_and_accept_tos%3Dhttps%253A%252F%252Fpolicies.google.com%252Fterms/googlechrome.pkg
   installer -pkg /Applications/googlechrome.pkg -target /Applications/
   echo "Newest Version of Google Chrome has been successfully installed."
   echo "Deleting Installer from Machine."
   rm -f /Applications/googlechrome.pkg
   echo "Installer has been successfully removed."
fi

exit 0

