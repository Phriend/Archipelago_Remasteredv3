
/*mob
	var
		color=rgb(0,230,230)
//mob/player
//
//	Stat()
//		..()
//		src.overlays=0//Clears the player's overlays so the letters won't build up on top of each other.
//		src.Name(src.name)//Activates the Name() proc. The argument matches the text argument in the Name() proc, telling the proc to use that text string.
//Login. Player icon and location are determined.


These two verbs are used to test the demo. The first verb changes your name so you can see what the text name looks like.
Remember, if your name is bigger than 20 characters(that includes spaces and puncuation, your name will be cut off and a "..." will be added.
The second verb changes the color of the text. Note the "removed". This means that to achieve a true green you don't enter (0,255,0), because it is being subtracted from white.
Instead, you should input(255,0,255), because this will take all the red and blue away, and leave you with lots of green.
*/

obj
	letters
		icon='Letters.dmi'
		layer=MOB_LAYER+99

mob//Mob hmmm, let me think...
	proc//We all know what a proc is.
		Name(text as text)//Make it so the proc requires some text.
			if(length(text)>=21)//If the text has more than 20 characters;
				text=copytext(text,1,21)//Make the text the first 21 characters;
				text+="..."//And for fun lets add the "...".
			var/list/letters=list()//Make a list for later.
			var/CX//Another variable, for the pixel x.
			var/OOE=(lentext(text))//A variable so you can center it.
			if(OOE%2==0)//If you don't know what an if statment is, you probably shouldn't download this.
				CX+=11-((lentext(text))/2*5)//We do want it centered?
			else
				CX+=12-((lentext(text))/2*5)//Right. P.S. Don't fool around with this unless you know exactly what you are doing.
			for(var/a=1, a<lentext(text)+1, a++)//Cut all of the letters up;
				letters+=copytext(text,a,a+1)//And add them to our letters list().
			for(var/X in letters)//For EVERY character in the letters list();
				var/obj/letters/O=new/obj/letters//Make a new letter obj.
				O.icon_state=X//Make the obj look like the character.
				O.pixel_x=CX//Set it on the correct pixel x, like in a map.
				O.pixel_y=-22//Put underneath the player.
				CX+=6//Increase the pixel x variable so they won't all end up on top of each other.
				src.overlays+=O//Add the letter to the players overlays.