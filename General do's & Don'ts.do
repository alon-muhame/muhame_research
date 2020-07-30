** Alon Muhame June 2020**
***************************************************************************************************************************

version 13.0 
clear 
cap log close
set trace off


*******************************************************************************************************************************************
*** General  Do's & Don'ts from My own perspective in undertaking any data analysis project's in using statistical anaysis software [STATA]
**********************************************************************************************************************************************
* This section is just a review of what i have learned over time carrying out projects in statistical software analysis packages. 
**This Repo focuses on STATA , but be sure to look out my other repos on SPSS, PYTHON, SQL for Relational Databases, R, Tableau, & Eviews**. 

*I always start any project by carrying out the following and it involves the follwoing sub-sections before i head on to do tests and validation of 
*study Methodology and visualisation of the dataset outcomes and finally writing the report *** 
* PART A: DATA ASSESSMENT 
*(a) DATA ASSESSMENT *
*(b) DATA CLEANING *
*(c) MERGING DATASETS*
*(d) CONSTRUCTING NEW VARIABLES*
*(e) DATA ANALYSIS*
*PART B: VALIDATING EVALUATION DESIGN OR STUDY DESIGN 
*PART C: CONSTRUCTING KEY INDIVIDUAL AND HOUSEHOLD OUTPUTS AND OUTCOMES

**Professional Tip 1**- NEVER MODIFY THE ORIGINAL DATASETs. 
/*Make sure you don't risk altering the original data, by saving the dataset under a new name, or 
in a different directory. Before starting analysis, create a "data" folder, with atleast the following subfolders: "original', "clean","temp" or "tempoarary".
When opening an original dataset from the "original" folder, NEVER save it back to the same location, but in the "clean" or "temp" subfolders. 
By doing this , You will be safe not to run under risk of losing your data{'original'} in case something went wrong !! when you had not finished the analysis */

**Professional Tip 2** - TRY AS MUCH AS POSSIBLE TO WORK IN STATA do files. 
/*Stata do file offer  two main advantages;
(1) replicating your results or other analysts and developers 
(2) improving the efficiency for future analysis and more insights during the projects life cycle.
[1] A very important element of data analysis is being to replicate results. And since most of Survey variables  or IMPACT EVALUATION variables required for 
analysis necessitate construction across multiple variables in the original databases, a STATA do file serves as the dictionary for how variables are 
constructed , as well as how difference in say means tests are specified and exported 
[2] Do files also allow you to work more efficiently. STATA codes developed for say baseline data analysis will be useful as a basis to develop codes for 
analysis of follow-up and endline surveys, since variable names should be the same across survey rounds. For example the definition of indicators on do-files 
can be reused at endline to calculate the value of those indicators at endline */

** Professional Tip 3** - DEFINE a DIRECTORY do-file ** eg. "Directory"
/* A directory do-file uses macros to define the path to the "data", "do-files", "logfiles" and "results" folders or directories.  When you run the directory do-files,
STATA defines a macro for each these directories. In the do-files that run subsquently to the directory do-file, every time STATA needs to access these folders, 
you can use these macros instead of having to write out file paths, which can save a lot of time. 
In addition , if you wish to run the same analysis on another computer where file paths may be different, you only need to modify the directories do file, 
and NOT all of your do-files

** Professional TIp 4** - DEFINE a MASTER do-file** e.g "msc_master"
/* The MASTER do-file indicates in which order do-files should run, and briefly decscribes each do-file. The master do-file is the first point of entry for anyone who wants
an overview of data analysis, Data analysts will find tha a master do-fle helps them to do the analysis more easily after breaks in the analysis */


** Professional Tip 5** - LABEL DATASETS with one word** eg. "cleandataset" or "evaluation" or "finaldataset"..
/* In STATA, using quotes is sometimes cumbersome, and can create difficulties with the name in a macro. If the name of your dataset is not one word, 
you will have to use quotes every time you refer to the dataset, and you may experience difficulties assigning macros. 
To avoid this issue, just rename your original dataset and name any new datasets in one word, using underscorre as a seperation if needed e.g clean_evalution

** Professional Tip 6** - Identify critical variables in your datasets. Prior to data analysis, you should be able to correctly identify the key variables in the datasets:
. Study arm: confirm the appropriate variable for defining asignment to treatment group (or groups) and comparision group. 
. Unit of assignement: Following the sampling plan, the cluster unit should be clearly identified in the documentation and data.
. Weights : Following the sampling plan, you may need to weight the data for it to be representative of the target population. If weights don't exist already, 
you may have to create weights your self. During sampling, amapping of the households present in geographic entity , or number of districts, sectors etc. per geographic entity, 
must have been created. Refer to the documentation to calculate weights appropriately. 
. Unique identifers (IDs): Spot household and individual unique identifiers . They are usually the key variables allowing you to merge the different sections 
of the datasets together. 
When defined correctly - and this is something to check absolutely, they uniquely identify an individual or a household. 

** Professional Tip 7** - UNDERSTAND the Level of your datasets. 
/* Many and various Impact Evaluations surveys or studies or projects can feature information 
on individuals , household members, households, facilities e.g health facilities, Health workers,sectors e.g |Urban or Rural, Poor and Non-Poor sectors etc. among others.
An example of how to check such a dataset like Impact evaluation survey which divides the household say in Two sectors; In this case, the sector level includes one 
observation for each sector, a household -level dataset has one observation for each houshold, and an individual level dataset has one observaton for each participant 
in the survey (or each respondent in a given section of the questionaire). Some datasets from the household survey are evn defined at sub-individual , 
EG;. 
Let's Consider THREE kinds of datasets for illustration purposes; 
(1) A HouseHold   Level Dataset . This dataset is at household level : and has one observation corresponding to one household.
(2) A Livestock/Animals Dataset . This dataset is at livestock level: and for each household , there may be many animals and of different kinds such 
 



exit 

