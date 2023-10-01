#Download admixture, plink in conda
source activate ipyrad_project
mamba install -c bioconda admixture
mamba install -c bioconda plink

#make bed,bim, and fam using vcf.gz output files
plink --vcf CFFE.vcf.gz --allow-no-sex --keep-allele-order --allow-extra-chr --make-bed --out CFFE

#prune file for instances of linkage disequilibrium 
plink --bfile CFFE.bed --indep-pairwise 50 10 0.1
plink --bfile CFFE.bed --extract plink.prune.in --make-bed --out prunedCFFE 
awk '$1="0";print $0}' CFFE.bim > CFFE.bim.tmp
mv $CFFE.bim.tmp $CFFE.bim

#Chose K Value Value on LD corrected plink files
for K in {1..10};
do admixture --cv prunedCFFE.bed $K | tee log${K}.out; done

K_value=$(grep -h CV log*.out | sed 's| ||g' | awk 'BEGIN {FS=":"} {print $1,$2}' | sort -k 2 -n | head -1 | awk -F " " '{print substr($3,4,1) }')

#Move K value to seperate directory
mkdir K_best
mv prunedCFFE.$K_value.* ./K_best



