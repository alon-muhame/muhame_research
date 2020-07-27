*===============================================================
* Do file Created on Sat:16.11.2019

* Purpose :  To Clean & Pre-Process data 

* Created By: Muhame Alon - Student Msc.QE - 2017/2018 Cohort

* Last Updated: 25TH.07.2020 @ 10:44pm; 
*===============================================================
*1.Preliminary commands

clear all //to close all open data sets, to empty the space of stata

capture log close //to force stata to do something, even if there is an error message

*stata has to close* However, this code is NOT neccessary for stata version higher than 10.0.0

set more off

*global pathin - "/Research Progress/data/FINAL PANEL DATASET-MA.dta/"

*2. Loading the data
*================================================================
* Use the cd option - to change working directory to where row data (uncleaned dataset) is stored *
 
cd "E:\Research Progress\data"

use "FINAL PANEL DATASET-MA.dta", replace

*Label Variables *

label variable Dest_Ctryj "Destination Country"

label variable Emigij "Emigrants From Origin to Destination"

label variable Gdpi "Gdp(Constant 2010 US Dollar)for Origin"

label variable Gdpj "Gdp(Constant 2010 US Dollar)for Destination"

label variable Gdp_pci "Gdp Percapita(constant 2010 US Dollar)for Origin"

label variable Gdp_pcj "Gdp Percapita(constant 2010 US Dollar)for Destination"

label variable GAPij "Relative Difference GDP_pcij" 
 
label variable Inflni "Inflation CPI for Origin"

label variable Inflnj "Inflation CPI for Destination"

label variable Popi "Population Total for Origin"

label variable Popj "Population Total for Destination"

label variable Real_Interesti "Real Interest Rate for Origin"

label variable REERi "Rear Effective Exchange Rate for Origin"

label variable REERj "Rear Effective Exchange Rate for Destination"

label variable Bil_Remitij "Bilateral Remittances ij"

label variable Bil_ExchRateij "Bilateral Exchange Rate ij"

label variable Unempli "Unemployment Rate working Age for Origin"

label variable Unemplj "Unemployment Rate working Age for Destination"

label variable contig "Contigration  Dummy"

label variable Colonyij "Origin is Colony of Destination"

label variable comlang_off "No Common Languange shared"

label variable Comlangij "Common Language Between Origin & Destination"

label variable comcol "Origin & Destination share Common Culture"

label variable Curcolij "Origin Current Colony of Destination"

label variable col45 "Origin was Colony of Destination Before 1945"

label variable smctry "Same Country "

label variable dist "Distance"

label variable Distij "Distance Between Capitals"

label variable distw "Distance Between Capitals Weighted"

label variable distwces "Distance Between Capitals Weighted Squared"

label variable EACij "EAC Dummy"

label variable Euij "EU Dummy"

label variable COMESAij "COMESA Dummy"

label variable SADCij "SADC Dummy"

label variable AMERICASij "AMERICAS Dummy"

label variable ASIA "ASIA Dummy"

label variable ROWij "ROW Dummy"

*Transform Variables Into Linearized Variables as Per Gravity Model stated(Natural Logarithms)

*Using the Looping command to generate the natural logs**

foreach var of varlist Emigij Gdpi Gdpj Gdp_pci Gdp_pcj GAPij Inflni Inflnj Popi Popj Real_Interesti REERi REERj Bil_Remitij Bil_ExchRateij Unempli Unemplj Distij distw distwces {
gen ln`var' = log(`var')
}
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

*Create Lags in selected Variables*

gen lnlaglnEmigij= L.lnEmigij

gen lnf1lnEmigij = F1.lnEmigij

gen lnlaglnReal_Interesti = L.lnReal_Interesti

gen lnlaglnInflni = L.lnInflni

gen lnf1Inflni = F1.Inflni

gen lnlaglnInflnj = L.lnInflnj

gen lnlaglnREERi = L.lnREERi

gen lnlaglnREERj = L.lnREERj


save cleandataset, replace // This code/command - saves the "cleandataset" in the working directory set at the beginning using - cd option above*

exit
