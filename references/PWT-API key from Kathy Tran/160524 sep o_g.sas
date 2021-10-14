*****************************************
* 	5/24/26
*   Separating O/G
*	Add lat/long
*	Sum O/G if coming from multi pools
*   Keep active/inactive in one dataset
****************************************;

libname well 'C:\Users\ktran_000\Desktop\research\frackingproj\rmf-desktop-backup\data\sasdat';
proc contents data=num1 varnum; run;
/*sep o/g 2013*/
data num1 (drop=gas_btu);
set well.ogprod13_actstat;
gasprod=gas_btu+0; run;
proc freq data=well.ogprod13_actstat;
table oil gas; run;
data oil13;
set num1;
if oil=1; run;
proc univariate data=oil13;
var oilprod; run;
data gas13;
set num1;
if gas=1; 
proc univariate data=gas13;
var gasprod; run;

proc contents data=well.latlong_allwells151204 varnum; run;
proc contents data=well.og_latlong01_13 varnum; run;
/*create indicator for oil/gas to later separate into 2 datasets*/
/*gas*/
data gtest;
set well.og_latlong01_13;
array gind1(12) gas01_1-gas01_12;
array gind2(12) gas02_1-gas02_12;
array gind3(12) gas03_1-gas03_12;
array gind4(12) gas04_1-gas04_12;
array gind5(12) gas05_1-gas05_12;
array gind6(12) gas06_1-gas06_12;
array gind7(12) gas07_1-gas07_12;
array gind8(12) gas08_1-gas08_12;
array gind9(12) gas09_1-gas09_12;
array gind10(12) gas10_1-gas10_12;
array gind11(12) gas11_1-gas11_12;
array gind12(12) gas12_1-gas12_12;
array gind13(12) gas13_1-gas13_12;
	do i = 1 to 12;
		if gind1[i]=1 OR gind2[i]=1 OR gind3[i]=1 OR gind4[i]=1 OR gind5[i]=1 OR gind6[i]=1 OR gind7[i]=1 OR gind8[i]=1 
		   OR gind9[i]=1 OR gind10[i]=1 OR gind11[i]=1 OR gind12[i]=1 OR gind13[i]=1 then gas0113=1;
	else gas0113=0;
	end;
drop i;
run; 
/*oil*/
data otest;
set gtest;
array oind1(12) oil01_1-oil01_12;
array oind2(12) oil02_1-oil02_12;
array oind3(12) oil03_1-oil03_12;
array oind4(12) oil04_1-oil04_12;
array oind5(12) oil05_1-oil05_12;
array oind6(12) oil06_1-oil06_12;
array oind7(12) oil07_1-oil07_12;
array oind8(12) oil08_1-oil08_12;
array oind9(12) oil09_1-oil09_12;
array oind10(12) oil10_1-oil10_12;
array oind11(12) oil11_1-oil11_12;
array oind12(12) oil12_1-oil12_12;
array oind13(12) oil13_1-oil13_12;
	do i = 1 to 12;
		if oind1[i]=1 OR oind2[i]=1 OR oind3[i]=1 OR oind4[i]=1 OR oind5[i]=1 OR oind6[i]=1 OR oind7[i]=1 OR oind8[i]=1 
		   OR oind9[i]=1 OR oind10[i]=1 OR oind11[i]=1 OR oind12[i]=1 OR oind13[i]=1 then oil0113=1;
	else oil0113=0;
	end;
drop i;
run; 
proc freq data=otest;
table gas0113*oil0113;
run;

/*id wells w/ prod that need to be summed*/
PROC IMPORT OUT= WELL.prod2013_rawapi
            DATAFILE= "C:\Users\ktran_000\Desktop\research\frackingproj\rmf-desktop-backup\data\monthlyprod\2013prod_api.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
/*row 234009 had an entry error in the API, changed from 053-2233 to 5322330 based on system entry date*/

proc contents data=poolds varnum; run;
/*merge to raw well data table by pwt_id*/
data poolds;
set well.prod2013_rawapi (keep= apino pwt_id poolcode WellTypeCode PoolWellTypeStatus PoolName);
run;

proc sort data=otest;
by pwt_id;
proc sort data=poolds;
by pwt_id;
data mer1;
merge otest (in=a) poolds (in=b);
by pwt_id;
a_indp = a;
b_indp = b;
run;
data test2;
set mer1;
if a_ind=0 AND b_ind=1 then delete; run;
/*drop obs from pool dataset w/o lat/long and prod data, n=192451*/
data test;
set test2;
if latitude = '.' then delete; run;
/*drop obs w/o lat/long and prod data, n=25, and obs w/ prod but not lat/long, n=5*/

/*perm ds: wide with pool and well type code in order to id where to sum by api*/
data well.ogwide_pool;
set test (drop= aind bind a_ind b_ind); run;

/*sep to oil/gas datasets - active only*/
data oil1;
set well.ogwide_pool;
if oil0113=1; run;
/*n= 72468*/
data gas1;
set well.ogwide_pool;
if gas0113=1; run;
/*n=42500*/

/*id rep API and sum if diff pools but same well*/
*****************************************
/*subset for rep api - oil*/
****************************************;
proc contents data=oil1 varnum; run;
proc sort data=oil1;
by apino;
data oil2;
set oil1 (drop= repapi);
by apino; 
if first.apino and last.apino then delete; run;
proc sort data=oil2;
by apino; run;
proc freq data=oil2;
table welltypecode; run;
data test;
set oil2;
if welltypecode NE "OG"; run;
/*find the unique apino's that repeat*/
data oil_unqapi; 
set oil2; 
by apino; 
if first.apino; run;

/*sum by year - 2001*/
proc means data=oil2 noprint;
class apino;
var oprod01_1-oprod01_12;
output out=oilsum1 sum(oprod01_1-oprod01_12)=sumopr01_1 - sumopr01_12;
run;
data osum01;
set oilsum1 (drop=_type_ _freq_);
if apino='.' then delete; run;
/*merge w/ orig ds*/
proc sort data=oil_unqapi;
by apino;
proc sort data=osum01;
by apino;
data mer1;
merge oil_unqapi osum01;
by apino; run;
/*master sum ds that will cont to add to w/ years 2002-2013*/
data replace1 (drop=sumopr01_1 - sumopr01_12);
set mer1;
oprod01_1=sumopr01_1;
oprod01_2=sumopr01_2;
oprod01_3=sumopr01_3;
oprod01_4=sumopr01_4;
oprod01_5=sumopr01_5;
oprod01_6=sumopr01_6;
oprod01_7=sumopr01_7;
oprod01_8=sumopr01_8;
oprod01_9=sumopr01_9;
oprod01_10=sumopr01_10;
oprod01_11=sumopr01_11;
oprod01_12=sumopr01_12;
run;
/*2002*/
proc means data=oil2 noprint;
class apino;
var oprod02_1-oprod02_12;
output out=oilsum2 sum(oprod02_1-oprod02_12)=sumopr02_1 - sumopr02_12;
run;
/*subset sums that actually have repeated apino's*/
data osum02;
set oilsum2 (drop=_type_ _freq_);
if apino='.' then delete; run;
/*merge the sums to previous ds*/
data mer2;
merge replace1 osum02;
by apino; run;
/*master sum ds that will cont to add to w/ years 2002-2013*/
data replace2 (drop=sumopr02_1 - sumopr02_12);
set mer2;
oprod02_1=sumopr02_1;
oprod02_2=sumopr02_2;
oprod02_3=sumopr02_3;
oprod02_4=sumopr02_4;
oprod02_5=sumopr02_5;
oprod02_6=sumopr02_6;
oprod02_7=sumopr02_7;
oprod02_8=sumopr02_8;
oprod02_9=sumopr02_9;
oprod02_10=sumopr02_10;
oprod02_11=sumopr02_11;
oprod02_12=sumopr02_12;
run;
/*2003*/
proc means data=oil2 noprint;
class apino;
var oprod03_1-oprod03_12;
output out=oilsum3 sum(oprod03_1-oprod03_12)=sumopr03_1 - sumopr03_12;
run;
/*subset sums that actually have repeated apino's*/
data osum03;
set oilsum3 (drop=_type_ _freq_);
if apino='.' then delete;
proc sort data=osum03;
by apino;
data mer3;
merge replace2 osum03;
by apino; run;
/*master sum ds that will cont to add to w/ years 2003-2013*/
data replace3 (drop=sumopr03_1 - sumopr03_12);
set mer3;
oprod03_1=sumopr03_1;
oprod03_2=sumopr03_2;
oprod03_3=sumopr03_3;
oprod03_4=sumopr03_4;
oprod03_5=sumopr03_5;
oprod03_6=sumopr03_6;
oprod03_7=sumopr03_7;
oprod03_8=sumopr03_8;
oprod03_9=sumopr03_9;
oprod03_10=sumopr03_10;
oprod03_11=sumopr03_11;
oprod03_12=sumopr03_12;
run;
/*2004*/
proc means data=oil2 noprint;
class apino;
var oprod04_1-oprod04_12;
output out=oilsum4 sum(oprod04_1-oprod04_12)=sumopr04_1 - sumopr04_12;
run;
/*subset sums that actually have repeated apino's*/
data osum04;
set oilsum4 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum04;
by apino;
data mer4;
merge replace3 osum04;
by apino; run;
/*master sum ds that will cont to add to w/ years 2004-2013*/
data replace4 (drop=sumopr04_1 - sumopr04_12);
set mer4;
oprod04_1=sumopr04_1;
oprod04_2=sumopr04_2;
oprod04_3=sumopr04_3;
oprod04_4=sumopr04_4;
oprod04_5=sumopr04_5;
oprod04_6=sumopr04_6;
oprod04_7=sumopr04_7;
oprod04_8=sumopr04_8;
oprod04_9=sumopr04_9;
oprod04_10=sumopr04_10;
oprod04_11=sumopr04_11;
oprod04_12=sumopr04_12;
run;
/*2005*/
proc means data=oil2 noprint;
class apino;
var oprod05_1-oprod05_12;
output out=oilsum5 sum(oprod05_1-oprod05_12)=sumopr05_1 - sumopr05_12;
run;
/*subset sums that actually have repeated apino's*/
data osum05;
set oilsum5 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum05;
by apino;
data mer5;
merge replace4 osum05;
by apino; run;
/*master sum ds that will cont to add to w/ years 2005-2013*/
data replace5 (drop=sumopr05_1 - sumopr05_12);
set mer5;
oprod05_1=sumopr05_1;
oprod05_2=sumopr05_2;
oprod05_3=sumopr05_3;
oprod05_4=sumopr05_4;
oprod05_5=sumopr05_5;
oprod05_6=sumopr05_6;
oprod05_7=sumopr05_7;
oprod05_8=sumopr05_8;
oprod05_9=sumopr05_9;
oprod05_10=sumopr05_10;
oprod05_11=sumopr05_11;
oprod05_12=sumopr05_12;
run;
/*2006*/
proc means data=oil2 noprint;
class apino;
var oprod06_1-oprod06_12;
output out=oilsum6 sum(oprod06_1-oprod06_12)=sumopr06_1 - sumopr06_12;
run;
/*subset sums that actually have repeated apino's*/
data osum06;
set oilsum6 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum06;
by apino;
data mer6;
merge replace5 osum06;
by apino; run;
/*master sum ds that will cont to add to w/ years 2006-2013*/
data replace6 (drop=sumopr06_1 - sumopr06_12);
set mer6;
oprod06_1=sumopr06_1;
oprod06_2=sumopr06_2;
oprod06_3=sumopr06_3;
oprod06_4=sumopr06_4;
oprod06_5=sumopr06_5;
oprod06_6=sumopr06_6;
oprod06_7=sumopr06_7;
oprod06_8=sumopr06_8;
oprod06_9=sumopr06_9;
oprod06_10=sumopr06_10;
oprod06_11=sumopr06_11;
oprod06_12=sumopr06_12;
run;
/*2007*/
proc means data=oil2 noprint;
class apino;
var oprod07_1-oprod07_12;
output out=oilsum7 sum(oprod07_1-oprod07_12)=sumopr07_1 - sumopr07_12;
run;
/*subset sums that actually have repeated apino's*/
data osum07;
set oilsum7 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum07;
by apino;
data mer7;
merge replace6 osum07;
by apino; run;
/*master sum ds that will cont to add to w/ years 2007-2013*/
data replace7 (drop=sumopr07_1 - sumopr07_12);
set mer7;
oprod07_1=sumopr07_1;
oprod07_2=sumopr07_2;
oprod07_3=sumopr07_3;
oprod07_4=sumopr07_4;
oprod07_5=sumopr07_5;
oprod07_6=sumopr07_6;
oprod07_7=sumopr07_7;
oprod07_8=sumopr07_8;
oprod07_9=sumopr07_9;
oprod07_10=sumopr07_10;
oprod07_11=sumopr07_11;
oprod07_12=sumopr07_12;
run;
/*2008*/
proc means data=oil2 noprint;
class apino;
var oprod08_1-oprod08_12;
output out=oilsum8 sum(oprod08_1-oprod08_12)=sumopr08_1 - sumopr08_12;
run;
/*subset sums that actually have repeated apino's*/
data osum08;
set oilsum8 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum08;
by apino;
data mer8;
merge replace7 osum08;
by apino; run;
/*master sum ds that will cont to add to w/ years 2008-2013*/
data replace8 (drop=sumopr08_1 - sumopr08_12);
set mer8;
oprod08_1=sumopr08_1;
oprod08_2=sumopr08_2;
oprod08_3=sumopr08_3;
oprod08_4=sumopr08_4;
oprod08_5=sumopr08_5;
oprod08_6=sumopr08_6;
oprod08_7=sumopr08_7;
oprod08_8=sumopr08_8;
oprod08_9=sumopr08_9;
oprod08_10=sumopr08_10;
oprod08_11=sumopr08_11;
oprod08_12=sumopr08_12;
run;
/*2009*/
proc means data=oil2 noprint;
class apino;
var oprod09_1-oprod09_12;
output out=oilsum9 sum(oprod09_1-oprod09_12)=sumopr09_1 - sumopr09_12;
run;
/*subset sums that actually have repeated apino's*/
data osum09;
set oilsum9 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum09;
by apino;
data mer9;
merge replace8 osum09;
by apino; run;
/*master sum ds that will cont to add to w/ years 2009-2013*/
data replace9 (drop=sumopr09_1 - sumopr09_12);
set mer9;
oprod09_1=sumopr09_1;
oprod09_2=sumopr09_2;
oprod09_3=sumopr09_3;
oprod09_4=sumopr09_4;
oprod09_5=sumopr09_5;
oprod09_6=sumopr09_6;
oprod09_7=sumopr09_7;
oprod09_8=sumopr09_8;
oprod09_9=sumopr09_9;
oprod09_10=sumopr09_10;
oprod09_11=sumopr09_11;
oprod09_12=sumopr09_12;
run;
/*2010*/
proc means data=oil2 noprint;
class apino;
var oprod10_1-oprod10_12;
output out=oilsum10 sum(oprod10_1-oprod10_12)=sumopr10_1 - sumopr10_12;
run;
/*subset sums that actually have repeated apino's*/
data osum10;
set oilsum10 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum10;
by apino;
data mer10;
merge replace9 osum10;
by apino; run;
/*master sum ds that will cont to add to w/ years 2010-2013*/
data replace10 (drop=sumopr10_1 - sumopr10_12);
set mer10;
oprod10_1=sumopr10_1;
oprod10_2=sumopr10_2;
oprod10_3=sumopr10_3;
oprod10_4=sumopr10_4;
oprod10_5=sumopr10_5;
oprod10_6=sumopr10_6;
oprod10_7=sumopr10_7;
oprod10_8=sumopr10_8;
oprod10_9=sumopr10_9;
oprod10_10=sumopr10_10;
oprod10_11=sumopr10_11;
oprod10_12=sumopr10_12;
run;
/*2011*/
proc means data=oil2 noprint;
class apino;
var oprod11_1-oprod11_12;
output out=oilsum11 sum(oprod11_1-oprod11_12)=sumopr11_1 - sumopr11_12;
run;
/*subset sums that actually have repeated apino's*/
data osum11;
set oilsum11 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum11;
by apino;
data mer11;
merge replace10 osum11;
by apino; run;
/*master sum ds that will cont to add to w/ years 2011-2013*/
data replace11 (drop=sumopr11_1 - sumopr11_12);
set mer11;
oprod11_1=sumopr11_1;
oprod11_2=sumopr11_2;
oprod11_3=sumopr11_3;
oprod11_4=sumopr11_4;
oprod11_5=sumopr11_5;
oprod11_6=sumopr11_6;
oprod11_7=sumopr11_7;
oprod11_8=sumopr11_8;
oprod11_9=sumopr11_9;
oprod11_10=sumopr11_10;
oprod11_11=sumopr11_11;
oprod11_12=sumopr11_12;
run;
/*2012*/
proc means data=oil2 noprint;
class apino;
var oprod12_1-oprod12_12;
output out=oilsum12 sum(oprod12_1-oprod12_12)=sumopr12_1 - sumopr12_12;
run;
/*subset sums that actually have repeated apino's*/
data osum12;
set oilsum12 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum12;
by apino;
data mer12;
merge replace11 osum12;
by apino; run;
/*master sum ds that will cont to add to w/ years 2012-2013*/
data replace12 (drop=sumopr12_1 - sumopr12_12);
set mer12;
oprod12_1=sumopr12_1;
oprod12_2=sumopr12_2;
oprod12_3=sumopr12_3;
oprod12_4=sumopr12_4;
oprod12_5=sumopr12_5;
oprod12_6=sumopr12_6;
oprod12_7=sumopr12_7;
oprod12_8=sumopr12_8;
oprod12_9=sumopr12_9;
oprod12_10=sumopr12_10;
oprod12_11=sumopr12_11;
oprod12_12=sumopr12_12;
run;
/*2013*/
proc means data=oil2 noprint;
class apino;
var oprod13_1-oprod13_12;
output out=oilsum13 sum(oprod13_1-oprod13_12)=sumopr13_1 - sumopr13_12;
run;
/*subset sums that actually have repeated apino's*/
data osum13;
set oilsum13 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=osum13;
by apino;
data mer13;
merge replace12 osum13;
by apino; run;
/*master sum ds that will cont to add to w/ years 2013-2013*/
data replace13 (drop=sumopr13_1 - sumopr13_12);
set mer13;
oprod13_1=sumopr13_1;
oprod13_2=sumopr13_2;
oprod13_3=sumopr13_3;
oprod13_4=sumopr13_4;
oprod13_5=sumopr13_5;
oprod13_6=sumopr13_6;
oprod13_7=sumopr13_7;
oprod13_8=sumopr13_8;
oprod13_9=sumopr13_9;
oprod13_10=sumopr13_10;
oprod13_11=sumopr13_11;
oprod13_12=sumopr13_12;
run;
/*combine with oil1 ds and create permanent ds*/
data well.oilpr_sum0113;
set replace13; run;

data oil3;
set oil1 (drop= repapi);
by apino; 
if first.apino and last.apino; run;
/*concatenate*/
data well.alloilpr_sum0113;
set oil3 (drop=poolcode welltypecode) well.oilpr_sum0113 (drop=poolcode welltypecode);
proc sort data=well.alloilpr_sum0113;
by apino; run;


*****************************************
/*subset for rep api - gas*/
****************************************;
proc sort data=gas1;
by apino;
data gas2;
set gas1 (drop= repapi);
by apino; 
if first.apino and last.apino then delete; run;
proc sort data=gas2;
by apino; run;
proc freq data=gas2;
table welltypecode; run;
data test;
set gas2;
if welltypecode NE "OG"; run;
/*find the unique apino's that repeat*/
data gas_unqapi; 
set gas2; 
by apino; 
if first.apino; run;

/*sum by year - 2001*/
proc means data=gas2 noprint;
class apino;
var gprod01_1-gprod01_12;
output out=gassum1 sum(gprod01_1-gprod01_12)=sumgpr01_1 - sumgpr01_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum01;
set gassum1 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum01;
by apino;
data mer1;
merge gas_unqapi gsum01;
by apino; run;
/*master sum ds that will cont to add to w/ years 2002-2013*/
data rep1 (drop=sumgpr01_1 - sumgpr01_12);
set mer1;
gprod01_1=sumgpr01_1;
gprod01_2=sumgpr01_2;
gprod01_3=sumgpr01_3;
gprod01_4=sumgpr01_4;
gprod01_5=sumgpr01_5;
gprod01_6=sumgpr01_6;
gprod01_7=sumgpr01_7;
gprod01_8=sumgpr01_8;
gprod01_9=sumgpr01_9;
gprod01_10=sumgpr01_10;
gprod01_11=sumgpr01_11;
gprod01_12=sumgpr01_12;
run;
/*2002*/
proc means data=gas2 noprint;
class apino;
var gprod02_1-gprod02_12;
output out=gassum2 sum(gprod02_1-gprod02_12)=sumgpr02_1 - sumgpr02_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum02;
set gassum2 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum02;
by apino;
data mer2;
merge rep1 gsum02;
by apino; run;
/*master sum ds that will cont to add to w/ years 2002-2013*/
data rep2 (drop=sumgpr02_1 - sumgpr02_12);
set mer2;
gprod02_1=sumgpr02_1;
gprod02_2=sumgpr02_2;
gprod02_3=sumgpr02_3;
gprod02_4=sumgpr02_4;
gprod02_5=sumgpr02_5;
gprod02_6=sumgpr02_6;
gprod02_7=sumgpr02_7;
gprod02_8=sumgpr02_8;
gprod02_9=sumgpr02_9;
gprod02_10=sumgpr02_10;
gprod02_11=sumgpr02_11;
gprod02_12=sumgpr02_12;
run;
/*2003*/
proc means data=gas2 noprint;
class apino;
var gprod03_1-gprod03_12;
output out=gassum3 sum(gprod03_1-gprod03_12)=sumgpr03_1 - sumgpr03_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum03;
set gassum3 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum03;
by apino;
data mer3;
merge rep2 gsum03;
by apino; run;
/*master sum ds that will cont to add to w/ years 2003-2013*/
data rep3 (drop=sumgpr03_1 - sumgpr03_12);
set mer3;
gprod03_1=sumgpr03_1;
gprod03_2=sumgpr03_2;
gprod03_3=sumgpr03_3;
gprod03_4=sumgpr03_4;
gprod03_5=sumgpr03_5;
gprod03_6=sumgpr03_6;
gprod03_7=sumgpr03_7;
gprod03_8=sumgpr03_8;
gprod03_9=sumgpr03_9;
gprod03_10=sumgpr03_10;
gprod03_11=sumgpr03_11;
gprod03_12=sumgpr03_12;
run;
/*2004*/
proc means data=gas2 noprint;
class apino;
var gprod04_1-gprod04_12;
output out=gassum4 sum(gprod04_1-gprod04_12)=sumgpr04_1 - sumgpr04_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum04;
set gassum4 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum04;
by apino;
data mer4;
merge rep3 gsum04;
by apino; run;
/*master sum ds that will cont to add to w/ years 2004-2013*/
data rep4 (drop=sumgpr04_1 - sumgpr04_12);
set mer4;
gprod04_1=sumgpr04_1;
gprod04_2=sumgpr04_2;
gprod04_3=sumgpr04_3;
gprod04_4=sumgpr04_4;
gprod04_5=sumgpr04_5;
gprod04_6=sumgpr04_6;
gprod04_7=sumgpr04_7;
gprod04_8=sumgpr04_8;
gprod04_9=sumgpr04_9;
gprod04_10=sumgpr04_10;
gprod04_11=sumgpr04_11;
gprod04_12=sumgpr04_12;
run;
/*2005*/
proc means data=gas2 noprint;
class apino;
var gprod05_1-gprod05_12;
output out=gassum5 sum(gprod05_1-gprod05_12)=sumgpr05_1 - sumgpr05_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum05;
set gassum5 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum05;
by apino;
data mer5;
merge rep4 gsum05;
by apino; run;
/*master sum ds that will cont to add to w/ years 2005-2013*/
data rep5 (drop=sumgpr05_1 - sumgpr05_12);
set mer5;
gprod05_1=sumgpr05_1;
gprod05_2=sumgpr05_2;
gprod05_3=sumgpr05_3;
gprod05_4=sumgpr05_4;
gprod05_5=sumgpr05_5;
gprod05_6=sumgpr05_6;
gprod05_7=sumgpr05_7;
gprod05_8=sumgpr05_8;
gprod05_9=sumgpr05_9;
gprod05_10=sumgpr05_10;
gprod05_11=sumgpr05_11;
gprod05_12=sumgpr05_12;
run;
/*2006*/
proc means data=gas2 noprint;
class apino;
var gprod06_1-gprod06_12;
output out=gassum6 sum(gprod06_1-gprod06_12)=sumgpr06_1 - sumgpr06_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum06;
set gassum6 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum06;
by apino;
data mer6;
merge rep5 gsum06;
by apino; run;
/*master sum ds that will cont to add to w/ years 2006-2013*/
data rep6 (drop=sumgpr06_1 - sumgpr06_12);
set mer6;
gprod06_1=sumgpr06_1;
gprod06_2=sumgpr06_2;
gprod06_3=sumgpr06_3;
gprod06_4=sumgpr06_4;
gprod06_5=sumgpr06_5;
gprod06_6=sumgpr06_6;
gprod06_7=sumgpr06_7;
gprod06_8=sumgpr06_8;
gprod06_9=sumgpr06_9;
gprod06_10=sumgpr06_10;
gprod06_11=sumgpr06_11;
gprod06_12=sumgpr06_12;
run;
/*2007*/
proc means data=gas2 noprint;
class apino;
var gprod07_1-gprod07_12;
output out=gassum7 sum(gprod07_1-gprod07_12)=sumgpr07_1 - sumgpr07_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum07;
set gassum7 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum07;
by apino;
data mer7;
merge rep6 gsum07;
by apino; run;
/*master sum ds that will cont to add to w/ years 2007-2013*/
data rep7 (drop=sumgpr07_1 - sumgpr07_12);
set mer7;
gprod07_1=sumgpr07_1;
gprod07_2=sumgpr07_2;
gprod07_3=sumgpr07_3;
gprod07_4=sumgpr07_4;
gprod07_5=sumgpr07_5;
gprod07_6=sumgpr07_6;
gprod07_7=sumgpr07_7;
gprod07_8=sumgpr07_8;
gprod07_9=sumgpr07_9;
gprod07_10=sumgpr07_10;
gprod07_11=sumgpr07_11;
gprod07_12=sumgpr07_12;
run;
/*2008*/
proc means data=gas2 noprint;
class apino;
var gprod08_1-gprod08_12;
output out=gassum8 sum(gprod08_1-gprod08_12)=sumgpr08_1 - sumgpr08_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum08;
set gassum8 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum08;
by apino;
data mer8;
merge rep7 gsum08;
by apino; run;
/*master sum ds that will cont to add to w/ years 2008-2013*/
data rep8 (drop=sumgpr08_1 - sumgpr08_12);
set mer8;
gprod08_1=sumgpr08_1;
gprod08_2=sumgpr08_2;
gprod08_3=sumgpr08_3;
gprod08_4=sumgpr08_4;
gprod08_5=sumgpr08_5;
gprod08_6=sumgpr08_6;
gprod08_7=sumgpr08_7;
gprod08_8=sumgpr08_8;
gprod08_9=sumgpr08_9;
gprod08_10=sumgpr08_10;
gprod08_11=sumgpr08_11;
gprod08_12=sumgpr08_12;
run;
/*2009*/
proc means data=gas2 noprint;
class apino;
var gprod09_1-gprod09_12;
output out=gassum9 sum(gprod09_1-gprod09_12)=sumgpr09_1 - sumgpr09_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum09;
set gassum9 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum09;
by apino;
data mer9;
merge rep8 gsum09;
by apino; run;
/*master sum ds that will cont to add to w/ years 2009-2013*/
data rep9 (drop=sumgpr09_1 - sumgpr09_12);
set mer9;
gprod09_1=sumgpr09_1;
gprod09_2=sumgpr09_2;
gprod09_3=sumgpr09_3;
gprod09_4=sumgpr09_4;
gprod09_5=sumgpr09_5;
gprod09_6=sumgpr09_6;
gprod09_7=sumgpr09_7;
gprod09_8=sumgpr09_8;
gprod09_9=sumgpr09_9;
gprod09_10=sumgpr09_10;
gprod09_11=sumgpr09_11;
gprod09_12=sumgpr09_12;
run;
/*2010*/
proc means data=gas2 noprint;
class apino;
var gprod10_1-gprod10_12;
output out=gassum10 sum(gprod10_1-gprod10_12)=sumgpr10_1 - sumgpr10_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum10;
set gassum10 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum10;
by apino;
data mer10;
merge rep9 gsum10;
by apino; run;
/*master sum ds that will cont to add to w/ years 2010-2013*/
data rep10 (drop=sumgpr10_1 - sumgpr10_12);
set mer10;
gprod10_1=sumgpr10_1;
gprod10_2=sumgpr10_2;
gprod10_3=sumgpr10_3;
gprod10_4=sumgpr10_4;
gprod10_5=sumgpr10_5;
gprod10_6=sumgpr10_6;
gprod10_7=sumgpr10_7;
gprod10_8=sumgpr10_8;
gprod10_9=sumgpr10_9;
gprod10_10=sumgpr10_10;
gprod10_11=sumgpr10_11;
gprod10_12=sumgpr10_12;
run;
/*2011*/
proc means data=gas2 noprint;
class apino;
var gprod11_1-gprod11_12;
output out=gassum11 sum(gprod11_1-gprod11_12)=sumgpr11_1 - sumgpr11_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum11;
set gassum11 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum11;
by apino;
data mer11;
merge rep10 gsum11;
by apino; run;
/*master sum ds that will cont to add to w/ years 2011-2013*/
data rep11 (drop=sumgpr11_1 - sumgpr11_12);
set mer11;
gprod11_1=sumgpr11_1;
gprod11_2=sumgpr11_2;
gprod11_3=sumgpr11_3;
gprod11_4=sumgpr11_4;
gprod11_5=sumgpr11_5;
gprod11_6=sumgpr11_6;
gprod11_7=sumgpr11_7;
gprod11_8=sumgpr11_8;
gprod11_9=sumgpr11_9;
gprod11_10=sumgpr11_10;
gprod11_11=sumgpr11_11;
gprod11_12=sumgpr11_12;
run;
/*2012*/
proc means data=gas2 noprint;
class apino;
var gprod12_1-gprod12_12;
output out=gassum12 sum(gprod12_1-gprod12_12)=sumgpr12_1 - sumgpr12_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum12;
set gassum12 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum12;
by apino;
data mer12;
merge rep11 gsum12;
by apino; run;
/*master sum ds that will cont to add to w/ years 2012-2013*/
data rep12 (drop=sumgpr12_1 - sumgpr12_12);
set mer12;
gprod12_1=sumgpr12_1;
gprod12_2=sumgpr12_2;
gprod12_3=sumgpr12_3;
gprod12_4=sumgpr12_4;
gprod12_5=sumgpr12_5;
gprod12_6=sumgpr12_6;
gprod12_7=sumgpr12_7;
gprod12_8=sumgpr12_8;
gprod12_9=sumgpr12_9;
gprod12_10=sumgpr12_10;
gprod12_11=sumgpr12_11;
gprod12_12=sumgpr12_12;
run;
/*2013*/
proc means data=gas2 noprint;
class apino;
var gprod13_1-gprod13_12;
output out=gassum13 sum(gprod13_1-gprod13_12)=sumgpr13_1 - sumgpr13_12;
run;
/*subset sums that actually have repeated apino's*/
data gsum13;
set gassum13 (drop=_type_ _freq_);
if apino='.' then delete;
/*merge the sums to the orig but only w/ rep api's*/
proc sort data=gsum13;
by apino;
data mer13;
merge rep12 gsum13;
by apino; run;
/*master sum ds that will cont to add to w/ years 2013-2013*/
data rep13 (drop=sumgpr13_1 - sumgpr13_12);
set mer13;
gprod13_1=sumgpr13_1;
gprod13_2=sumgpr13_2;
gprod13_3=sumgpr13_3;
gprod13_4=sumgpr13_4;
gprod13_5=sumgpr13_5;
gprod13_6=sumgpr13_6;
gprod13_7=sumgpr13_7;
gprod13_8=sumgpr13_8;
gprod13_9=sumgpr13_9;
gprod13_10=sumgpr13_10;
gprod13_11=sumgpr13_11;
gprod13_12=sumgpr13_12;
run;
/*combine with oil1 ds and create permanent ds*/
data well.gaspr_sum0113;
set rep13; run;

data gas3;
set gas1 (drop= repapi);
by apino; 
if first.apino and last.apino; run;
/*concatenate*/
data well.allgaspr_sum0113;
set gas3 (drop=poolcode welltypecode) well.gaspr_sum0113 (drop=poolcode welltypecode);
proc sort data=well.allgaspr_sum0113;
by apino; run;


