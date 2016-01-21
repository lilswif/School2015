## Cheat sheet en checklists

- Naam cursist: Van Brussel Frederik
- Bitbucket repo: https://bitbucket.org/lilswif/enterprise-linux-labo/

##Bash Commands


|   	|   	|
|---	|---	|
|uname -a|	Show system and kernel|
|head -n1 /etc/issue|	Show distribution|
|mount	|Show mounted filesystems|
|date	|Show system date|
|uptime	|Show uptime|

##Bash Shortcuts

|   	|   	|
|---	|---	|
|CTRL-c	|Stop current command|
|CTRL-z	|Sleep program|
|CTRL-a	|Go to start of line|
|CTRL-e	|Go to end of line|
|CTRL-u	|Cut from start of line|
|CTRL-k	|Cut to end of line|
|CTRL-r	|Search history|
|!!	|Repeat last command|
|!abc	|Run last command starting with abc|
|!abc:p	|Print last command starting with abc|
|!$	|Last argument of previous command|
|ALT-.	|Last argument of previous command|
|!*	|All arguments of previous command|

##Bash Variables

###Show environment variables

|   	|   	|
|---	|---	|
|echo $NAME |	Output value of $NAME variable|
|export $NAME=value|	Set $NAME to value|
|$PATH	|Executable search path|
|$HOME|	Home directory|
|$SHELL|	Current shell|

###Directory Operations

|   	|   	|
|---	|---	|
|pwd	|Show current directory|
|mkdir dir|	Make directory dir|
|cd dir	|Change directory to dir|
|cd ..	|Go up a directory|
|ls	|List files|

###ls Options

|   	|   	|
|---	|---	|
|-a	|Show all (including hidden)|
|-R	|Recursive list|
|-r	|Reverse order|
|-t	|Sort by last modified|
|-S	|Sort by file size|
|-l	|Long listing format|
|-1	|One file per line|
|-m	|Comma-separated output|
|-Q	|Quoted output|

###Search Files

|   	|   	|
|---	|---	|
|grep pattern files|	Search for pattern in files|
|grep -i	|Case insensitive search|
|grep -r	|Recursive search|
|grep -v	|Inverted search|
|grep -o	|Show matched part of file only|
|find /dir/ -name name*	|Find files starting with name in dir|
|find /dir/ -user name	|Find files owned by name in dir|
|find /dir/ -mmin num	|Find files modifed less than num minutes ago in dir|
|whereis command	|Find binary / source / manual for command|
|locate file	|Find file (quick search of system index)|

###Process Management

|   	|   	|
|---	|---	|
|ps	|Show snapshot of processes|
|top	|Show real time processes|
|kill pid	|Kill process with id pid|
|pkill name	|Kill process with name name|
|killall name	|Kill all processes with names beginning name|

###File Permissions

|   	|   	|
|---	|---	|
|chmod 775 file	|Change mode of file to 775|
|chmod -R 600 folder	|Recursively chmod folder to 600|
|chown user :group file|	Change file owner to user and group to group|

###File Permission Numbers

The first digit is the owner permission, the second the group and the third for everyone. Calculate each of the three permission digits by adding the numeric values of the permissions below.

4	read (r) <br>
2	write (w)<br>
1	execute (x)<br>

###File Operations

|   	|   	|
|---	|---	|	
|touch file1	|Create file1|
|cat file1 file2|	Concatenate files and output|
|less file1	|View and paginate file1|
|file file1	|Get type of file1|
|cp file1 file2	|Copy file1 to file2|
|mv file1 file2	|Move file1 to file2|
|rm file1	|Delete file1|
|head file1	|Show first 10 lines of file1|
|tail file1	|Show last 10 lines of file1|

