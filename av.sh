#!/bin/bash

echo "No-Name AV v0.1.0-dev"

if [[ ${UPDATE} = 1 ]]
then
	echo -n "Connect to the server without a SSL?(y/n): "
	read conToTheSrv
	if [ ${conToTheSrv} == "y" ]
	then
		echo "Downloading db.txt..."
		curl -O http://hello-world.ct8.pl/current/db.txt
		curl -O https://virusshare.com/hashfiles/VirusShare_00052.md5 #130k md5 
		if ! [ -f db.txt ]
		then
			echo "The db.txt file does not exist in the current directory. (${PWD})"
			exit -1
		else
			echo "Updated successfully."
			exit 0;
		fi
	else
		echo "Exit."
		exit -1;
	fi
fi

if ! [ $1 ]
then
	echo "Please specify the file path."
	exit -1
fi

init() {
	if [[ -f db.txt ]]
	then
		database=$(cat db.txt)
	else
		echo "Unable to load the database"
	fi
}

scan() {
	echo "${#files[@]} file(s) to scan."
	sleep 2
	for f in ${files[*]}
	do
		echo "Scanning \"${f}\" ... "
		for x in ${database}
		do
			if [[ $(md5sum ${f} | sed "s/  ${f//"/"/"\/"}//I") == ${x} ]]
			then
				echo -e "\033[1;31mTHREAT FOUND: ${f}\033[1;0m"
				threats+=(${f})
			fi
		done
	done
	summary;
}

summary() {
	echo -n "Scan finished. "
	if ! [ ${threats} ]
	then
		echo "No threats found."
		exit 0
	fi
	
	echo "Threats found: ${#threats[@]}"
	echo -n "Would you like to display list of the threats?(y/n): "
	read dispThreats;
	if [ ${dispThreats} == "y" ]
	then
		for t in ${threats[*]}
		do
			echo "${t}"
		done
	fi
	echo -n "Would you like to try to get rid of all of the threats?(y/n): "
	read remThreats;
	if [ ${remThreats} == "y" ]
	then
		for t in ${threats[*]}
		do
			rm -rf "${t}"
			if [ -f ${t} ]
			then
				echo "Warning: the ${t} is still exist."
			else
				echo "Success: the ${t} is gone."
			fi
		done
	else
		echo "Warning: the dangerous files are still exist."
	fi
}

init;

for arg in $@
do
	if [ -f ${arg} ]
	then
		files+=(${arg})
	else
		if [ -e ${arg} ]
		then
			echo "${arg} exist, but it's not a regular file. Skipping..."
		else
			echo "${arg} does not exist."
		fi
	fi
done

scan;
