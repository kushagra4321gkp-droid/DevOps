# Syntax for ifelse in shell


###############################################
a=5
b=10

if [ $a -gt $b ]
then
    echo "a is greater than b"
else
    echo "b is greater than a"
fi	
####################### or ####################

if (( a > b ))
then
    echo "a is greater than b"
else
    echo "b is greater than a"
fi
