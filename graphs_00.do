*===============================================================
* Alon M
* Purpose : To create graphs for visual analysis; 

* Created By: Muhame Alon - Student Msc.QE - 2017/2018 Cohort

* Last Updated: 25TH.07.2020 @ 10:44pm; 
*===============================================================
*1.Preliminary commands

clear all //to close all open data sets, to empty the space of stata

capture log close //to force stata to do something, even if there is an error message stata has to close

set more off


*2. Loading the data
*================================================================
*  Use the cd -PATH * 

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
sort ID YEAR

xtset ID YEAR

*===============================================================

*5.Compare EAC with Other African Countries (SADC , COMESA etc ) countries using Box Plots*

gen reg_comp = 1 if Dest_Ctryj=="Kenya" | Dest_Ctryj=="Rwanda" | Dest_Ctryj=="Burundi" | Dest_Ctryj=="Tanzania" 

replace reg_comp = 0 if Dest_Ctryj=="Botswana" | Dest_Ctryj=="Cameroon" | Dest_Ctryj=="South Africa" | Dest_Ctryj=="Libya" | Dest_Ctryj=="Zimbabwe" 

graph box lnEmigij if reg_comp!=., over(Dest_Ctryj, sort(1)) horizontal nooutside

*6.Create a scatter of Marker Points of Interest & Scatter Plot*
gen mlab = Dest_Ctryj if Emigij>100

lab var mlab "Marker Labels (Emigrants>100)"

*7.Graph Matrix of Uganda's emigrants GDP, GDP per capita, etc.*

graph matrix lnGdpi lnGdp_pci lnGdpj lnGdp_pcj lnGAPij, msymbol(+) half

scatter lnGdpj lnEmigij || lfit lnGdpj lnEmigij, legend(off) xscale(alt) ylabel(, angle(horizontal)) msize(*2) 

graph save "sc1.gph", replace

scatter lnGAPij lnEmigij || lfit lnGAPij lnEmigij, legend(off) xscale(alt) ylabel(, angle(horizontal)) msize(*2)

graph save "sc2.gph", replace

scatter lnGdp_pcj lnEmigij || lfit lnGdp_pcj lnEmigij, legend(off) xscale(alt) ylabel(, angle(horizontal)) msize(*2)

graph save "sc3.gph", replace

*8.Graph Combined - plain version *First Cut*

graph combine "sc1.gph" "sc2.gph" "sc3.gph" 

* Graph Combine with , option(s) specification*

graph combine "sc1.gph" "sc2.gph" "sc3.gph", holes(2 3 6)

*9. Create a scatter of Marker Points of Interest & Scatter Plot*/

gen mlab = Dest_Ctryj if Emigij>100

lab var mlab "Marker Labels (Emigrants>100)"

*10. Relationship Between GDP and Emigrants" 

scatter lnGdpj lnEmigij ///   
if YEAR ==2017 & Dest_Ctry!= "Kenya" & Dest_Ctry!= "Rwanda" & Dest_Ctry!= "Burundi", mlabel(mlab) msize(*2) title("Emigratory Rate of Ugandans in Relation to GDP per capita(PPP), 2017") ylabel( , angle(horizontal)) ///
note("Excludes Kenya, Rwanda & Burundi " " Emigrants>100 " " Source: Own elaboration based on data from WDI & UBOS")scheme(vg samec)
graph save "sc1.gph", replace
 
 scatter lnGAPij lnEmigij ///
if YEAR ==2017 & Dest_Ctry!= "Kenya" & Dest_Ctry!= "Rwanda" & Dest_Ctry!= "Burundi", mlabel(mlab) msize(*2) title("Emigratory Rate of Uganda in Relation to GDP per capita(PPP), 2000")ylabel( , angle(horizontal)) ///
 note("Excludes Kenya, Rwanda & Burundi " " Emigrants>100 " " Source: Own elaboration based on data from WDI & UBOS")scheme(vg samec)
graph save "sc2.gph", replace
 
 scatter lnGdp_pcj lnEmigij ///
if YEAR ==2017 & Dest_Ctry!= "Kenya" & Dest_Ctry!= "Rwanda" & Dest_Ctry!= "Burundi", mlabel(mlab) msize(*2) title("Emigratory Rate of Uganda in Relation to GDP per capita(PPP), 2017")ylabel( , angle(horizontal)) ///
 note("Excludes Kenya, Rwanda & Burundi " " Emigrants>100 " " Source: Own elaboration based on data from WDI & UBOS")scheme(vg samec)
graph save "sc3.gph", replace

* Graph Combined - plain version *

graph combine "sc1.gph" "sc2.gph" "sc3.gph" 

* Second Version with , options specification*

graph combine "sc1.gph" "sc2.gph" "sc3.gph", holes(2 3 6)

gen mlab2 = Dest_Ctryj 

lab var mlab "Marker Labels (Emigrants)"

 
scatter lnGAPij lnEmigij ///
if YEAR ==2017, mlabel(mlab2) title("Emigratory Rate of Uganda in Relation to GDP per capita(PPP)")ylabel( , angle(horizontal)) ///
 note(" " " Emigratory Rate " " Source: Own elaboration based on data from WDI & UBOS")scheme(vg samec)
 
 twoway((scatter lnGAPij lnEmigij)(qfit lnGAPij lnEmigij)) ///
 title("Emigratory Rate of Uganda in Relation to GDP per capita(PPP)")ylabel( , angle(horizontal)) ///
 note(" " " Emigratory Rate " " Source: Own elaboration based on data from WDI & UBOS")scheme(vg samec)
 
 twoway dot lnGAPij lnEmigij


exit

* The End*=========================================================================================================================
