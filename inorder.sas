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

vars <- c(...)

test <- within(data, 
               inorder <- sapply(1:dim(data)[1], function(x) {
                 tmp1 <- sort(data[x, vars], na.last = NA)
                 tmp2 <- data[x, vars]  
                 tmp2 <- tmp2[ ,!is.na(tmp2), drop = FALSE]
                 return(as.numeric(identical(tmp1, tmp2)))
				}))

*/
