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

* (a): DATA ASSESSMENT *

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
When defined correctly - and this is something to check absolutely, they uniquely identify an individual or a household*/ 

** Professional Tip 7** - UNDERSTAND the Level of your datasets. 
/* Many and various Impact Evaluations surveys or studies or projects can feature information 
on individuals , household members, households, facilities e.g health facilities, Health workers,sectors e.g |Urban or Rural, Poor and Non-Poor sectors etc. among others.
An example of how to check such a dataset like Impact evaluation survey which divides the household say in Two sectors; In this case, the sector level includes one 
observation for each sector, a household -level dataset has one observation for each houshold, and an individual level dataset has one observaton for each participant 
in the survey (or each respondent in a given section of the questionaire). Some datasets from the household survey are evn defined at sub-individual , 
EG;. 
Let's Consider THREE kinds of datasets for illustration purposes; 
(1) A HouseHold   Level Dataset . This dataset is at household level : and has one observation corresponding to one household.
(2) A Livestock/Animals Dataset . This dataset is at livestock level: and for each household , there may be many animals and of different kinds in a HH such;
i.e., The household may own (Cattle, Goat, Sheep, etc.). One thus needs to create new variables and reformat them to the level of household-level 
to be able to mergge these datasets;
(3) An Individual Level Dataset . This dataset is at the individual-level: for each say woman, the dataset contains one row per say pregnancy that took place since January 2008. 
Depending on the number of pregnancies that a woman had, the number of rows per woman thus may varry dependingly */ 

** Professional Tip 8** - INVESTIGATE when something looks wrong. THIS is a greatest step in data analysis and assessment.
/* Review the data for any immediate anomalies before initiating data construction or analysis. 
Carefully review key variables, such as unique identifiers, key administrative level variables or study arm variables, for any missing or repeated values.
The survey team and the survey firm report or whoever collected data may be able to jsutify any missing data, however, you should also correct repeated 
observation prior to data anslysis*/

* (b): DATA CLEANING *

/* The greatest note here is that data cleaning takes the greatest part or time of any project involving data analysis and and surveys data. 
So, be sure to do your best in terms of the following;

(1). Make sure that unique identifiers are Unique
Reference is made to Chapter 6 of the RBF for Health Impact Evaluation Toolkit[ By Elisa, Jenipher ], They explain how the IE team and survey firm 
can uniquely identify observations within the dataset(s) using geo-codes as well as RBF specific unique identification codes. 
Once the dataset(s) is (are) produced, it is your turn to confirm whether each observation is uniquely identified. In STATA, the commands 
duplicates report or duplicates tag report whether there are any ID duplicates in the dataset. 

(2). Check and correct the range of variables
You will need to systematically check the range of all variables, and correct out-of-range values. Where values cannot be corrected, 
you should reassign out-of-range values to missing values. STATA provides not only standard missing values represented by a dot in STATA, 
but also missing values represented by a dot followed by a letter (.a, .b. …, .z).
These letters can replace out-of-range values if you wish to distinguish which observations were originally missing and which ones were out of range. 
If you do so, please remember that a non-missing value will be different from a dot missing value and different from a letter missing value, 
therefore it will be “<.” but not only “!=.”(see help missing in STATA for more details).
For example ; Using tab1 command ins STATA or assert . These are helpful in checking the out of range variables;(see help stata files for these commands) 


(3).Confirm skips between questions are respected.(if there any) 
It happens that during the interview, enumerators forget to skip some questions if the respondent answered in a specific way to the previous question. 
Again assert is a useful command to make sure skips are respected:
You can assert a variable that should have been skipped in certain conditions is indeed missing under these conditions

(4). Confirm respondents' answers are logical with respect to the previous answers
A good way to check data quality is to cross-check answers with one another when a logical link exists between questions. 
You can use the assert command for that. You can also cross-tabulate two variables in order to check respondents” answers are consistent, 
for example using tabulate (twoway)*/

*(c) MERGING DATASETS*

*(1). Identify which variable(s) should be used as the merging variable to merge datasets;
Sometimes, it may not be obvious what variable(s) should be used to merge two or more datasets. 
Be sure you identify whether you need to merge on one or more variables. 
For example, if you want to merge two individual-level datasets, you will need to merge based on complete individual unique identifiers*/.

*(2). Decide whether the merge command should be used with the unique, uniqusing or uniqmaster option;
/*In a merge, the “master” dataset is the dataset currently open in STATA. The “using” dataset is the dataset you will merge with the dataset currently open. 
You may merge one master dataset with one or several using datasets. The option uniqmaster indicates the variables used to merge datasets uniquely identify observations in the master dataset only. 
The option uniqusing indicates the variables used to merge datasets uniquely identify observations in the using dataset only. 
The unique option indicates merging variables uniquely identify observations in both the master and the using datasets;
You should use the default merge command when merging individual-level data to individual-level data or household-level data to household-level data. 
The default merge command is equivalent to the merge command with the unique option. 
The default merge command, without uniqusing or uniqmaster options, won’t work if your merging variable(s) is (are) not uniquely identified in all the, 
datasets that are merged. You may use the duplicates report or duplicates tag commands prior to merging to identify any duplicate observations.
In some instances, datasets to be merged are not at the same level, for example if you want to merge a household-level dataset with an individual-level dataset, 
or if you want to merge a sector-level health facility dataset with a household-level dataset. In these situations, you must specify the uniqmaster or uniqusing options*/

*(3). Confirm the result of the merge; 
/* After each merge, STATA automatically creates a “_merge” variable summarizing the results of the merge. 
You should tabulate this variable and check the accuracy of the results according to what you would expect from the merge. 
Unless you used specific options, the “_merge” variable indicates if the observations in the new merged dataset come from the master or 
using datasets according to the following norms; 
- If merge==1: observations come from master data
- If merge==2: observations come from only one using dataset
- If merge==3: observations come from at least two datasets, master or using*/
  
*(d) CONSTRUCTING NEW VARIABLES*

*(1) Use standard naming system.
/* In general, name new variables you created after the variable they are mainly based on.  
Once one creates most new variables as the name of the variable it was based on, 
followed by underscore and a number, increasing incrementally starting from one. 
In most cases, the number used for core indicators if it starts say at 100 to spot output or impact indicators more easily throughout the tables produced.
*/
*(2) Create discrete 0-1 variables (“dummy variable”) for existing discrete variables in order to obtain frequencies
/* 
In the case of a bimodal yes-no question, you should create a dummy variable, equal to one if the answer is yes, 0 if the answer is no (in general). 
That way, when you calculate the mean of this dummy variable, you obtain the frequency of respondents who answered yes to the question. 
In the case of a more-than-2-modality discrete variable, you should create as many dummy variables as there were possible answers (use the  mrtab command in stata)
*/

*(3) Create output and outcome indicators with careful consideration of denominators and numerator
/*
 When you construct the variables for analysis, make sure the variable is defined for the appropriate population, the correct age range, the correct gender, 
according to international guidelines or other international guidelines depending on the project you working on.

*/

*(e) DATA ANALYSIS*

*(1) Think of results export while you run the analysis.
/* In case of a baseline report ; The IE team should provide you guidance on the objective of the baseline report. 
First and foremost, the objective at baseline is to produce difference in means tests to validate the evaluation design.
The evaluation design is succeeded in identifying and measuring a counterfactual: the comparison group is equal at baseline to the treatment group(s) on key characteristics
However, you may need to consider additional objectives for content and format of the baseline report, particularly at the request of the project task team leader and/or Government.
In addition, the baseline report should document average characteristics of the respondents, and their comparability with characteristics obtained in other surveys 
(e.g. Demographic and Health Surveys, DHS), or external validity
*/
*(2) Keep in mind the goal of the report i.e., baseline [Follow -up or Endline] 

exit 

