cls 
clear

******SET THE WORKING DIRECTORY******

cd "C:\Users\Administrator\Desktop\My Biostatistics Portfolio\Quarter 1 Study Plan\Week 1 Task\Datasets"

*****LOAD THE DATA******

import excel "C:\Users\Administrator\Desktop\My Biostatistics Portfolio\Quarter 1 Study Plan\Week 1 Task\Datasets\STIData.xls", sheet("STIData") firstrow

*****DATA CLEANING AND CREATING VARIABLES FOR LATER USE*****
encode A2Occupation, gen(Occupation)
encode A3Church , gen(Church)
encode A4LevelOfEducation , gen(Education_Level)
encode A5MaritalStatus, gen(Marital_Status)
encode AgeFirstSex,gen (Age_FirstSex)
encode N11Usedcondom ,gen (Condom_Use)
encode N11Usedcondom ,gen (Condom_Use_LastSex)
encode N13TakenAlcohol ,gen (Alcoholic)
encode Typeofsti ,gen (STI)
encode N9Relationship, gen(Relationship)
encode E8WhyhaveSTI, gen(Spread_STI)


gen Age_Cat=1 if A1Age <18
replace Age_Cat=2 if A1Age>=18 & A1Age<25
replace Age_Cat=3 if A1Age>=25 & A1Age<30
replace Age_Cat=4 if A1Age>=30 & A1Age<35
replace Age_Cat=5 if A1Age>=35 & A1Age<40
replace Age_Cat=6 if A1Age>=40

label variable Age_Cat Age_Cat
label define Age_Cat 1 "<18" 2 "18-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40+"
label values Age_Cat Age_Cat


gen BMI = Weight/( (Height/100) * (Height/100))
gen BMI_Cat=1 if BMI<18.5
replace BMI_Cat=2 if BMI>=18.5 & BMI<25
replace BMI_Cat=3 if BMI>=25.0 & BMI<30
replace BMI_Cat=4 if BMI>=30
label variable BMI BMI

label define BMI_Cat 1 "Underweight" 2 "Healthy Weight" 3 "Overweight" 4 "Obese",modify
label variable BMI_Cat BMI_Cat
label values BMI_Cat BMI_Cat

rename C3StiYesno STI_Status
label variable STI_Status STI_Status
label define STI_Status 0 "No" 1 "Yes"
label values STI_Status STI_Status


label define CaseStatus 1 "Case" 2 "Control"
label values CaseStatus CaseStatus

label define YesNo 1 "Yes" 2 "No"

label values D1BurialSociety D1religiousgrp  D1savingsClub D1tradersAssoc D3FuneralAssistance D3HealthServices D3Education N14DoYouHave N15LivingTogether D3receivecredit N3HadAnSti HabitationStatus Unemployed Education  AlcoholUse YesNo

********CLEAN THE MISSING OBS ENTRIES******

replace CaseStatus=1 if IdNumber==31 | IdNumber==1
replace Sex="male" if IdNumber==48
replace Sex="female" if IdNumber==213
replace Sex="Female" if Sex=="female"
replace Sex="Male" if Sex=="male"

replace STI_Status=1 if STI_Status==. & CaseStatus==1
replace STI_Status=1 if STI_Status==. & E8WhyhaveSTI!=""
replace STI_Status=0 if  E8WhyhaveSTI==""


*********SAVE THE CLEAN DATA*******

save "C:\Users\Administrator\Desktop\My Biostatistics Portfolio\Quarter 1 Study Plan\Week 1 Task\Datasets\STI_Clean.dta",replace

*******KEEP NEEDED VARIABLES*****
*keep IdNumber Sex CaseStatus Date A1Age Weight Height STI_Status D1BurialSociety D1religiousgrp D1savingsClub D1tradersAssoc D3Education D3FuneralAssistance D3HealthServices DurationOfillness N14DoYouHave N15LivingTogether N16HowOldIs D3receivecredit N2SexDebut N3HadAnSti HabitationStatus Unemployed Education AlcoholUse SexPartner1year SexPartner3month LastPartnerSpouse Belong ReceiveHelp SexPartnerLife3 AU Occupation Church Education_Level Marital_Status Age_FirstSex Condom_Use Condom_Use_LastSex Alcoholic STI Relationship Spread_STI Age_Cat BMI BMI_Cat

*save "C:\Users\Administrator\Desktop\My Biostatistics Portfolio\Quarter 1 Study Plan\Week 1 Task\Datasets\STI_Clean_NeededVars.dta",replace

************DESCRIPTIVE STATISTICS**********

***Prevalence of STI***
tab STI_Status

*****Socio-demographic Characteristics******

tab Sex
tab Age_Cat
tab BMI_Cat
tab Occupation
tab Education_Level
tab Marital_Status
tab Church

*****Bivariate Analysis********

******Association between Socio-demographics and STI****

// install it!
ssc install table1_mc

// now specify things by "myexposure"
table1_mc, by(STI_Status) ///
vars( ///
CaseStatus cat %4.0f \ ///
Age_Cat cate %4.0f \ ///
BMI_Cat cate %4.0f \ ///
Marital_Status cate %4.0f \ ///
Education_Level cate %4.0f \ ///
Occupation cat %4.0f \ ///
Church cate  %4.0f \ ///
) ///
onecol test statistic total(before) ///
saving("Analysis Results.xlsx", replace)

save "C:\Users\Administrator\Desktop\My Biostatistics Portfolio\Quarter 1 Study Plan\Week 1 Task\Datasets\STI_Clean2.dta",replace
