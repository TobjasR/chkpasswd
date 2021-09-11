#!/bin/bash

info="this script authenticates a given unix user against the shadow file";
usage="usage: ./chkpasswd.sh <username> [-]\n - :	read password from stdin instead of keyboar instead of keyboard";

enterpasswd(){
	echo "enter password for user $user:";
	read -s passwd;
	echo "please enter the password again:";
	read -s passwd2;
	if [ "$passwd" != "$passwd2" ]; then
		echo -e "\nsorry, that didn't match, try again...\n";
		return 1;
	fi;
	return 0;
}

getpasswd(){
	while : ; do
		enterpasswd;
		[[ $? != 0 ]] || break;
	done;
}

case $# in
	1)
		user=$1;
		getpasswd;
		;;
	2)
		user=$1;
		passwd=$(</dev/stdin);
		;;
	*)
		echo -e $info;
		echo -e $usage;
		exit 1;
		;;
esac

linestr=`getent shadow $user`;
if [ $? -ne 0 ]; then
	echo "cannot find user $user in shadow file";
	exit 1;
fi;

IFS=':' read -r -a linearray <<< "$linestr";
hashstr="${linearray[1]}";
IFS='$' read -r -a hasharray <<< "${hashstr}";

algo="${hasharray[1]}";
salt="${hasharray[2]}";
h4sh="${hasharray[3]}";

chck=`echo $passwd | openssl passwd -stdin -$algo -salt $salt`
if [ "$chck" != "$hashstr" ]; then
	echo -e "\nhashes don't match.\nuser $user wasn't able to authenticate against shadow file\n";
	exit 1;
fi
echo "Success. User $user authenticated against shadow.";
exit 0;
