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

import delimited data.csv

* Start logging

log using scvs_log_1.log, replace

* Create  a factor for the provinces

encode province, gen (prov)

* Test regression

reg buss i.prov

* Show the error

reg buss i.prov post antivax


* Turn off the log
log close 
* Exit
exit
