rawData=/projects/HSC/PFS/LAM/raw
pfsConfigDir=/projects/HSC/PFS/LAM/pfsConfig

repo=repo-01

# Ingest raw 'RefDataSet's for bias/dark/flats
# https://sumire.pbworks.com/w/file/fetch/134025261/PFS-DRP-PRU050002-05-Requests_for_LAM_data_for_the_Data_Reduction_Pipeline.pdf
# – biases, (16562-16576)
# – darks, (16577-16606)
# – fiber-traces, (16607-16611)
# – dithered fiber-traces, (16612-16740)
ingestPfsImages.py ${repo} --mode=link \
    ${rawData}/2019-04-26/PFLA0*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir=${pfsConfigDir}

# Ingest raw arcs of interest (visit=17244) 
ingestPfsImages.py ${repo} --mode=link \
    ${rawData}/2019-05-07/PFLA0*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir=${pfsConfigDir}
