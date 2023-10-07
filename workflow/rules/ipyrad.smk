rule ipyrad_params:
    input:
        R1 = f"{CFFE_FASTA_DIR}/{{LANES}}_R1"
        R2 = f"{CFFE_FASTA_DIR}/{{LANES}}_R2"
    output: 
        R1_param = f"{IPYRAD_DIR}/params-{{LANES}}_R1.txt"
        R2_param = f"{IPYRAD_DIR}/params-{{LANES}}_R2.txt"
    conda: '../envs/ipyrad.yaml'
    shell:
        """
        ipyrad -n {input}
        """

rule mod_params:
    shell:
    """
    echo "/work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group1_R1_.fastq.gz       ## [2] [raw_fastq_path]: Location of raw non-demultiplexed fastq files\n \
    /work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group1_R1_barcodes.txt       ## [3] [barcodes_path]: Location of barcodes file" >>\
    /work/ceraaex/ipyrad_projects/results/ipyard/params-CFFE_group1_R2.txt
    echo "/work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group1_R2_.fastq.gz       ## [2] [raw_fastq_path]: Location of raw non-demultiplexed fastq files\n \
    /work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group1_R2_barcodes.txt       ## [3] [barcodes_path]: Location of barcodes file" >>\
    /work/ceraaex/ipyrad_projects/results/ipyard/params-CFFE_group1_R2.txt

    echo "/work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group2_R1_.fastq.gz       ## [2] [raw_fastq_path]: Location of raw non-demultiplexed fastq files\n \
    /work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group2_R1_barcodes.txt       ## [3] [barcodes_path]: Location of barcodes file" >>\
    /work/ceraaex/ipyrad_projects/results/ipyard/params-CFFE_group2_R2.txt
    echo "/work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group2_R2_.fastq.gz       ## [2] [raw_fastq_path]: Location of raw non-demultiplexed fastq files\n \
    /work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group2_R2_barcodes.txt       ## [3] [barcodes_path]: Location of barcodes file" >> \
    /work/ceraaex/ipyrad_projects/results/ipyard/params-CFFE_group2_R2.txt

    echo "/work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group3_R1_.fastq.gz       ## [2] [raw_fastq_path]: Location of raw non-demultiplexed fastq files\n \
    /work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group3_R1_barcodes.txt       ## [3] [barcodes_path]: Location of barcodes file" >>\
    /work/ceraaex/ipyrad_projects/results/ipyard/params-CFFE_group3_R2.txt
    echo "/work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group3_R2_.fastq.gz       ## [2] [raw_fastq_path]: Location of raw non-demultiplexed fastq files\n \
    /work/ceraaex/ipyrad_projects/results/ipyard/CFFE_group3_R2_barcodes.txt       ## [3] [barcodes_path]: Location of barcodes file" >> \
    /work/ceraaex/ipyrad_projects/results/ipyard/params-CFFE_group3_R2.txt
    """

rule ipyrad_demux:
    input: 
        R1_param = f"{IPYRAD_DIR}/params-{{LANES}}_R1.txt"
        R2_param = f"{IPYRAD_DIR}/params-{{LANES}}_R2.txt"
    params:
        outdir = f"{IPYRAD_DIR}/{{LANES}}_fastqs"
    log: 
        f"{LOGDIR}/demux.log"
    conda: '../envs/ipyrad.yaml'
    shell:
        """
        ipyrad -p {rules.ipyrad_params.output.paramFile} \
        -s 1 \
        -c 20 \

        ipyrad -p {rules.ipyrad_params.output.paramFile} -r &> {log}
        """

rule filter:
    input:
        f"{IPYRAD_DIR}/params-CFFE.txt"
    output:
        multitext(f"{IPYRAD_DIR}/CFFE_outfiles/CFFE",'.geno','.nex','.phy','.str','.vcf')
    params:
        outdir = f"{IPYRAD_DIR}/CFFE_outfiles"
    conda: '../envs/ipyrad.yaml'
    shell: 
    """
        ipyrad -p {input} -s 7
    """