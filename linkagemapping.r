# Install the package
install.packages("devtools")
devtools::install_github("tpbilton/GUSbase")
devtools::install_github("tpbilton/GUSMap")

# Convert VCF to RA
rafile <- VCFtoRA(infilename = "~ipyradprojects/CFFE.vcf", makePed = TRUE)

trepens <- makeBC(RAobj = readRA(rafile = "~ipyradprojects/CFFE.vcf.ra.tab", sampthres = 0.01, excsamp = NULL), 
          pedfile = "~ipyradprojects/CFFE_ped.csv", inferSNPs = TRUE,
          filter = list(MAF = 0.05, MISS = 0.5, BIN = 100,
                DEPTH = 5, PVALUE = 0.01, MAXDEPTH=500))

trepens$rf_2pt(nClust = 3)

save(trepens, file = "BCobject.Rdata")

# plot 2-point rf matrix for BI and MI SNPs
trepens$plotChr(mat = "rf", parent = "maternal", lmai = 0.5)

# plot 2-point LOD matrix for BI, PI and MI SNPs
trepens$plotChr(mat = "LOD", parent = "both", lmai = 0.5)

trepens$createLG(parent = "both", LODthres = 5, nComp = 10, reset = FALSE)

trepens$plotLG(parent = "both", interactive = FALSE, LG = NULL)

trepens$plotSyn()

trepens$writeLM(file = "trepens")