use "panel_webinar_stata.dta", clear

list country year consumption gdp irate ///
        if CountryName=="Mexico" |      ///
        CountryName=="United States",   ///
        sepby(country) abbreviate(12) noobs 
		
preserve
collapse (mean)	consumption gdp irate, by(country)	
list country consumption gdp irate ///
        if country == 128 | country == 207, ///
		abbreviate(12) noobs
restore
		
preserve
keep if CountryName == "Japan" | ///
        CountryName == "United States"  | ///
		CountryName == "France" | ///
		CountryName == "Brazil"
xtline consumption gdp, byopts(note("") ///
    title("Consumption and GDP across the period 2010-2018" " ", size(4)) ///
    caption(" " "{bf:Source}: http://databank.worldbank.org/data/Home.aspx" ///
	"{bf:Stata command}: xtline", size(3))) xlabel(,angle(45)) ///
	ylabel(0(5000)15000,angle(45)) legend(size(small)) name(xtline,replace)	
graph export xtline.png, replace	
restore		
		
		
label var year "Year"
graph matrix consumption gdp irate, half ///
   title("Consumption, GDP, and Interest rate" ///
   "Scatter plots across the period 2010-2018" " ", size(4)) ///
   caption("{bf:Source}: http://databank.worldbank.org/data/Home.aspx" ///
   "{bf:Stata command}: graph matrix", size(3)) ///
   maxes(xlabel(,angle(45)) ylabel(,angle(45))) name(graphm1,replace)
graph export graphm1.png, replace

preserve
keep if CountryName == "Mexico" | ///
        CountryName == "China"  | ///
		CountryName == "France" | ///
		CountryName == "United States"
graph matrix consumption gdp irate, half ///
 maxes(xlabel(,labsize(2.5) angle(65)) ylabel(, labsize(2.5))) ///
 by(country, note("") ///
 title("Consumption, GDP, and Interest rate"  ///
 "Scatter plots across the period 2010-2018"" ", size(4)) ///
 caption("{bf:Source}: http://databank.worldbank.org/data/Home.aspx" ///
 "{bf:Stata command}: graph matrix ", size(3))) name(graphm2,replace) ///
 diagopts(size(2.3))
    
graph export graphm2.png, replace
restore

//random effects
xtset country year
describe
xtreg ln_cons ln_gdp ln_irate, re
xttest0
xtreg ln_cons ln_gdp ln_irate, fe

//fe vs re
quietly xtreg ln_cons ln_gdp ln_irate, re
estimates store eq_fe
quietly xtreg ln_cons ln_gdp ln_irate, fe
estimates store eq_re
hausman eq_fe eq_re

//mundlak test
local explain ln_gdp ln_irate
local explainm ln_gdpm ln_iratem
foreach var of local explain {
	by country: egen double `var'm = mean(`var')
}
xtreg ln_cons `explain' `explainm', re
test `explainm'

//marginal effects
quietly xtreg ln_cons ln_gdp ln_irate, fe
margins, dydx(*)

quietly xtreg ln_cons ln_gdp i.region#c.ln_gdp ln_irate, fe
margins, dydx(ln_gdp) over(region)
marginsplot
graph export margins1.png, replace

quietly xtreg ln_cons ln_gdp i.region##c.ln_irate, re
margins region, at(ln_irate=(-4(2)0))
marginsplot, noci
graph export margins2.png, replace

//dynamic panel
xtabond ln_cons ln_gdp ln_irate, twostep
estat sargan
estat abond

xtdpdsys ln_cons ln_gdp ln_irate, twostep
estat sargan
estat abond

//extended regression
webuse womenhlthre, clear
xtset personid year
generate goodhlth = health>3 if !missing(health)
label var goodhlth "Good-Excellent Health condition"
describe

//random effects probit with sample selection
xteprobit goodhlth i.exercise grade, select(select = grade i.regcheck)
xteprobit goodhlth i.exercise grade, entreat(insured = i.workschool, nore) nolog








