mob/player/proc/Report(text)
	if(fexists("reports/reports.txt"))
		var/a = {"[file2text("reports/[ckey]/reports.txt")]"}
		a += text
		text2file(a,"reports/[ckey]/reports.txt")
	else
		var/savefile/a = new /savefile ("reports/[ckey]/reports.txt")
		text2file(a,"reports/[ckey]/reports.txt")