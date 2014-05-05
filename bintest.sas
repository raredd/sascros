
/*

*** example usage ;
	this example provides solutions for p0 between 10% and 15% against
	a p1 value of 20% while constrained by an optimistic total accrual 
	of 80 subjects:

%bintest(p0low = 0.1, p0high = 0.15, p1low = 0.2, p1high = 0.2, 
		 maxn = 80, maxr = 80, alpha = 0.08, power = 0.76) ;

*/

%macro bintest(p0low = , p0high = , p1low = , p1high = , maxn = , maxr = , alpha = , power = ) ;
* macro for exact binomial sample size constrained by max sample size and 
	number of responses (optional), varying sample sizes from 1 to maxn ;
	*** usage ;
	* p0low, p1low: start values of p0, p1, respectively ;
	* p0high, p1high: end values of p0, p1, respectively ;
	* maxn, maxr: maximum number of patients and responses, respectively ;
	* alpha: type I error ;
	* power: 1 - type II error ;
	*** return ;
	* data set with  ;

data dat ;
	do p0 = &p0low to &p0high by 0.01 ;
	do p1 = &p1low to &p1high by 0.01 ;
	do n = 1 to &maxn by 1 ;
	do r = 1 to &maxr by 1 ;
		output;output;output;output ;
	end;end;end;end ;
run ;

data dat ;
	set dat ;
	 	*we require >r responses out of n ;
		r2 = r + 1 ;

		if p1 <= p0 then delete ;
		if r >= n then delete ;

		** prob. of <r2 responders under the assumption* ;
		y = probbnml(p0,n,r2) ;

		** that standard response P0 is true** ;
		** this is prob. >r2 responders for P0** ;
		alpha = 1 - y ; 

		** prob. of <r2 responders under the assumption*;
		z = probbnml(p1, n, r2) ;

		** that experimental response P1 is true** ;
		** this is prob. >r2 responders for P1** ;
		power = 1 - z ;
		diff = p1 - p0 ;

		if power > &power and alpha < &alpha ;
run ;

proc sort data = dat nodupkey ; by _all_ ; run ;
data dat (keep = p0 p1 r2 n alpha power diff) ; set dat ; run ;
proc print data = dat ; run ;

%mend bintest ;
