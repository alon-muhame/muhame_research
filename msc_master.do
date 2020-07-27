** Alon Muhame June 2020
***************************************************************************************************************************

version 13.0 
clear 
cap log close
set trace off

cd "E:\Research Progress\do file"

*******************************************************************************
*** Dataset cleaning and dataset creation
*******************************************************************************
do data_cleaning_01     // Create and clean dataset for final use

do descriptive_stats   // Creates major descriptive stats on cleaned dataset and major variables of interest

do graphs_00           // Creates Graphs to visualize the dataset

do PanelData_Models_&_Tests  // Runs the Models and gives a bi picture of model selction and Test carried out 

do dofiles_combined_00      // Combines all the do files above and yields final Results(analysis) used in the resaerch report 





exit 

