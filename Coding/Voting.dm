#define INPUT 0
#define ALERT 1
votingsystem
    var
        list/results[0] //results of the poll
        list/choices //list of choices
    proc/exec(determine,msg,title,list/choices,timer,default,method,list/voters)
        /*
            if there is no voters list, check if the voters variable is defined
            itself and if so make it a list. otherwise, make the list include
            every single client present
        */
        if(!istype(voters)||!voters.len)
            if(voters) voters=list(voters)
            else
                voters=list()
                for(var/client/C) voters+=C

        /*
            make sure we can choose something and that we have more than one
            thing to choose from
        */
        if(!istype(choices,/list)||choices.len<=1){ del src }

        /*
            convert every choice to text. otherwise, the input/alert boxes
            won't hold them
        */
        for(var/i=1 to choices.len) choices[i]="[choices[i]]"

        /*
            begin the actual voting
        */
        for(var/X in voters) spawn
            var/client/C
            if(ismob(X)) C=X:client
            else if(istype(X,/client)) C=X
            if(!C) continue

            var/choice
            if(method==ALERT&&choices.len<=3) choice=alert(C,msg,title,choices[1],\
				choices[2],(choices.len==3?(choices[3]):))
            else choice=input(C,msg,title,default) as null|anything in choices
            results[C.key]=choice?("[choice]"):(null)

        sleep(timer)
        return results //relay the results

proc/votingsystem(determine=1,msg="Please select an option.",title="Vote",\
		list/choices=list("Yes","No"),timer=300,default,method=INPUT,list/voters)
    var/votingsystem/V=new
    .= V.exec(arglist(args))

    if(determine) //determine the winner(s)
        for(var/X in choices) choices[X]=0
        for(var/X in .) choices[ .[X] ]++

        var/amnt=0
        .=null
        for(var/X in choices)
            if(!choices[X]) continue
            if(choices[X]>amnt){ .=list(); .[X]=choices[X]; amnt=choices[X] }
            else if(choices[X]==amnt) .[X]=choices[X]

    del V