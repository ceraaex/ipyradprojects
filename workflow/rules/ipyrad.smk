rule ipyrad_params:
    input:
        f"CFFE_group1.txt"
    output: 
        params=f"params-CFFE_group1.txt"
    conda: "environment.yaml"
    shell:
        """
        ipyrad -n {input}
        """

rule ipyrad_demux_trim:
    input:
        {ipyrad_params.output.params}
    output:
    conda: "environment.yaml"
    shell: