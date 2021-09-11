# chkpasswd
authenticates a given unix user against the shadow file (requires sudo/root to read from shadow)
```
usage: ./chkpasswd.sh <username> [-]
  - :	read password from stdin instead of keyboar instead of keyboard
```
examples with wrong password:
```
$ echo 'Wr0ng_P4ss' | ./chkpasswd.sh admin -

hashes don't match.
user admin wasn't able to authenticate against shadow file

$ echo $?
1

$ ./chkpasswd.sh admin
enter password for user admin:
R1ght_P4ss (input hidden)
please enter the password again:
Wr0ng_P4ss (input hidden)

sorry, that didn't match, try again...

enter password for user admin:
Wr0ng_P4ss (input hidden)
please enter the password again:
Wr0ng_P4ss (input hidden)

hashes don't match.
user admin wasn't able to authenticate against shadow file

$ echo $?
1
```
examples with correct password:

```
$ echo 'R1ght_P4ss' | ./chkpasswd.sh admin -
Success. User admin authenticated against shadow.
$ echo $?
0
$ ./chkpasswd.sh admin
enter password for user admin:
R1ght_P4ss (input hidden)
please enter the password again:
R1ght_P4ss (input hidden)
Success. User admin authenticated against shadow.
```

