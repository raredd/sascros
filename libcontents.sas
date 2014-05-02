/*
this macro creates the data set 'contents' which will list all
contents from all sas data sets in the working directory ;


** usage example:

%libcontents(from = 'z:/project 1/2014/jan/source', 
			 to = 'z:/project 1/2014/jan/source')

options orientation = landscape ;
ods rtf file = '../out/contents.rtf' ;
proc print data = contents ; 
	var memname name length varnum label format ;
run ;
ods rtf close ;

*/

%macro libcontents(from = , to = ) ;

libname copyfrom &from ;
libname copyto &to ;

/* get contents for data sets (from one of the libraries), save result
in an output data set */
proc contents data = copyfrom._ALL_ 
  memtype = data 
  order = varnum 
  out = contents 
  noprint ;
run ;

* only keep these variables from proc contents ;
data contents ;
  set contents ;
  keep libname -- formatl ;
run ;

* sort prior to selecting unique data set names ;
proc sort data = contents ;
  by memname name ;
run ;

* Select unique data set names, remove unneeded datasets ;
data tmp ;
  set contents ;
  by memname name ;
  if memname in ('q_demo') then delete ;

/* because each variable in a data set produces an observation in
the output data set, we need to remove the duplicate MEMNAMEs. */
  if first.memname ;
run ;

* create data set names as macro variables & get total number ;
data _NULL_ ;
  set tmp end = last ;
  by memname name ;

* create a macro variable like DS1 with the value of MEMNAME ;
  call symput('DS' || left(_n_), trim(memname)) ;
  if last then call symput('TOTAL', left(_n_)) ;
run ;

proc sort data = contents ;
  by memname varnum ;
run ;

%mend libcontents ;
