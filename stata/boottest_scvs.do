/* Stata Analysis for SCVS Letter- Vax and business creation*/

* In this script I simply do the two boottests that R doesn't allow me to. I'll need to estimate the regression tho.

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

import delimited data_for_stata.csv

* Start logging

log using scvs_log.log, replace

* For the two way clustering

egen double_cluster = group (province month)

* Encoding

 encode province, gen (prov)
 
* Run the regression:

reg lbuss did excessd_rate job_change v_deaths robbery transit_acc i.prov i.monthyear, vce (cluster double_cluster)

* Run the wild bootstrap

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

* Run the other regression

reg lnsas did excessd_rate job_change v_deaths robbery transit_acc i.prov i.monthyear, vce (cluster double_cluster)

* Run the wild bootstrap

boottest did, reps (9999) bootcluster(double_cluster) seed(1) nograph

 * Turn off the log
log close 
* Exit
exit


