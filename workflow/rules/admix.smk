rule vcf_bed:
    input:
    vcf = f"{IPYRAD_DIR}/CFFE_outfiles/CFFE.vcf.gz"
    output:
    multitext(f"{ADMIX_DIR}/bed_files/CFFE",'.bed','.bim')
    log:
    f"{LOG_DIR}/logs/bed.log"
    conda: '../envs/admixture.yaml'
    params:
    outdir = f"{ADMIX_DIR}/bed_files"
    shell:
    """
        plink --vcf {input} \
        --allow-no-sex \
        --keep-allele-order \
        --allow-extra-chr \
        --make-bed \
        --out {outdir}/CFFE &> {log}
    """

rule make_prune:
    input: 
        bed = f"{ADMIX_DIR}/bed_files/CFFE.bed"
    output:
        in_file = f"{ADMIX_DIR}/bed_files/plink.prune.in"
    log:
        f"{LOG_DIR}/logs/prune.log"
    conda: '../envs/admixture.yaml'
    params:
        outdir = f"{ADMIX_DIR}/bed_files"
    shell:
    """
        cd {outdir}
        plink --bfile {input.bed} \
        --indep-pairwise 50 10 0.1 &> {log}
    """

rule LD_prune:
    input:
        bim = f"{ADMIX_DIR}/bed_files/CFFE.bim"
    output:
        pruned = f"{ADMIX_DIR}/bed_files/prunnedCFFE.bed"
    log:
        f"{LOG_DIR}/LD.log"
    conda: '../envs/admixture.yaml'
    shell:
    """
        plink --bfile {rule.make_prune.input.bed} \
        --extract {rule.make_prune.output.in_file} \
        --make-bed \
        --out prunedCFFE &> {log}

        awk '$1="0";print $0}' {input.bim} > {input.bim}.tmp
        mv {input.bim}.tmp {input.bim}
    """

rule admix_K1_10:
    output:
        f"{ADMIX_DIR}/admix/log{{k}}.out"
    log:
        f"{LOG_DIR}/admix.log"
    conda: '../envs/admixture.yaml'
    params:
        outdir = f"{ADMIX_DIR}/admix"
    shell:
    """
        for K in {{k}} \
        do \
        admixture --cv {rule.LD_prune.output.pruned} $K | \
        tee {outdir}/{output} \
        done &> {log}

    """

rule chose_K:
    input:
    output:
    
