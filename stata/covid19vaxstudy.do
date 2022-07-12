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

import delimited clean_data.csv

* Start logging

log using scvs_log.log, replace

* Create a factor for the provinces

encode province, gen (prov)

* Create a factor for the months

encode month, gen (month_f)

* Create a factor for the year

gen year_d = 0
replace year_d =1 if year>2020

* Create a factor for the period

encode post, gen(period)

 /* Regressions using the COVID-19 vaccine rate as my key variable for the DD*/
 
  * Run the "easy" model, without the google trends mobility stuff

 reg buss i.prov i.month_f year_d deaths v_deaths vax_complete 1.period##c.vax_leastone, cluster(prov)
 
 estimates store m1, title(Model 1 Easy)
  
 * Do the bootstrap test
 
 boottest 1.period#vax_leastone, reps (9999) bootcluster(prov)
 
 * Run the model with google trends stuff
 
 reg buss i.prov i.month_f year_d deaths v_deaths vax_complete m_workplace 1.period##c.vax_leastone , cluster(prov)
 
 estimates store m2, title (Model 2 Easy with Google Trends Mobility)
 
 * Do the bootstrap test
 
 boottest 1.period#vax_leastone, reps (9999) bootcluster(prov)
 
  * Now another model with more stuff
 
 reg buss i.prov i.month_f year_d deaths v_deaths vax_complete m_workplace 1.period##c.vax_leastone robbery transit_acc job_change tax_pc sales_pc_k, cluster(prov)
 
 estimates store m3
 
 * Bootstrap test
 
 boottest 1.period#vax_leastone, reps (9999) bootcluster(prov)
 
 * The same model but with positive cases 
 
 reg buss i.prov i.month_f year_d deaths v_deaths vax_complete m_workplace 1.period##c.vax_leastone robbery transit_acc job_change tax_pc sales_pc_k positive_cases, cluster(prov)
 
 estimates store m4
 
  * Bootstrap test
 
 boottest 1.period#vax_leastone, reps (9999) bootcluster(prov)
 
 * Now add to the complex model the taxpayers
 
 reg buss i.prov i.month_f year_d deaths v_deaths vax_complete m_workplace 1.period##c.vax_leastone robbery transit_acc job_change taxpayers positive_cases, cluster(prov)
 
 estimates store m5
  
 * Do the bootstrap test
 
 boottest 1.period#vax_leastone, reps (9999) bootcluster(prov)
 
 
 * Turn off the log
log close 
* Exit
exit
