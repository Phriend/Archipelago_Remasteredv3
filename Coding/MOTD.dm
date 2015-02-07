var/MOTD={"
Welcome to Archipelago Remastered:Version 3.0 Server, [world.host] is your host today.<br>
<br>
* - Night/Day removed. New Day & Time are still in.<br><br>
A Beginnners Guide:<br>
http://archipelagoremastered.myfreeforum.org/The_Guide_For_Real__about26.html<br>
<br>
Other guides(Warning, if you want to figure out the game yourself, These will spoil that)<br>
http://apinkbunny07.deviantart.com/art/Archipelago-Guide-75270616<br>
http://lifelylistings.blogspot.com/2010/09/for-my-fellow-archipelago-remastered.htmll<br>
"}


mob/proc/MOTD_Display()
	var/html="<body bgcolor=black><font color=white><b><u>Message Of The Day:</b></u><br/><br/>[MOTD]</font></body>"
	src << browse(html,"window=MOTD")


mob/verb/View_MOTD()
	set category="Commands"
	src.MOTD_Display()