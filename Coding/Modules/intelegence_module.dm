


mob/player/var
	list/IQlist = new()

datum/IQtype
	var
		IQtype
		subtype
	proc
		Match(T,S)
			return ( IQtype == T && subtype == S )
	New(T,S)
		IQtype = T
		subtype = S

mob/player/proc/CheckIQ(IQtype,subtype)

	if ( isobj(subtype) )
		subtype = subtype:type

	for ( var/datum/IQtype/IQ in IQlist )
		if ( IQ.Match(IQtype,subtype) )
			return


	src << "<B><font color = green>You become smarter!"
	var datum/IQtype/newIQ = new(IQtype,subtype)

	IQlist += newIQ

mob/player/proc/GetIQ()
	return round( IQlist.len / 2 )


mob/player/proc/GetIQName()

	switch ( GetIQ() )
		if ( 0 to 10 )		return	"Tourist"
		if ( 11 to 20 )		return	"Savage"
		if ( 21 to 30 )		return	"Average"
		if ( 31 to 40 )		return	"Above Average"
		if ( 41 to 50 )		return	"Developed"
		if ( 51 to 60 )		return	"A Natural"
		if ( 61 to 70 )		return 	"Survivor"
		if ( 71 to 80 )		return	"Great Survivor"
		else				return  "Bear Grylls"