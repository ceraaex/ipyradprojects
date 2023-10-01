pacman::p_load(EnvStats,dplyr,Rmisc,MASS,vcd,fitdistrplus)
# testdf=data.frame("Populations"=rep(c(1,2,3,4,5),20),"Treatment"=rep(c("Drought","Control"),50),"P1"=runif(100,min=0,max=1),"P2"=runif(100,min=0,max=50),"P3"=runif(100,min=0,max=1.5),"P4"=as.integer(seq(1,100,1)))

#plot distribution and qq line of phenotypes
if((ncol(testdf)-2)%%2 > 0){
    a = (ncol(testdf)-1)/2
} else {
    a = (ncol(testdf)-2)/2
}
pdf(file="qqplot_CFFE_phenotypes.pdf",width=10,height=8,bg="white",paper="A4")
par(mfrow=c(2,a))
for(i in 3:ncol(testdf)){
    name=colnames(testdf)[i]
    qqnorm(testdf[,i],main=name)
    qqline(testdf[,i])
    }
dev.off()
pdf(file="histogram_CFFE_phenotypes.pdf",width=10,height=8,bg="white",paper="A4")
par(mfrow=c(2,a))
for(i in 3:ncol(testdf)){
    name=colnames(testdf)[i]
    hist_testdf<-hist(testdf[,i],main=name,xlab=paste(name,"values",sep=" "))
    x_values <- seq(min(testdf[,i]), max(testdf[,i]), length = 100)
    y_values <- dnorm(x_values, mean = mean(testdf[,i]), sd = sd(testdf[,i])) 
    y_values <- y_values * diff(hist_testdf$mids[1:2]) * length(testdf[,i]) 
    lines(x_values, y_values, lwd = 2)
    }
dev.off()
#assess normality with Shapiro-Wilkes
shapiro_df<-data.frame("statistic.W"=NA,"p.value"=NA,"method"=NA)
for(i in 3:ncol(testdf)){
    shapiro_df[nrow(shapiro_df)+1,]<-unlist(shapiro.test(testdf[,i])[c(1,2,3)])
}
shapiro_df<-shapiro_df[-1,]
testdf_phenotypes<-testdf[,-c(1,2)]
rownames(shapiro_df)<-colnames(testdf_phenotypes)
for(i in 1:nrow(shapiro_df)){
    if(as.numeric(shapiro_df[i,"p.value"]) <= 0.05){
    shapiro_df[i,"FAIL"] <- "Yes"
    } else {
    shapiro_df[i,"FAIL"] <- "No"
    } 
}
fail_list<-list(rownames(shapiro_df[shapiro_df$FAIL=="Yes",]))
#if non-normal, transform & rerun normality on transformed testdf[,i]
for(i in fail_list){
    col<-paste(i,"log",sep="_")
    testdf[,col]<-log(testdf[,i])
    col<-paste(i,"sqrt",sep="_")
    testdf[,col]<-sqrt(testdf[,i])
}
for( i in fail_list){
    log<-paste(i,"log",sep="_")
    sqrt<-paste(i,"sqrt",sep="_")
    testdf_phenotypes<-testdf[,c(log,sqrt)]
}
shapiro_df_redo<-data.frame("statistic.W"=NA,"p.value"=NA,"method"=NA)
for(i in 1:ncol(testdf_phenotypes)){
    shapiro_df_redo[nrow(shapiro_df_redo)+1,]<-unlist(shapiro.test(testdf_phenotypes[,i])[c(1,2,3)])
}
shapiro_df_redo<-shapiro_df_redo[-1,]
rownames(shapiro_df_redo)<-colnames(testdf_phenotypes)
for(i in 1:nrow(shapiro_df_redo)){
    if(as.numeric(shapiro_df_redo[i,"p.value"]) <= 0.05){
    shapiro_df_redo[i,"FAIL"] <- "Yes"
    } else {
    shapiro_df_redo[i,"FAIL"] <- "No"
    } 
}

#if non-normal, assess AIC score of model distributions (gamma, Poisson, Gaussian) & choose lowest AIC
goodnessOfFitList<-data.frame("p"=NA,"phenotype"=NA,"distribution"=NA)
for(i in 1:length(fail_list[[1]])){
    name = fail_list[[1]][i]
    if(typeof(testdf[,name])=="double"){
    p <- gofTest(testdf[,name],test="sw",distribution="lnorm")[[10]]
    dist <- gofTest(testdf[,name],test="sw",distribution="lnorm")[[1]]
    goodnessOfFitList[nrow(goodnessOfFitList)+1,"p"]<-p
    goodnessOfFitList[nrow(goodnessOfFitList),"phenotype"]<-name
    goodnessOfFitList[nrow(goodnessOfFitList),"distribution"]<-dist
    p <- gofTest(testdf[,name],test="sw",distribution="gamma")[[10]]
    dist <- gofTest(testdf[,name],test="sw",distribution="gamma")[[1]]
    goodnessOfFitList[nrow(goodnessOfFitList)+1,"p"]<-p
    goodnessOfFitList[nrow(goodnessOfFitList),"phenotype"]<-name
    goodnessOfFitList[nrow(goodnessOfFitList),"distribution"]<-dist
    } else if (typeof(testdf[,name])=="integer"){
    poisson_df<-as.vector(testdf[,name])
    fit<-summary(goodfit(poisson_df,type='poisson',method="ML"))
    p<-fit[3]
    goodnessOfFitList[nrow(goodnessOfFitList)+1,"p"]<-p
    goodnessOfFitList[nrow(goodnessOfFitList),"phenotype"]<-name
    goodnessOfFitList[nrow(goodnessOfFitList),"distribution"]<-"poisson"
    binomial_df<-as.vector(testdf[,name])
    fit<-summary(goodfit(binomial_df,type='binomial',method="ML"))
    p<-fit[3]
    goodnessOfFitList[nrow(goodnessOfFitList)+1,"p"]<-p
    goodnessOfFitList[nrow(goodnessOfFitList),"phenotype"]<-name
    goodnessOfFitList[nrow(goodnessOfFitList),"distribution"]<-"binomial"
    nbinomial_df<-as.vector(testdf[,name])
    fit<-summary(goodfit(nbinomial_df,type='nbinomial',method="ML"))
    p<-fit[3]
    goodnessOfFitList[nrow(goodnessOfFitList)+1,"p"]<-p
    goodnessOfFitList[nrow(goodnessOfFitList),"phenotype"]<-name
    goodnessOfFitList[nrow(goodnessOfFitList),"distribution"]<-"nbinomial"
    }
}
goodnessOfFitList<-goodnessOfFitList[-1,]
for(i in 1:nrow(goodnessOfFitList)){
    if(goodnessOfFitList[i,"p"] <= 0.05){
    goodnessOfFitList[i,"FAIL"] <- "Yes"
    } else {
    goodnessOfFitList[i,"FAIL"] <- "No"
    }
}

#If all goodness of fits do not pass, make a Cullen and Frey Graph and eyeball which distribution the data falls into.
fail_list<-list(unique(goodnessOfFitList[goodnessOfFitList$FAIL=="Yes","phenotype"]))
if((length(fail_list[[1]])-2)%%2 > 0){
    a = (length(fail_list[[1]])-1)/2
} else {
    a = (length(fail_list[[1]]))/2
}
pdf(file="Cullen_Frey_CFFE_phenotypes.pdf",width=10,height=8,bg="white",paper="A4")
par(mfrow=c(a,2))
for(i in 1:length(fail_list[[1]])){
    name = fail_list[[1]][i]
    descdist(testdf[,name],boot=500)
}
dev.off()

#construct model
#phenotype ~ common garden + treatment + cyanotype + population + (all by combinations)
#for normally distributed phenotypes: parametric tests

#for non-normal: use GLM with appropriate distribution

#summary of model output & create data table

#assess if residuals of model are normally distributed 

#run Breucsh-Pagan test for homoskedacicity

#run variance inflaction factor on models

