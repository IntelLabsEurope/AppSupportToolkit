#/!bin/bash
#
# This would be copied to the /usr/bin directory and then the 'pipe- process
# would be used to invoke it.
# So .. for example
# 
#
# objdump -D -j .text --no-show-raw-insn --wide out/libcloudwave.so > fred.dat
# objdump -D -j .text --no-show-raw-insn --wide out/libcloudwave.so | ./dasm_count.sh
#
# Find out if there are some parameters supplied

# echo Script name: $0
# echo $# arguments 
if [ $# -ne 1 ]; 
    then echo "Illegal number of parameters"
	echo "Use something like '$0 'object_executable_filename' "
#	printf "Use something like '%s object_executable_filename' ",$0
	exit
fi

#echo " "
printf " "
#
# The JSON is already open
#
printf "|name| : |`realpath $1`|,"
#echo '"name" : "'`realpath $1`'",'
#echo '"name" : "'$1'",'
#echo "name : $1,"
#printf("\"name\" : \"%s\",$1);
#

printf "|analysis| : |static|, "
#echo "'analysis' : 'static', "
#echo '"analysis" : "static", '
#echo "analysis : static,"
#printf("\"analysis\" : \"static\"");
#
printf "|instructions| : {"
#echo "'instructions' : {"
#echo '"instructions" : {'
#echo "instructions : {"
#printf ( "\"instructions\" : {" );
#
#
#
#
#objdump -D -j .text -M intel --no-show-raw-insn --wide $1 | awk '
objdump -d -h -j .text -M intel --no-show-raw-insn --wide $1 | awk 2>/dev/null '
BEGIN {
#	print ( "-DISASM-" ); # REM if piping onwards !
}
{ 
# $ second column beginning with a-z lowercase
#	search for ":tab (upto 15) a-z lowercase followed by space"
	regex=":\t[a-z]{1,15} ";
}
{
	if(match($0,regex)) {
		if(match($2,"repz")) {
			printf ( "%s-%s",$2,$3 );
		}
		else {
			print ($2);
#			print ($0);
		}
	}
}
END {
#	print ( " - DONE -" ); # REM if piping onwards
}
' | sort  | awk '
BEGIN {
#	print ( "-COUNT-" );
}
{
}
{
	if ($1 == x) {
		total++; # bump insn count as match
	}
	if ($1 != x) {
		if (x == "") { # first time around !
#			print ("analysis : static");
#			printf ("\"analysis\" : \"static\"");
		}
		else {
#			print ( x " :", total );
# Neat
			printf ( "|%s| : %d, ",x,total );
#			printf ( " \"%s\" : %d,\n",x,total );
#			printf ( " \"%s\" : %d,",x,total );
		}
		total = 1;
		x = $1;
	}
}
END {
# get a line with no ',' at the end !
# Neat
	printf ( " |dummy| : 0 }" );
#	printf ( " \"dummy\" : 0\n}" );
#	printf ( " \"dummy\" : 0 }" );
#	print ( "-DONE-");
}
'
#
# say the magic word to let the task above know that we are done
# echo "-DONE-"
# printf "-DONE-"

