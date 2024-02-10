#Activate environment
conda activate ipyrad

#Run ipyrad with the parameters files CFFE_L1_params.txt CFFE_L2_params.txt CFFE_L3_params.txt
ipyrad -p params-CFFE_group1.txt -s 1
ipyrad -p parama-CFFE_group2.txt -s 1
ipyrad -p params-CFFE_group3.txt -s 1

#Run step 2 through 7 of ipyrad with the parameters file CFFE_params.txt
ipyrad -p params-CFFE_sorted.txt -s 234567

vcftools --vcf CFFE.vcf --plink --out CFFE_vcf


