use heart, clear
summarize

*cca
logit attack smokes age bmi hsgrad female, or nolog

*set up
mi set wide

mi register imputed bmi
mi register regular attack smokes age hsgrad female

*imputation
mi impute regress bmi attack smokes age hsgrad female, add(20) rseed(298127)

mi estimate, or: logit attack smokes age bmi hsgrad female

list bmi _1_bmi _2_bmi _3_bmi _4_bmi _5_bmi if _n<6

use heart2_miset, clear
mi describe

mi impute chained (regress) bmi (logit) smokes = attack age hsgrad female, ///
add(20) rseed(298127)

*analysis/pooling
mi estimate, or: logit attack smokes age bmi hsgrad female

mi estimate, vartable nocitable

mi estimate, mcerror noheader: logit attack smokes age bmi hsgrad female

*postestimation
mi estimate (diff:_b[smokes]-_b[bmi]), nocoef: ///
logit attack smokes age bmi hsgrad female

mi test age hsgrad female

*import
import delimited heart_mi_unset, clear
mi import flong, m(imp) id(id) imputed(bmi) clear

*data management
mi passive: egen overweight = cut(bmi), at(0,25,40) icodes
list bmi overweight _mi_m if id==4



