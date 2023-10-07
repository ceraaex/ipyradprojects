#params file
ipyrad -n CFFE_group1.txt

#demultiplexing
ipyrad -p params-CFFE_group1.txt -s 1 -c 20

#trimming
ipyrad -p params-CFFE_group1.txt -s 2

#clustering within samples
ipyrad -p params-CFFE_group1.txt -s 3

#estimating heterozygosity and seq error
ipyrad -p params-CFFE_group1.txt -s 4

#consensus base calls
ipyrad -p params-CFFE_group1.txt -s 5

#clustering between samples
ipyrad -p params-CFFE_group1.txt -s 6

#output files
ipyrad -p params-CFFE_group1.txt -s 7

###################
##FINISHED ipyrad##
###################




