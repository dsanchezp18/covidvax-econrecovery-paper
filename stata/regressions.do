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

* Create  a factor for the provinces

encode province, gen (prov)

* Create factor for antivax and for post

encode antivax, gen (antivax_fac)

encode post, gen (did)

* Now run the actual regression

regress buss i.did#i.antivax_fac i.prov vax_leastone, cluster (prov)

* Do the boottest

boottest vax_leastone, reps (9999) bootcluster(prov)

* Do the boottest with the interaction term

boottest i.did#i.antivax_fac, reps (9999) bootcluster(prov)

* Turn off the log
log close 
* Exit
exit
