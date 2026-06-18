cd c:\windows\system32\wbem\
net stop winmgmt
winmgmt /resetrepository
net start winmgmt
shutdown -r -f -t 0
