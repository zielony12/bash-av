# What does it do?
It gets a potentially malicious programs' md5 hash, and checks does it is in the db.txt file. If it does, it detects the program as a threat.
# How to add own program to the database?
Just simply run ( needs sed ):
```
echo $(md5sum the_program | sed 's/  the_program//I') >> db.txt
```
# How to scan the files?
Run the av.sh script with path to the program(s) as the arguments. Sample usage:
```
./av.sh program1 program2 ../programs/*
```
