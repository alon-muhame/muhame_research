** Alon Muhame,  June 2020
***************************************************************************************************************************
* Msc.QE RESEARCH DATA ANALSYSIS MASTER Do file
***************************************************************************************************************************

version 13.0 
clear 
cap log close
set trace off

*******************************Directory***********************************************************************************
do "E:\Research Progress\Directory.do"

*******************************clean***************************************************************************************
do "$dofile\data_cleaning_01.do" //Creates file that lists variable names abd variable labels. 


*******************************Analysis***************************************************************************************
do "$dofile\dofiles_combined_00.do"  // All analysis is put together from data pre-processing to final model/tables presented in the report*



*******************************Paneldata Models***************************************************************************************
do "$dofile\PanelData_Models_&_Tests.do" // Paneldata Models are presented here with Test conducted explictly* This do file is mearnt to be a stand alone file


*******************************Graphs***************************************************************************************
do "$dofile\graphs_00.do" // Creates graphs to give visuals decriptive look

do "$dofile\descriptive_stats.do" // Summary stats on number of variables with significance


exit 

* "Note that do files can be run directory from master if all is ok'
