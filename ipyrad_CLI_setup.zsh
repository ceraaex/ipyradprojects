# The curl command is used to download the installer from the web.
# Take note that the -O flag is a capital o not a zero.
curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh

# Install miniconda into $HOME/miniconda3
#  * Type 'yes' to agree to the license
#  * Press Enter to use the default install directory
#  * Type 'yes' to initialize the conda install
bash Miniconda3-latest-MacOSX-x86_64.sh

# test that conda is installed. Will print info about your conda install.
conda info

# Remove the installer
rm Miniconda3-latest-MacOSX-x86_64.sh

# Create conda environment
 conda env create -f ./ipyradprojects/environment.yaml

 conda activate ipyrad 

 mamba install ipyrad -c conda-forge -c bioconda 

