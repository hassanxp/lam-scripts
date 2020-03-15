stack=/tigress/HSC/PFS/stack/current
echo "Sourcing ${stack}/loadLSST.bash ..."
source ${stack}/loadLSST.bash

# Appears to be bug when calling loadLSST.bash twice
# Restore version of python in lsst-scipipe virtual env
# Note: may bloat path 
export PATH=${stack}/python/miniconda3-4.5.12/envs/lsst-scipipe/bin:${PATH}

setup pfs_pipe2d 5.1.11

workdir=/tigress/hassans/lam-processing
setup -jr ${workdir}/drp_pfs_data

