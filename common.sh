###
#
# common configuration and setup
#
###

#pfs_tag=5.1.15
pfs_tag=5.2
workdir=/tigress/hassans/lam-processing
softwareDir=/tigress/hassans/software
repo=/tigress/hassans/lam-processing/repo-08
rawData=/projects/HSC/PFS/LAM/raw
pfsConfigDir=/projects/HSC/PFS/LAM/pfsConfig
calibDir=${repo}/CALIB
cores=20
rerun=20200522-a

# visits as specified in
# https://sumire.pbworks.com/w/file/fetch/134025261/PFS-DRP-PRU050002-05-Requests_for_LAM_data_for_the_Data_Reduction_Pipeline.pdf
#bias_id='visit=16562..16576 arm=r'
#dark_id='visit=16577..16606 arm=r'
#fiber_trace_id='visit=16607..16611 arm=r'
#dithered_flat_id='visit=16612..16740 arm=r'

#start_arc=17244
#end_arc=17297

bias_id='visit=21077..21091 arm=r'
dark_id='visit=21092..21121 arm=r'
dithered_flat_id='visit=21127..21255:3 arm=r'
fiber_trace_id='visit=21122..21126 arm=r'

start_arc_id='visit=21400 arm=r'
#end_arc=17246

bootstrap_flat_id='visit=21122 arm=r'

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

#    setup pfs_pipe2d ${pfs_tag}
#    setup -jr ${workdir}/drp_pfs_data

#    echo 'using LOCAL version of datamodel'
#    setup -jr ${softwareDir}/datamodel
    
#    echo 'using LOCAL version of obs_pfs'
#    setup -jr ${softwareDir}/obs_pfs

#    echo 'using LOCAL version of drp_stella'
#    setup -jr ${softwareDir}/drp_stella

    echo "loadLSST etc completed."
fi
