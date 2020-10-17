program define simulate1, rclass 
clear
set obs 1000
gen e1 = rnormal()
gen x1 = runiform()
gen x2 = runiform() + 1*e1
gen y = 1+ 1*x1 +1*x2 +e1
regress y x1 x2 
end 
simulate1 
simulate, reps(500): simulate1


program define simulate2, rclass 
clear
set obs 1000
gen e1 = rnormal()
gen x1 = runiform()
gen x2 = runiform() + 1*e1
gen y = 1+ 1*x1 +1*x2 +e1
regress y x1 x2 
end 
simulate2 
simulate, reps(500): simulate2
 su
