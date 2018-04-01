defmodal(senderset, senderset,
	 ADD_RECIP
	:parameters (?sender - c_human
		    ?email - c_email
		    ?ruid - c_uid
		    ?recip - c_human)
	:precondition
	(   and (writing_email ?sender ?email)
	(   or (trusts_recipient ?sender ?recip)
	(   insider ?sender))
	(   has_uid ?recip ?ruid))
	:effect
	(   and (recipient ?email ?ruid)),
	 "?sender adds recipient
	?recip (?ruid) to ?email")

defmodal(free, r1,
	 RELAY_VIEWED_DOC_1
	:parameters (?doc - c_file
		    ?src_host - c_host
		    ?s_proc - c_process
		    ?src_proc - c_process
		    ?malware - c_program
		    )
	:precondition
	(   and
	(   viewing_doc ?src_host ?s_proc ?doc)
	(   running_prog ?src_host ?src_proc ?malware)
	(   can_transmit_documents ?malware)
	)
	:effect
	(   and (transmitting ?src_host ?doc))
	)


defmodal(r1,free,
	 RELAY_VIEWED_DOC_2
	:parameters (?doc - c_file
		    ?human - c_human
		    ?src_host - c_host
		    ?dst_host - c_host
		    ?dst_proc - c_process
		    ?master - c_program)
	:precondition
	(   and
	(   transmitting ?src_host ?doc)
	(   at_host ?human ?dst_host)
	(   running_prog ?dst_host ?dst_proc ?master)
	(   can_receive_documents ?master)
	(   net-connected ?src_host ?dst_host)
	)
	:effect
	(   and
	(   viewing_doc ?dst_host ?dst_proc ?doc)))


%% . . .
%% if H is carrying K, K is not in a room

causes( carrying(H,K), -in_room(K,R) ) :-
	fluent(carrying(H,K)),
	fluent(in_room(K,R)).

%% vice versa
causes( in_room(K,R), -carrying(H,K) ) :-
	fluent(carrying(H,K)),
	fluent(in_room(K,R)).

%% nothing can be in two rooms at once!
causes( in_room(H,R1), -in_room(H,R2) ) :-
	fluent(in_room(H,R1)),
	fluent(in_room(H,R2)),
	R1\==R2.

%% person h picks up the key k in room r,
%% only if h and k are both in r.

action(grab_key(H,K,R)) :-
	c_human(H), c_key(K),c_room(R).
poss(grab_key(H,K,R),
     in_room(H,R) & in_room(K,R)).
effect(grab_key(H,K,R),true,carrying(H,K)).
