############################################### SUPERCIAS LETTER: COVID VAX  ###############################################

# Script for estimating initial models

# Preliminaries ----------------------------------------------------------------------------------------------------------

# Load libraries

library(tidyverse)
library(sandwich)
library(lmtest)
library(modelsummary)
library(fwildclusterboot)
library(fixest)

# Load data

df<-read.csv('data/clean_data.csv')


# Data wrangling ---------------------------------------------------------------------------------------------------------

# Create province factors (for the clustered std. errors)

df$prov<-as.factor(df$province)

# Create post dummy variable 

df$post<-ifelse(df$post == 'post',1,0)

# Create the antivax factor variable

df$antivax<-as.factor(df$antivax)

# Create a year factor

df$year<-as.factor(df$year)

# Create the region factor variable

df$region %>% as.factor(df$region)

# Change the reference level to PICHINCHA

df$prov<-relevel(df$prov, 'PICHINCHA')

# Antivax Indicator Problem ----------------------------------------------------------------------------------------------

ols_antivax<-lm(buss ~ antivax + prov,
                data = df)

summary(ols_antivax)

ols_antivax1<-lm(buss ~ prov + antivax*post,
                 data = df)

summary(ols_antivax1)

# Developing clusters and bootstrapping ----------------------------------------------------------------------------------

# First, run a simple model with OLS

ols<-lm(buss ~ vax_leastone + prov, 
        data = df)

summary(ols)

# Now, run the same model but now with clustered standard errors

clustered<-coeftest(ols, 
                    vcov = vcovCL, 
                    cluster = ~ prov)
clustered

# Now, do the fast wild bootstrap (boottest function from Stata)

# First run a model with an interaction to test with the bootstrapping

interaction_model<-lm(buss ~ post*vax_leastone + prov,
                      data = df)

summary(interaction_model)

# Apply clustered errors to the model

c_int_model<-coeftest(interaction_model,
                      vcov = vcovCL,
                      cluster = ~ prov)
c_int_model

# Now do the bootstrapping

boot_interaction_model<-boottest(interaction_model, 
                                 clustid = 'prov',
                                 param = 'post:vax_leastone',
                                 B = 9999)

summary(boot_interaction_model)

# Actual regression models -----------------------------------------------------------------------------------------------

# Create a DiD model with at least one vacccine rate for provinces with all fixed effects. Cluster by province

did_simple<-lm(buss ~ post*vax_leastone + prov + month + year,
               data = df)

# Cluster errors 

did_simple_feols<-feols(buss ~ post*vax_leastone + month + year| prov,
                        cluster = ~ prov,
                        data = df)

summary(did_simple_feols)

# To show the fixed effects

fixef(did_simple_feols) %>% print()

# Another model with the deaths variable 

did_complex_1<-feols(buss ~ post*vax_leastone + month + year + deaths | prov,
                     cluster = ~ prov,
                     data = df)

summary(did_complex_1)

# Do the bootstrapping

boot_deaths<-boottest(did_complex_1,
                      clustid = 'prov',
                      param = 'post:vax_leastone',
                      B = 9999)

summary(boot_deaths)

# Add more variables

did_complex_feols<-feols(buss ~ post*vax_leastone + month + year + deaths + robbery + transit_acc + job_change +
                         tax_pc + sales_pc_k| prov,
                         cluster = ~ prov,
                         data = df)

summary(did_complex_feols)

# Run the bootstrapping test

boot_complex<-boottest(did_complex_feols,
                       clustid = 'prov',
                       param = 'post:vax_leastone',
                       B = 9999)

summary(boot_complex)

# Run another model with the same stuff but now including the mobility stuff by Google.
# Naturally, there will be a lot less observations.

did_complex_g<-feols(buss ~ post*vax_leastone + month + year  + deaths + robbery + transit_acc + job_change +
                     tax_pc + sales_pc_k + mobility_retail| prov,
                     cluster = ~ prov,
                     data = df)

summary(did_complex_g)

did_complex_g<-lm(buss ~ post*vax_leastone + month + year  + deaths + robbery + transit_acc + job_change +
                  tax_pc + sales_pc_k + mobility_retail,
                  data = df)

summary(did_complex_g)


# Run the bootstrapping test

boot_complex1<-boottest(did_complex_g,
                       clustid = 'prov',
                       param = 'post:vax_leastone',
                       B = 9999)

summary(boot_complex1)

# Run another model, add some other variables 

did_complex_g1<-feols(buss ~ post*vax_leastone + month + year  + deaths + robbery + transit_acc + job_change +
                       tax_pc + sales_pc_k +mobility_retail + vax_complete + v_deaths | prov,
                     cluster = ~ prov,
                     data = df)

summary(did_complex_g1)

boot_complex2<-boottest(did_complex_g1,
                        clustid = 'prov',
                        param = 'post:vax_leastone',
                        B = 9999)

# Add positive cases

did_complex_g2<-feols(buss ~ post*vax_leastone + month + year  + deaths + robbery + transit_acc + job_change +
                        tax_pc + sales_pc_k +mobility_retail + vax_complete + v_deaths + positive_cases| prov,
                      cluster = ~ prov,
                      data = df)

summary(did_complex_g2)

# Eliminate the google trends stuff to see what happens with the bootstrapping

did_complex_nogog<-feols(buss ~ post*vax_leastone + month + year  + deaths + robbery + transit_acc + job_change +
                        tax_pc + sales_pc_k + vax_complete + v_deaths + positive_cases| prov,
                      cluster = ~ prov,
                      data = df)

summary(did_complex_nogog)

# Make the bootstrapping

boot_complexng<-boottest(did_complex_nogog,
                         clustid = 'prov',
                         param = 'post:vax_leastone',
                         B = 9999)

summary(boot_complexng)

# Now again, but without the positive cases stuff

did_complex_nogog1<-feols(buss ~ post*vax_leastone + month + year  + deaths + robbery + transit_acc + job_change +
                          tax_pc + sales_pc_k + vax_complete + v_deaths | prov,
                          cluster = ~ prov,
                          data = df)

summary(did_complex_nogog1)

# Do the bootstrapping

boot_complexng<-boottest(did_complex_nogog1,
                         clustid = 'prov',
                         param = 'post:vax_leastone',
                         B = 9999)
summary(boot_complexng)




