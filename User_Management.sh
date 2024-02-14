# This script is to automate user management process (User Creation, Deletion, Password reset and modify user accounts)

#Author: Anjana Muraleedharan
#Date:12-04-2024
#Version V1.0


#Function to display usage instructions

function usage(){
echo "Usage:$0 [Options]"
echo "Options : "
echo " -a, --add-user Add new user"
echo " -d, --delete-user Delete a user"
echo " -re, --reset-password Reset password"
echo " -ug, --user-group Adding a user to group"
echo " -rg, --remove-user-group Removing a user from group"
echo " -g, --user-group Creating a group"
echo " -r, --remove-group Remove a group"
echo " -b, --backup Back up a directory"
echo " -h, --help Display help"
# Terminating the function & script
exit 1 
}

# Function to add a new user
# Check whether the user already exists in the system

function user_add(){
read -p "Enter the User name : " user_name

if id $user_name &>/dev/null 

then
echo "User already exists!"
else
read -s -p "Enter Password : " password
sudo useradd -m -p "$(openssl passwd -1  $password)" $user_name
echo
echo "user $user_name is added" 
fi
}
#Function to reset password
function reset_password(){
read -p "Enter the username " user_name
if id $user_name &>/dev/null
then
read -s -p "Enter the password for $user_name " password
echo 
echo -e "$password\n$password" | sudo passwd $user_name
fi
}

#Function to delete a user

function user_del(){
read -p "Enter the username of the account: " user_name
read -p "Proceeding to delete the user..? (y/n): " option
if [ $option == y ]
then
sudo userdel -r $user_name
fi
}

#Function to add a user to group
function user_group_add(){
read -p "Enter the username : " user_name
read -p " Enter the group name : " group
sudo usermod -aG $group $user_name
echo "User $user_name is added to $group"
}
#Function to remove user from a group

function remove_user_group(){
read -p "Enter the username : " user_name
read -p "Enter the group name : " group
read -p " Are you sure you want to remove $user_name from $group? (y/n)" option
if [ $option == y ]
then 
sudo gpasswd -d $user_name $group_name
echo "User $user_name is removed from $group"
fi
}
#Function to add a group in the system

function Create_group(){
read -p "Enter the group name to be created : " group_name
read -s -p "Enter the group password : " group_password
echo
sudo groupadd -r -p "$(openssl passwd -1 $group_password)" $group_name
echo " $group_name is created in the system"
}
#Function to remove a group

function remove_group(){
read -p "Enter the group to be removed " group_name
sudo groupdel $group_name
echo "Group $group_name  is deleted" 
}

#Function to take back up
function backup(){
#The directory for which back up has to be taken

Source_Dir=/home/ubuntu/scripts

#The Destination direcory where back up file has to be placed

Destination_Dir=/home/ubuntu/Backup

#Name of the back up file

Backup_File=bkp_$(date +%Y-%m-%d).tar.gz

tar -cvf $Destination_Dir/$Backup_File $Source_Dir
}

#main logic 
for option in $@
do
case $option in
	-a|--add-user)
	user_add
	;;
-d|--delete-user)
	user_del
	;;
	-g|--add-group)
	Create_group
;;

-rg|--remove-user-group)
	remove_user_group
	;;
-re|--reset-password)
	reset_password
	;;
-ug|--user-group)
user_group_add
;;
-r|--remove-group)
remove_group
;;
-h|--help)
usage
;;
-b|--backup)
backup
;;
*)
echo "Invalid option:$option"
usage
;;
esac
done
#if no options are provided, display usage
if [ $# -eq 0 ]
then
usage
fi
