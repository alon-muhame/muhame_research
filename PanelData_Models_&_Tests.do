*===============================================================
* Alon M
* Purpose : To create graphs for visual analysis; 
* Created By: Muhame Alon - Student Msc.QE - 2017/2018 Cohort
* Last Updated: 25TH.07.2020 @ 10:44pm; 
*===============================================================
*1.Preliminary commands

clear all //to close all open data sets, to empty the space of stata//

capture log close //to force stata to do something, even if there is an error message// 

//stata has to close//
set more off


*2. Loading the data
*================================================================
*  Use the cd -PATH * 
cd "E:\Research Progress\data"

use "cleandataset.dta", replace

*3.creating macros
*================================================================
global ID ID //e.g id my regions this is representing the i(Origin-Uganda) component//

global YEAR YEAR //this is the time component e.g t years//

global ylist lnEmigij // this is the dependent variable e.g ylist emigrants from i(Ug) to j (dest)ctry//

global xlist lnGdpi lnGdpj lnGdp_pci lnGdp_pcj lnGdp_pcj lnGAPij lnInflni lnInflnj lnPopi lnPopj lnReal_Interesti lnREERi lnREERj lnBil_Remitij lnBil_ExchRateij lnUnempli lnUnemplj /// 
lnDistij Colonyij Comlangij lndistw lndistwces EACij Euij COMESAij SADCij AMERICASij ASIA ROWij 

*4.Set data as panel data*
*===============================================================
sort ID YEAR
xtset ID YEAR

*===============================================================

*===============================================================
 *STATIC PANEL DATA MODELS/MODEL ESTIMATES
 
*===============================================================
*PART I* 

*Pooled OLS estimator* [ALL RUN ON LOG-LINEARIZED VARIABLES] *// If individual effect ui (cross-sectional or time specific effect) does not exist (ui =0), 
///Ordinary least squares (OLS) produces efficient and consistent parameter estimates * (Adhering to asumptions of; 1. Linearity, 2. Exogeneity, 3. no autocorrelation &,
///No Homoskedasticity 5. Full Rank or no multicollinearity )
reg  $ylist $xlist

test EACij Euij COMESAij SADCij AMERICASij ASIA ROWij Colonyij Comlangij
 
reg  $ylist $xlist, noheader vce(cluster ID)

reg  $ylist $xlist, noheader vce(cluster ID) nocon

*1.Population avearged estimator
xtreg $ylist $xlist, pa

*2.Between estimator
xtreg $ylist $xlist, be 

*3.Fixed effects or within estimator
global ylist lnEmigij // this is the dependent variable e.g ylist emigrants from i(Ug) to j (dest)ctry//

global xlist lnGdpi lnGdpj lnGdp_pci lnGdp_pcj lnGAPij lnInflni lnInflnj lnPopi lnPopj lnReal_Interesti lnREERi lnREERj lnBil_Remitij lnBil_ExchRateij lnUnempli lnUnemplj /// 
lnDistij lndistw lndistwces  

xtreg $ylist $xlist, fe i(YEAR)

estimates store FE_i_Year

xtreg $ylist $xlist, fe i(ID)

estimates store FE_i_ID

xtreg $ylist $xlist, fe vce(robust)

estimates store FE_robust

estout FE_i_Year FE_i_ID FE_robust, cells(b(star fmt(3)) se(par fmt(3))) legend label varlabels(_cons constant) stats(r2 df_r) 

*4.Fixed effects or random effects linear models with AR(1) disturbance estimator
xtset ID YEAR

xtregar $ylist $xlist

estimates store M_ar

*5.First difference estimator //D. is Delta first difference the constant disappears, so to tell stata that u dont want to include a constant u put no constant//
qui xtregar $ylist $xlist

outreg2 using "E:\Research Progress\results\D.Estimates.doc", replace dec(3) ctitle("First Difference Estimators1")

qui reg D.($ylist $xlist), noconstant

outreg2 using "E:\Research Progress\results\D.Estimates.doc", append dec(3) ctitle("First Difference Estimators2")

qui reg D.($ylist $xlist), vce(cluster ID) nocon

outreg2 using "E:\Research Progress\results\D.Estimates.doc", append dec(3) ctitle("First Difference Estimators3")

estimates store M2

estout M_ar M2, cells(b(star fmt(3)) se(par fmt(3))) legend label varlabels(_cons constant) stats(r2 df_r) 

*6.Random effects estimator*Comparison Estimators
xtreg $ylist $xlist, re theta 

estimates store RE_theta

qui xtreg $ylist $xlist, re vce(robust) theta 

estimates store RE_thetar

qui xtreg $ylist $xlist, re vce(robust)

estimates store RE_robust

qui xtreg $ylist lnlaglnEmigij $xlist, re vce(robust)

estimates store RE_Dynamic

estout RE_theta RE_thetar RE_robust RE_Dynamic, cells(b(star fmt(3)) se(par fmt(3))) legend label varlabels(_cons constant) stats(r2 df_r)
 
/*Outreg2 Command:*/ 
*7.Random effects estimator*Comparison Estimators
global ylist lnEmigij // This is the dependent variable e.g ylist emigrants from i(Ug) to j (dest)ctry//

global xlist lnGdpi lnGdpj lnGdp_pci lnGdp_pcj lnGdp_pcj lnGAPij lnInflni lnInflnj lnPopi lnPopj lnReal_Interesti lnREERi lnREERj lnBil_Remitij lnBil_ExchRateij lnUnempli lnUnemplj /// 
lnDistij Colonyij Comlangij EACij Euij COMESAij SADCij AMERICASij ASIA ROWij 

qui xtreg $ylist $xlist, re theta

outreg2 using "E:\Research Progress\results\RE_Estimates.doc", replace dec(3) ctitle(RE)

**/Models Presented in th Results & Discussed**/
xtreg $ylist $xlist, re vce(robust) 

outreg2 using "E:\Research Progress\results\RE_Estimates.doc", append dec(3) ctitle(RE_robust) 

xtreg $ylist lnlaglnEmigij lnf1lnEmigij $xlist, re vce(robust)

outreg2 using "E:\Research Progress\results\RE_Estimates.doc", append dec(3) ctitle(RE_Dynamic) 

 *Estimator Comparison*
///Compare various estimators (with cluster-robust se's)///
quietly regress $ylist $xlist, vce(cluster ID)

estimates store OLS

quietly xtreg $ylist $xlist, fe vce(robust)

estimates store FE

quietly xtreg $ylist $xlist, re vce(robust)

estimates store RE

quietly xtreg $ylist $xlist, be

estimates store BE

estimates table OLS BE RE FE, b(%7.4f) se stats(N)

estout OLS FE RE BE, cells(b(star fmt(3)) se(par fmt(3))) legend label varlabels(_cons constant) stats(r2 df_r) 

*Prediction , Contrast btn OLS & RE in-sample fitted values**(Cameroon & Trivedi - Microeconometric Analysis using Stata)*
quietly regress $ylist $xlist , vce(cluster ID)

predict xbols, xb

quietly xtreg $ylist $xlist, re

predict xbre, xb

predict xbure, xbu

summarize $ylist xbols xbre xbure 

correlate $ylist xbols xbre xbure

*PART II* Deciding Final Models* Using Hausman Test*

*Hausman test for fixed versus random effects model
quietly xtreg $ylist $xlist, fe //Within Regression

estimates store fixed

quietly xtreg $ylist $xlist, re //FGLS estimation

estimates store random

hausman fixed random 

hausman fixed random, sigmamore //The Test fails To Reject the Null Hypothesis of No fixed-Effects at 5% & 10% Respectively and Conclude that the Model is *Random-Effects* 

*Insatll - ssc install xtoverid and proceed as follows*

*Run the RE model and then use the xtoverid command after that*

*The interpretation is the same as with hausman, i.e. a significant test statistic rejects the null hypothesis that RE is consistent**

*Hausman test for fixed versus random effects model- Wooldridge(2002), Method of Bootsrap***

*Boastrap of Hausman test OR Use Wooldridge (2002) version of hausman test***- to check consistent of hausman test*

**Robust Hausman test using method of Wooldridge (2002)**
quietly xtreg $ylist $xlist, re

scalar lambda_hat = 1 - sqrt(e(sigma_e)^2/(e(g_avg)*e(sigma_u)^2+e(sigma_e)^2))

gen in_sample = e(sample)

sort ID YEAR

set trace on 

foreach var in $ylist $xlist {
	by ID:egen "`var’_bar" = mean(`var’) if in_sample
	gen "`var’_re" = `var’ - lambda_hat*"`var’_bar" if in_sample  
	gen "`var’_fe" = `var’ - "`var’_bar" if in_sample     
}     
set trace off   
* Cameroon & Truvedi Method of Hausman Test * Robust*
  
                                         
*Wooldridge’s auxiliary regression for the panel-robust Hausman test:

quietly reg $ylist $xlist, if in_sample, cluster(ID) //(output omitted )

* Test of the null-hypothesis ‘‘gamma==0’’

test $ylist $xlist

**Install ssc xtoverid - User written command to excute the bootstrap command of Hausman test**

*sc instal xtoverid*

*Run the command after estimating , xtreg, re vce(cluster id) as in the bootstrap above***

**Proceedure**
*Run the RE model and then use the xtoverid command after that. The interpretation is the same as with hausman

*I.e. a significant test statistic rejects the null hypothesis that RE is consistent.

quietly xtreg $ylist $xlist, re

*How to apply this command*

xtoverid 

*OR Using small sample swammy & Aurorra estimator of variance *

xtreg $ylist $xlist, re sa

estimates store random 

*On the Other hand* 
* The Problem: hausman command gives incorrect statistic as it assumes *** RE estimator is fully effecient, usually not the case;

*To correct this problem : Solution: do a panel bootstrap of the Hausman test OR  Use the Wooldridge (2002) robust version of Hausman test

hausman fixed random, sigmamore  // with the difference variance-covariance [ The results are the same- We fail to reject the Null Hypothesis]

*Breusch-Pagan LaGrange Multiplier (LM) Tests - RE REGRESSION OR SIMPLE REGRESSION(OLS)* Since The We failed to Reject Null Hypotheis*

quietly xtreg $ylist $xlist, re

xttest0 //if the P-value is significant it implies that the individual effects are important from a random perspective//

*Testing for Heteroskedasticity in fixed panels

xtgls $ylist $xlist, igls panels(heteroskedastic) // Model Failed to Converge

xtgls $ylist $xlist, panels(heteroskedastic) igls

estimates store hetero

xtgls $ylist $xlist, igls 

estimates store homosk

local df = e(N_g)-1

lrtest hetero homosk, df(35) //The Result obtained is inconclusive and thus needs to investigate more the test====== StataCorp 

xtgls $ylist $xlist, force panels(heteroskedastic) corr(independent)

estimates store hetero

xtgls $ylist $xlist, igls 

estimates store homosk

local df = e(N_g)-1

lrtest hetero homosk, df(35) //The Result obtained is inconclusive and thus needs to investigate more the test====== StataCorp 

*Testing for Heteroskedasticity USING *xttest2, *xttest3 after xtreg &xtgls Commands

xtgls $ylist $xlist, p(h)

xttest3 

xttest2

xtreg $ylist $xlist, fe

xtreg $ylist $xlist if ID!=35-48, fe

xttest3

xttest2

*The Results indicate that : The null hypotheses of each test are decisively rejected. The errors exhibit both Groupwise heteroskedasticity and contemporaneous correlation, whether fit by fixed-effects OR by feasible GLS (FGLS) estimators.

*Testing for Serial Correlation in fixed panels

xtserial $ylist $xlist, output

xtserial $ylist $xlist, nooutput //The Test Fails to Reject the Null Hypothesis of no-serial corrleation in panels***Conclude there is serial correlation among panels as p-value (0.8560)

*Panel data models using GLS(*Groupwise Homo or Heteroskedasticity)
xtgls $ylist $xlist

xtgls $ylist $xlist, panels(heteroskedastic) corr(independent) //Best suites the Data Well

xtgls $ylist $xlist, panels(heteroskedastic) corr(independent)igls // Model is better BUT Presents Convergencee Issues

*Panel data models using GLS(*Cross - section weights) =====Parks/Kmenta(1967), Model  

xtgls $ylist $xlist, panels(correlated) corr(independent)

xtgls $ylist $xlist, panels(correlated) corr(ar1) force

xtgls $ylist $xlist, panels(heteroskedastic) corr(independent) // Model suites data Also

*Panel data models with (Panel -corrected standard errors) =====Beck & Kats(1995), Model 

xtpcse $ylist $xlist, correlation(psar1) rhotype(freg) np1 nmk // Since T<N , Model can't be estimated (as the Error variance- covariance matrix can't be inverted)

xtpcse $ylist $xlist, c(psar1) // Since T<N , Model can't be estimated (as the Error variance- covariance matrix can't be inverted)

xtpcse lnGdp_pci lnEmigij lnGAPij lnInflni lnInflnj lnPopi lnPopj lnDistij , c(psar1) // Model is well estimated and all highly siginficant

xtpcse lnEmigij lnlaglnEmigij lnGdp_pcj lnGdp_pci, correlation(psar1) rhotype(freg) np1 nmk

xtpcse lnEmigij lnlaglnEmigij lnGdp_pcj lnGdp_pci lnDistij, correlation(psar1) rhotype(freg) np1 nmk

quietly xtreg $ylist $xlist, fe

xttest0 //if the P-value is significant it implies that the individual effects are important from a fixed effects perspective


*Unit Root Tests ADF - UNIT ROOT FOR HETEROGENEITY *

tsset ID YEAR

xtunitroot llc lnEmigij

xtunitroot llc lnEmigij lnGdpi lnGdpj 

xtunitroot llc lnEmigij, lags(0) 

**Im Pearson shin Test***    
 
xtunitroot ips lnlaglnEmigij, lags(0) 
     
xtunitroot ips lnInflni, lags(0)  
     
xtunitroot ips D.lnInflni, lags(1)   
    
xtunitroot ips lnInflni, lags(0) 
      
xtunitroot ips lnInflni, lags(0)  
     
xtunitroot ips lnInflni, lags(0) 
      
xtunitroot ips lnInflni, lags(0) 
      
xtunitroot ips lnInflni, lags(0) 
      
xtunitroot ips lnInflni, lags(0) 
      
xtunitroot ips lnInflni, lags(0) 
      
xtunitroot ips lnInflni, lags(0)
       
xtunitroot ips lnInflni, lags(0) 
      
xtunitroot ips lnInflni, lags(0) 
      
xtunitroot ips lnInflni, lags(0) 

pescadf lnInflni, lags(2) 

 
xtunitroot hadri lnEmigij, lags(0)

*User - Written Command * ssc instal levinlin*  user written command indicates  that there are lags and thus no need for cointegration test

*User - Written Command * ssc instal ipshin* user written command

*Panel Co-Integration Tests - TIME SERIES USED IN THE STUDY

*User - Written Command * ssc instal xtcointtest*

xtcointtest $ylist $xlist


*REGRESSION RESULTS FOR OBJECTIVES* (APPENDIX A:Regresssion Results) - Using Outreg2 to Output Results*


* OBJECTIVE 1** Relationship between GDP per capita and emigration from Uganda*

xtpcse lnGdp_pci lnEmigij lnInflni lnInflnj lnDistij, correlation(psar1) rhotype(freg) np1 nmk nocon

xtpcse lnGdp_pci lnEmigij lnGdp_pcj lnInflni lnInflnj, correlation(psar1) rhotype(freg) np1 nmk nocon

* OBJECTIVE 2** Effects of Exchange Rate on the propensity to emigrate from Uganda*

xtpcse lnREERj lnEmigij lnGAPij lnREERi , correlation(psar1) rhotype(freg) np1 nmk 

* OBJECTIVE 3** Relationship between inflation rate and emigration*

xtpcse lnInflni lnEmigij lnlaglnInflni lnInflnj lnGAPij, correlation(psar1) rhotype(freg) np1 nmk nocons

* OBJECTIVE 4** Effects of Real Interest rates on emigration*

xtpcse lnReal_Interesti lnEmigij lnGdpi lnGdpj, correlation(psar1) rhotype(freg) np1 nmk nocon


*===============================================================
 *DYNAMIC PANEL DATA MODELS/MODEL ESTIMATES
 
*===============================================================
*** Linear dynamic panel models with individual e¤ects***

*********ARELLANO-BOND ESTIMATOR/SYSTEM GMM - MODEL ESTIMATES*********

*2SLS or /// Linear Dynamic panel- data models include p-lags of the dependent variables as covariates and conatin 

*Unobserved panel -level effects , fixed or random *By construction , the unobserved panel - level effects are correlated with lagged dependent-variables making standard error estimates inconsistent

*To aviate the problem - I used the Arellano-Bond (1991) Derived GMM Method to estimate the Linear Dynamic Panel -Models (** xtbond command - implements). This command is designed for data with many panels and few periods  ** Strong Requirement is the Bein there NO AUTO CORRELATION in the idiosyncratic errors)
* (xtdpdsys command - also doesnot allow NO AUTO CORRELATION in the idiosyncratic errors)
* (xtdpd command - also doesnot allow NO AUTO CORRELATION in the idiosyncratic errors)

*Transform Variables Into Lagged Variables to faciliate stated( Dynamic -xtpce coomand)*** First Difference to remove unobserved heterogeneity** (not mean difference) Include this the above write up in summary assumptions in the final Report write up on - Linear dynamic panel models****

*Optimal or two-step GMM for a dynamic panel model*

xtabond lnEmigij,lags(2) vce(robust)twostep

* Test whether error is serially correlated*
estat abond

xtabond lnEmigij lnGdp_pci lnGdp_pcj  lnInflni lnInflnj, nocons

estat sargan 

* Test whether error is serially correlated

estat abond
 

*More Complicated Dynamic Panel data Models*
 
*Install ssc xtpdp - command from stata website*

xtdpd lnEmigij,lag(2) vce(robust) pre(lnGdp_pci) 

* Arellano/Bover or Blundell/Bond for a dynamic panel model*

xtdpdsys lnEmigij,lags(2) vce(robust) nocons

xtdpdsys lnEmigij lnGdp_pci lnGdp_pcj  lnInflni lnInflnj

********HAUSMAN-TAYLOR ESTIMATOR - for error components models or swammy model************



log close

exit

****************************** THE END!!! ************************
 



