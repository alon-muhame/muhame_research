*===============================================================
* Alon . M

* Purpose : To run descriptive stats; 

* Created By: Muhame Alon - Student Msc.QE - 2017/2018 Cohort

* Last Updated: 25TH.07.2020 @ 10:44pm; 
*===============================================================
*1.Preliminary commands

clear all //to close all open data sets, to empty the space of stata

capture log close //to force stata to do something, even if there is an error message

*stata has to close

set more off


*2. Loading the data
*================================================================
*  Use the cd -PATH {filepath} * 

cd "E:\Research Progress\data"

use "cleandataset.dta", replace

*3.creating macros
*================================================================
global ID ID //e.g id my regions this is representing the i(Origin-Uganda) component

global YEAR YEAR //this is the time component e.g t years

global ylist lnEmigij // this is the dependent variable e.g ylist emigrants from i(Ug) to j (dest)ctry

global xlist lnGdpi lnGdpj lnGdp_pci lnGdp_pcj lnGdp_pcj lnGAPij lnInflni lnInflnj lnPopi lnPopj lnReal_Interesti lnREERi lnREERj lnBil_Remitij lnBil_ExchRateij lnUnempli lnUnemplj /// 
lnDistij Colonyij Comlangij lndistw lndistwces EACij Euij COMESAij SADCij AMERICASij ASIA ROWij 

*4.Set data as panel data*
*===============================================================

describe $ID $Year $ylist $xlist

summarize $ID $Year $ylist $xlist

*But the above commands are not panel data specific therefore we have to set data as panel data * Data Management Under Panel Data*

xtdescribe

xtsum $ID $YEAR $ylist $xlist

xttab Comlangij

xttab lnEmigij

xttab EACij

xttab ASIA

xtdata $ylist $xlist 

xtline $ID $YEAR $ylist $xlist 

xtline $ID $YEAR $ylist, msymbol(+)

*Note: xt is special for panel data, e.g xttab command

xttrans Comlangij , freq //this command gives us the transition probabilities

xttrans Colonyij, freq //this command gives us the transition probabilities

xttrans col45, freq //this command gives us the transition probabilities

xttrans Curcolij, freq //this command gives us the transition probabilities

xttrans comcol, freq //this command gives us the transition probabilities

xttrans smctry, freq //this command gives us the transition probabilities


correlate lnEmigij L.lnEmigij L2.lnEmigij L3.lnEmigij L4.lnEmigij L5.lnEmigij L6.lnEmigij L7.lnEmigij

exit

* End * ===========================================================================================================


