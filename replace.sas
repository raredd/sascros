/*
*** example data ;

data tmp ;
	input id var1 - var5 ;
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


*** example usage ;

proc print data = tmp ; run ;

* replace all . with -1 in entire data set ;
%replace(tmp, _ALL_, ., -1) ;
proc print data = tmp ; run ;

* replace all -1s with -1111 in only var1 ;
%replace(tmp, var1, -1, -1111) ;
proc print data = tmp ; run ;

* replace all -1 with 0 for variables var1 var2 var3 ;
%replace(tmp, var1 -- var3, -1, 0) ;
proc print data = tmp ; run ;

* replace -1 or -1111 with . only for var1 thru var4 ;
%replace(tmp, var1 -- var4, -1 -1111, .) ;
proc print data = tmp ; run ;

*/


%macro replace(dataset, vars, pattern, replacement) ;
* macro for pattern replacement ;
	*** usage ;
	* dataset: data to recode ;
	* vars: variables in data set to use ;
	* pattern: search pattern(s) ;
	* replacement: replacement pattern ;
	*** return ;
	* original data with replacement for all occurences of pattern(s) ;
data _tmp_ ; 
	set &dataset ;
	keep &vars ;
run ;

data _tmp_ ;
	set _tmp_ ;
    array nums _numeric_ ;
    do over nums ;
		%if %upcase(&pattern) ne %then %do ;
		    if nums in(&pattern) then nums = &replacement ;
		%end ;
	end ;
run ;

data &dataset ;
	merge &dataset _tmp_ ;
run ;

%mend replace ;
