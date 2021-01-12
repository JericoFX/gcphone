###### GCPHONE  JERICOFX#3512

if you think that my time deserve a coffe

# buymeacoff.ee/jericofx

Take from the original resource and modified to work with Qbus based servers.


------------

# IMPORTANT INFORMATION

I found a fix to the Nil values in the server console, it happend because when we are in the selection menu, the resource want an id, at that momento we dont have that, so the fix i found is going to the rs-spawn (qb-spawn) in this part https://prnt.sc/wdv3av  put the trigger event in this case is  TriggerEvent('gcphone:FixOnLoad)  like the image.

To install this resource you need:

if you use a Custom based QBCore like me just change FXCore to .........

MenuV from Tigo https://github.com/ThymonA/menuv (No need yet)

Run the SQL code.

The Resource name MUST BE gcphone

start the dependences like Screenshot-basic first

Change in the config.lua the discord WEBHOOK << # IF YOU DONT CHANGE THIS THE PICTURE FAIL AND CRASH

No copyright, but aprecciate if you give me credit for the work, it take me a lot of time to make it work. Know Issues:



* For some reason the Yellow pages duplicate the post. # just fixed itself....

* Didnt test the call so... # TESTED IN OTHER SERVERS AND WORK 

* Some cars cann´t be take from the  garage using valet. # FIXED

* Sometimes the bank app open in full white screen # FIXED

* News # WORKING, 
  - Bind Command "newsmenu", be sure to have the correct job.

* Uber Eats didnt touch yet #WORKING

# There is 2 new Config options Config.Core <<< here just put the core version and Config.CoreNotify << put the Notify server side ("QBCore:Notify") etc etc



Dependences:
* https://www.mediafire.com/file/petxs615og5tkvc/%255BPHONE%255D.rar/file
* https://www.mediafire.com/file/6je3l173jg70cri/input.rar/file
REMEMMBER THIS IS A WORK IN PROGRESS SO EXPECT SOME BUGS
