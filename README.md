###### GCPHONE  JERICOFX#3512

if you think that my time deserve a coffe

buymeacoff.ee/jericofx

Take from the original resource and modified to work with Qbus based servers.


------------

# IMPORTANT INFORMATION

I found a fix to the Nil values in the server console, it happend because when we are in the selection menu, the resource want an id, at that momento we dont have that, so the fix i found is going to the rs-spawn (qb-spawn) in this part https://prnt.sc/wdv3av  put the trigger event in this case is       TriggerEvent('crew:onPlayerLoaded', source)  like the image.

To install this resource you need:

if you use a Custom based QBCore like me just change FXCore to .........

MenuV from Tigo https://github.com/ThymonA/menuv (No need yet)

Run the SQL code.

The Resource name MUST BE gcphone

start the dependences like Screenshot-basic first

Change in the config.lua the discord WEBHOOK

No copyright, but aprecciate if you give me credit for the work, it take me a lot of time to make it work. Know Issues:



* For some reason the Yellow pages duplicate the post.

* Didnt test the call so... posibility doest work, 

* Some cars cann´t be take from the  garage using valet.

* Sometimes the bank app open in full white screen

* News are Unfinished

* Uber Eats didnt touch yet

... So if is so buggy why the hell do you release this?

- because i need some help finding bugs, i have a local server so i cann´t test everything



Dependences: https://www.mediafire.com/file/petxs615og5tkvc/%255BPHONE%255D.rar/file
REMEMMBER THIS IS A WORK IN PROGRESS SO EXPECT SOME BUGS
