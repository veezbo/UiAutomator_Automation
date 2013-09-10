#!/bin/bash


#Usage Statement
usage()
{
	echo "
USAGE:
Used to Build, Push, and Run UiAutmator tests automatically

Required Arguments:
	-n <project name>
	-p <full path to project>
	-c <name of package where tests are bundled>

Optional Arguments: 
	-u displays this usage statement
	-h displays this usage statement
	-r supress the running of test (by default, runs)

Examples Uses:
	bash uiautomator.sh -n Create_Contacts -p /home/vibhor/workspace/Create_Contacts -c contacts.create_contacts
	"
}


#Generates Nice Error Messages
error()
{
	error_message="ERROR "
	error_message+="$1"
	len=${#error_message}
	diff=$(( (80-len) / 2 ))
	if (( diff <= 0 )); then
		echo ""
		echo "$error_message"
		usage
	else
		astString=$(getAstString $diff)
		error_message="${astString}${error_message}${astString}"
		if (( $len%2 == 1 )); then
			error_message+="*"
		fi
		echo ""
		echo "$error_message"
		usage
	fi
}
getAstString()
{
	str=""
	num="$1"
	for (( i=1; i <= num ; i++ ))
	do
		str+="*"
	done
	echo "$str"
}


#Useful for Determining if an Array Contains an Element
containsElement () 
{
  for val in "${@:2}"; do [[ "$val" == "$1" ]] && echo "true"; done
  echo "false"
}


#Generates nice calling messages
call()
{
	echo ""
	echo Calling: $1
	$1
}


#Generates a nice finish message
finish()
{
	echo ""
	echo SUCCESSFULLY FINISHED
	echo ""
	exit 0
}

set -e


#Return usage message if no arguments
if [[ $# == 0 ]]; then
	usage
	exit 0
fi


#Read in Arguments
name=""
path=""
package=""
run="true"
while getopts ":hun:p:c:r" opt; do
	case $opt in
		h)
			usage
			exit 1
			;;
		u)
			usage
			exit 1
			;;
		n)
			name="$OPTARG"
			;;
		p)
			path="$OPTARG"
			;;
		c)
			package="$OPTARG"
			;;
		r)
			run="false"
			;;
		:)
			error "Option -$OPTARG requires an argument"
			exit 1
			;;
		\?)
			echo "Invalid Argument: -$OPTARG" >&2
			usage
			exit 1
			;;
	esac
done
shift $(( OPTIND - 1 ))


#Basic checks to ensure our required arguments have been given

if [[ "$name" == "" ]]; then
	error "Please Enter the name of your project"
	exit 1
fi

if [[ "$path" == "" ]]; then
	error "Please Enter the full path to your project"
	exit 1
fi

if [[ "$package" == "" ]]; then
	error "Please Enter the name of the package where the tests are bundled"
	exit 1
fi


#Get to the project directory
call "cd $path"


#Generate the Build
call "android create uitest-project -n $name -t 1 -p $path"


#Build the .jar file
call "ant build"


#Get the .jar file's name
call "cd bin"
jar_file=$(find . -name "*.jar")
jar_file=${jar_file:2:${#jar_file}-2}


#Push the .jar file to the device
call "adb push ${path}bin/$jar_file /data/local/tmp"


#Finally, make the call to run the tests, if not indicated otherwise
if [[ "$run" == "true" ]]; then
	call "adb shell uiautomator runtest $jar_file -c $package"
fi


finish
