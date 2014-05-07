/*
*** example data ;

data tmp ;
	input id var1 vaR2 VAR3 Var4 var5 ;
	datalines ;
	1 1 2 3 4 5 
	2 1 2 . . .
	3 1 . . . 4
	4 . 3 . . .
	5 . . . . 5
	6 1 3 2 2 3
	7 5 3 7 8 9
	8 1 . . . 2
	9 1 . 2 3 4
	;
run ;
proc print ; run ;


*** example usage ;

%lowcase(tmp) ;
proc print ; run ;


*** ref ;
http://www.popcenter.umd.edu/resources/research-tools/stats-support/sas-frequently-used-code-revised
*/

* options mprint ; 
%macro lowcase(dsn); 
%let dsid = %sysfunc(open(&dsn)) ; 
%let num = %sysfunc(attrn(&dsid, nvars)) ; 
%put &num ;
 data &dsn ; 
 	set &dsn(rename = (
			%do i = 1 %to &num ;
				%let var&i = %sysfunc(varname(&dsid, &i)) ;
				&&var&i = %sysfunc(lowcase(&&var&i))
			%end ; )) ;
		%let close = %sysfunc(close(&dsid)) ;
run ; 
%mend lowcase ; 
