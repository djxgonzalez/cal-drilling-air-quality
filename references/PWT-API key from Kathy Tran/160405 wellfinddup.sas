*********************************
*	Find duplicate API/PWT_ID	*
*	in raw monthly prod DOGGR	*
*	datasets 2001-2013			*
********************************;

libname well "C:\Users\kvtran\Documents\SAS\fracking\data\sasdat";
options formdlim = '-' nodate nonumber;

proc contents data=well.ogprod02api varnum; run;

*******************************
2001
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi1; by apino;
data pwtapi1; 
set well.pwtapi1; 
by apino; 
if first.apino and last.apino then delete; run;
proc print data=pwtapi1 (obs=100); title "key with records that are not unique by api";
run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi1; by pwt_id;
data ogprod01; 
set well.ogprod01api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;
proc print data=ogprod01 (obs=100); title "production with unique records by api";
run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
proc sort data=ogprod01; by pwt_id;
data compare; 
merge pwtapi1(in=a) ogprod01(in=b); 
by pwt_id; if a and b; run;
proc print data=compare (obs=100); 
   title1 "desired list: production records (unique by pwt value)";
   title2 "that are assigned to more than one api in the key";
run;
/*note: some APIs will be unique because the rep API from the key may not exist within the actual production dataset*/

proc sort data=compare; by apino; run;
proc print data=compare (obs=100); run;
/*determine #of PWTs with rep API*/
data compareA; 
set compare; 
by apino; 
if first.apino and last.apino then delete; run;
proc print data=compareA (obs=100); title "merged records that are not unique by api";
run;
/*determine # of rep APIs*/
data compareB; 
set compareA; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compareA;
set compareA;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compareA; by pwt_id;
proc sort data=well.ogprod01api; by pwt_id;
data well.ogprod01_repind;
merge compareA well.ogprod01api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod01_repind;
if apino=' '; run;

*******************************
2002
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi2; by apino;
data pwtapi2; 
set well.pwtapi2; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi2; by pwt_id;
proc sort data=well.ogprod02api; by pwt_id;
data ogprod02; 
set well.ogprod02api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare2; merge pwtapi2(in=a) ogprod02(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare2; by apino;
data compare2A; 
set compare2; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare2B; 
set compare2A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare2A;
set compare2A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare2A; by pwt_id;
proc sort data=well.ogprod02api; by pwt_id;
data well.ogprod02_repind;
merge compare2A well.ogprod02api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod02_repind;
if apino=' '; run;

*******************************
2003
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi3; by apino;
data pwtapi3; 
set well.pwtapi3; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi3; by pwt_id;
proc sort data=well.ogprod03api; by pwt_id;
data ogprod03; 
set well.ogprod03api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare3; merge pwtapi3(in=a) ogprod03(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare3; by apino;
data compare3A; 
set compare3; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare3B; 
set compare3A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare3A;
set compare3A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare3A; by pwt_id;
proc sort data=well.ogprod03api; by pwt_id;
data well.ogprod03_repind;
merge compare3A well.ogprod03api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod03_repind;
if apino=' '; run;

*******************************
2004
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi4; by apino;
data pwtapi4; 
set well.pwtapi4; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi4; by pwt_id;
proc sort data=well.ogprod04api; by pwt_id;
data ogprod04; 
set well.ogprod04api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare4; merge pwtapi4(in=a) ogprod04(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare4; by apino;
data compare4A; 
set compare4; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare4B; 
set compare4A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare4A;
set compare4A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare4A; by pwt_id;
proc sort data=well.ogprod04api; by pwt_id;
data well.ogprod04_repind;
merge compare4A well.ogprod04api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod04_repind;
if apino=' '; run;

*******************************
2005
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi5; by apino;
data pwtapi5; 
set well.pwtapi5; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi5; by pwt_id;
proc sort data=well.ogprod05api; by pwt_id;
data ogprod05; 
set well.ogprod05api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare5; merge pwtapi5(in=a) ogprod05(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare5; by apino;
data compare5A; 
set compare5; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare5B; 
set compare5A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare5A;
set compare5A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare5A; by pwt_id;
proc sort data=well.ogprod05api; by pwt_id;
data well.ogprod05_repind;
merge compare5A well.ogprod05api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod05_repind;
if apino=' '; run;

*******************************
2006
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi6; by apino;
data pwtapi6; 
set well.pwtapi6; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi6; by pwt_id;
proc sort data=well.ogprod06api; by pwt_id;
data ogprod06; 
set well.ogprod06api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare6; merge pwtapi6(in=a) ogprod06(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare6; by apino;
data compare6A; 
set compare6; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare6B; 
set compare6A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare6A;
set compare6A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare6A; by pwt_id;
proc sort data=well.ogprod06api; by pwt_id;
data well.ogprod06_repind;
merge compare6A well.ogprod06api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod06_repind;
if apino=' '; run;

*******************************
2006
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi6; by apino;
data pwtapi6; 
set well.pwtapi6; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi6; by pwt_id;
proc sort data=well.ogprod06api; by pwt_id;
data ogprod06; 
set well.ogprod06api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare6; merge pwtapi6(in=a) ogprod06(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare6; by apino;
data compare6A; 
set compare6; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare6B; 
set compare6A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare6A;
set compare6A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare6A; by pwt_id;
proc sort data=well.ogprod06api; by pwt_id;
data well.ogprod06_repind;
merge compare6A well.ogprod06api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod06_repind;
if apino=' '; run;

*******************************
2007
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi7; by apino;
data pwtapi7; 
set well.pwtapi7; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi7; by pwt_id;
proc sort data=well.ogprod07api; by pwt_id;
data ogprod07; 
set well.ogprod07api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare7; merge pwtapi7(in=a) ogprod07(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare7; by apino;
data compare7A; 
set compare7; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare7B; 
set compare7A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare7A;
set compare7A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare7A; by pwt_id;
proc sort data=well.ogprod07api; by pwt_id;
data well.ogprod07_repind;
merge compare7A well.ogprod07api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod07_repind;
if apino=' '; run;

*******************************
2008
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi8; by apino;
data pwtapi8; 
set well.pwtapi8; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi8; by pwt_id;
proc sort data=well.ogprod08api; by pwt_id;
data ogprod08; 
set well.ogprod08api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare8; merge pwtapi8(in=a) ogprod08(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare8; by apino;
data compare8A; 
set compare8; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare8B; 
set compare8A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare8A;
set compare8A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare8A; by pwt_id;
proc sort data=well.ogprod08api; by pwt_id;
data well.ogprod08_repind;
merge compare8A well.ogprod08api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod08_repind;
if apino=' '; run;

*******************************
2009
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi9; by apino;
data pwtapi9; 
set well.pwtapi9; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi9; by pwt_id;
proc sort data=well.ogprod09api; by pwt_id;
data ogprod09; 
set well.ogprod09api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare9; merge pwtapi9(in=a) ogprod09(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare9; by apino;
data compare9A; 
set compare9; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare9B; 
set compare9A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare9A;
set compare9A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare9A; by pwt_id;
proc sort data=well.ogprod09api; by pwt_id;
data well.ogprod09_repind;
merge compare9A well.ogprod09api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod09_repind;
if apino=' '; run;

*******************************
2010
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi10; by apino;
data pwtapi10; 
set well.pwtapi10; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi10; by pwt_id;
proc sort data=well.ogprod10api; by pwt_id;
data ogprod10; 
set well.ogprod10api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare10; merge pwtapi10(in=a) ogprod10(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare10; by apino;
data compare10A; 
set compare10; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare10B; 
set compare10A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare10A;
set compare10A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare10A; by pwt_id;
proc sort data=well.ogprod10api; by pwt_id;
data well.ogprod10_repind;
merge compare10A well.ogprod10api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod10_repind;
if apino=' '; run;

*******************************
2011
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi11; by apino;
data pwtapi11; 
set well.pwtapi11; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi11; by pwt_id;
proc sort data=well.ogprod11api; by pwt_id;
data ogprod11; 
set well.ogprod11api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare11; merge pwtapi11(in=a) ogprod11(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare11; by apino;
data compare11A; 
set compare11; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare11B; 
set compare11A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare11A;
set compare11A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare11A; by pwt_id;
proc sort data=well.ogprod11api; by pwt_id;
data well.ogprod11_repind;
merge compare11A well.ogprod11api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod11_repind;
if apino=' '; run;

*******************************
2012
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi12; by apino;
data pwtapi12; 
set well.pwtapi12; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi12; by pwt_id;
proc sort data=well.ogprod12api; by pwt_id;
data ogprod12; 
set well.ogprod12api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare12; merge pwtapi12(in=a) ogprod12(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare12; by apino;
data compare12A; 
set compare12; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare12B; 
set compare12A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare12A;
set compare12A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare12A; by pwt_id;
proc sort data=well.ogprod12api; by pwt_id;
data well.ogprod12_repind;
merge compare12A well.ogprod12api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod12_repind;
if apino=' '; run;

*******************************
2013
*******************************;
/*subset key with only records that do not have a unique apino*/
proc sort data=well.pwtapi13; by apino;
data pwtapi13; 
set well.pwtapi13; 
by apino; 
if first.apino and last.apino then delete; run;

/*w/in monthly ds, subset unique pwt*/
proc sort data=pwtapi13; by pwt_id;
proc sort data=well.ogprod13api; by pwt_id;
data ogprod13; 
set well.ogprod13api (drop=apino); 
by pwt_id; 
if first.pwt_id; run;

/*only merge if there's a matching pwt from the non-unique apino ds*/
data compare13; merge pwtapi13(in=a) ogprod13(in=b); 
by pwt_id; if a and b;
run;

/*determine #of PWTs with rep API*/
proc sort data=compare13; by apino;
data compare13A; 
set compare13; 
by apino; 
if first.apino and last.apino then delete; run;

/*determine # of rep APIs*/
data compare13B; 
set compare13A; 
by apino; 
if first.apino; run;

/*create a indicator for obs with rep API*/
data compare13A;
set compare13A;
repAPI = 1; run;

/*merge back into prod dataset with the indicator*/
proc sort data=compare13A; by pwt_id;
proc sort data=well.ogprod13api; by pwt_id;
data well.ogprod13_repind;
merge compare13A well.ogprod13api; by pwt_id;
if repAPI = '.' then repAPI = 0;
run;

data test;
set well.ogprod13_repind;
if apino=' '; run;

*****************;
/*concatenate a DS with obs w/ rep apino's to cross check similarity*/
/*first add a year indicator*/
data compareA;
set compareA;
year=2001;
data compare2A;
set compare2A;
year=2002;
data compare3A;
set compare3A;
year=2003;
data compare4A;
set compare4A;
year=2004;
data compare5A;
set compare5A;
year=2005;
data compare6A;
set compare6A;
year=2006;
data compare7A;
set compare7A;
year=2007;
data compare8A;
set compare8A;
year=2008;
data compare9A;
set compare9A;
year=2009;
data compare10A;
set compare10A;
year=2010;
data compare11A;
set compare11A;
year=2011;
data compare12A;
set compare12A;
year=2012;
data compare13A;
set compare13A;
year=2013; 
run;
/*concatenate*/
data well.repapi01_13;
set compareA (keep=year pwt_id apino)
	compare2A (keep=year pwt_id apino)
	compare3A (keep=year pwt_id apino)
	compare4A (keep=year pwt_id apino) 
	compare5A (keep=year pwt_id apino) 
	compare6A (keep=year pwt_id apino)
	compare7A (keep=year pwt_id apino)
	compare8A (keep=year pwt_id apino)
	compare9A (keep=year pwt_id apino)
	compare10A (keep=year pwt_id apino)
	compare11A (keep=year pwt_id apino) 
	compare12A (keep=year pwt_id apino) 
	compare13A (keep=year pwt_id apino);
run;
/*cross check by pwt_id*/
proc freq data=repapi01_13 noprint;
table pwt_id / out=test; run;
data test2;
set test;
if count>1; run;
