###
#
# common configuration and setup
#
###

pfs_tag=5.1.11
workdir=/tigress/hassans/lam-processing
softwareDir=/tigress/hassans/software
repo=/tigress/hassans/lam-processing/repo-01
rawData=/projects/HSC/PFS/LAM/raw
pfsConfigDir=/projects/HSC/PFS/LAM/pfsConfig
calibDir=${repo}/CALIB
cores=20
rerun=calib0

# visits as specified in
# https://sumire.pbworks.com/w/file/fetch/134025261/PFS-DRP-PRU050002-05-Requests_for_LAM_data_for_the_Data_Reduction_Pipeline.pdf
bias_id='16562..16576 arm=r'
dark_id='16577..16606 arm=r'
fiber_trace_id='16607..16611 arm=r'
dithered_flat_id='16612..16740 arm=r'

start_arc=17244
end_arc=17297

prepare=y

if [ "$prepare" == "n" ]; then 
    echo 'SKIPPING prepare (sourcing loadLSST.bash etc)..'
else
    stack=/tigress/HSC/PFS/stack/current
    echo "Sourcing ${stack}/loadLSST.bash ..."
    source ${stack}/loadLSST.bash

    # Appears to be bug when calling loadLSST.bash twice
    # Restore version of python in lsst-scipipe virtual env
    # Note: may bloat path 
    export PATH=${stack}/python/miniconda3-4.5.12/envs/lsst-scipipe/bin:${PATH}

    setup pfs_pipe2d ${pfs_tag}
    setup -jr ${workdir}/drp_pfs_data
    echo 'using LOCAL version of obs_pfs (in order to correct headers)'
    setup -jr ${softwareDir}/obs_pfs
    echo "loadLSST etc completed."
fi
