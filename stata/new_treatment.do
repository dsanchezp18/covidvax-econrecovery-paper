/* Stata Analysis for SCVS Letter- Vax and business creation*/

* Preliminary commands

version 15 
*Ensures compatibility with other Stata versions
set more off 
* Turn off the more button to see more results in the screen
capture log close 
* Turns off any log that is open
clear 
* Clears everything set before

* Set the working directory : 

cd "C:\Users\Daniel Sanchez\OneDrive\Documentos\personal\docs\research\covid-vaccine\scvs_letter_stata"

* Load data

import delimited df_new.csv

* Start logging

log using scvs_log_newtreat.log, replace

/* Some quick data wrangling first */

* I first encode the province variable for it to be treated as a factor by Stata.

drop prov 

encode province, gen(prov) //Prov from now on will always be my province factor
 
 * Create a factor for the months

encode month, gen (monthf)

* Create a dummy for the year

gen year_d = "y20"
replace year_d ="y21" if year>2020
encode year_d, gen (year_f)

* Create the natural log of business

drop lbuss
gen lbuss = log(1+buss)

* Rename the period variable

rename post period

/* Models with the antivax-provax treatment */

* I know try to find a negative effect of being an "antivax" province in business creation.

* I will be doing this by using an interaction between the antivax-provax indicator and the period. 
* However, since I will have perfect collinearity if I include both, I'll just include the interaction term.

* Run the simplest model

egen double_cluster = group (prov month)

reg lbuss did period i.prov i.monthf, vce (cluster double_cluster)

est store m1

* Run the wild bootstrap

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* All good for now. Run the next model, now doing the interaction

reg lbuss did period i.prov#i.monthf, vce (cluster double_cluster)

est store m2

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Run another model, this time with some more variables and the province*month interaction

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf, vce (cluster double_cluster)

est store m3

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Now add some of the google mobility data

* Retail

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_retail, vce (cluster double_cluster)

est store m4

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Grocery

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_grocery, vce (cluster double_cluster)

est store m5

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Parks

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_parks, vce (cluster double_cluster)

est store m6

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Transit

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_transit, vce (cluster double_cluster)

est store m7

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Residential

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_residential, vce (cluster double_cluster)

est store m8

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Workplace

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_workplace, vce (cluster double_cluster)

est store m9

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* All of them 

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_retail m_grocery m_parks m_transit m_residential m_workplace, vce (cluster double_cluster)

est store m10

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Add cases

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_retail m_grocery m_parks m_transit m_residential m_workplace total_cases, vce (cluster double_cluster)

est store m11

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Add replace with case rate
reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_retail m_grocery m_parks m_transit m_residential m_workplace case_rate, vce (cluster double_cluster)

est store m12
 
boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Add new cases

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_retail m_grocery m_parks m_transit m_residential m_workplace new_cases, vce (cluster double_cluster)

est store m13

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Add new case rate

reg lbuss did period vax_leastone vax_complete excessd year i.prov#i.monthf m_retail m_grocery m_parks m_transit m_residential m_workplace new_case_rate, vce (cluster double_cluster)

est store m14

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

*Replace the excess deaths with excess death rate

reg lbuss did period vax_leastone vax_complete excessd_rate year i.prov#i.monthf m_retail m_grocery m_parks m_transit m_residential m_workplace total_cases, vce (cluster double_cluster)

est store m15

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* The same but without cases

reg lbuss did period vax_leastone vax_complete excessd_rate year i.prov#i.monthf m_retail m_grocery m_parks m_transit m_residential m_workplace, vce (cluster double_cluster)

est store m16

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Regressions Table

outreg2 [m*] using "Output1", excel replace addstat (Adj. R^2, e(r2_a))keep(did period vax_leastone vax_complete excessd year m_retail m_grocery m_parks m_transit m_residential m_workplace total_cases case_rate new_cases new_case_rate excessd_rate)

/* With other variables, what is happenning? */

reg lbuss did period i.prov i.monthf taxpayers, vce (cluster double_cluster)

est store error1

* Comparison with adding the interactions

reg lbuss did period i.prov#i.monthf taxpayers, vce (cluster double_cluster)

est store error2

outreg2 [error*] using "OutputError1", excel replace addstat (Adj. R^2, e(r2_a))



