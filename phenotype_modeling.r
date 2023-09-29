
#plot distribution of phenotypes

#assess normality (Shapiro-Wilkes test or Anderson-Darling)

#if non-normal, transform & rerun normality on transformed data

#if non-normal, assess AIC score of model distributions (gamma, Poisson, Gaussian) & choose lowest AIC

#construct model
#phenotype ~ common garden + treatment + cyanotype + population + (all by combinations)
#for normally distributed phenotypes: parametric tests
#for non-normal: use GLM with appropriate distribution

#summary of model output & create datatable 

#assess if residuals of model are normally distributed 
#run Breucsh-Pagan test for homoskedacicity

#run variance inflaction factor on models

