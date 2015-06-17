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

%inorder(dataset = tmp, vars = var1 -- var5) ;
%inorder(dataset = tmp, vars = var1 var3 -- var5, keep = id) ;

*/

%macro inorder(dataset = , vars = , keep = ) ;
* macro to check if vars are in sequential order ;
	*** usage ;
	* dataset: data 
	* vars: list of vars to check order ;
	* keep: other variables to keep ;
	*** return ;
	* dataset with original variables (plus any "keep" variables) ;
	* where dummy = 1 if vars are in order ;
	* i is the index for the first variable out of order (iff i < length(vars) );
data tmp_&dataset ;
	set &dataset ;
	array vars (*) &vars ;
	last_highest = . ;
	inorder = 1 ;
	do i = 1 to dim(vars) ;
		if vars(i) > . and vars(i) < last_highest then do ;
			inorder = 0 ;
			leave ;
		end ;
		last_highest = coalesce(vars(i), last_highest) ;
	end ;
run ;

proc print data = tmp_&dataset ;
	var &keep &vars inorder i ;
run ;
%mend inorder ;


/*
*** in R:

dat <- data.frame(date1 = 2:1, date2 = c(3, NA), date3 = 1:2)
dat[] <- lapply(dat, as.Date, origin = '1970-01-01')

vars <- c('date1', 'date2', 'date3')

within(dat, {
  inorder <- vapply(seq_len(nrow(dat)), function(x)
    !is.unsorted(dat[x, vars], na.rm = TRUE), integer(1))
})

#        date1      date2      date3 inorder
# 1 1970-01-03 1970-01-04 1970-01-02       0
# 2 1970-01-02       <NA> 1970-01-03       1

*/
