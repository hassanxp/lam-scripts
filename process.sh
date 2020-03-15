#!/usr/bin/bash

# visits as specified in
# https://sumire.pbworks.com/w/file/fetch/134025261/PFS-DRP-PRU050002-05-Requests_for_LAM_data_for_the_Data_Reduction_Pipeline.pdf
bias_id='16562..16576 arm=r'
dark_id='16577..16606 arm=r'
fiber_trace_id='16607..16611 arm=r'
dithered_flat_id='16612..16740 arm=r'

#arc_visits=17244..17297

repo=repo-01
rawData=/projects/HSC/PFS/LAM/raw
pfsConfigDir=/projects/HSC/PFS/LAM/pfsConfig
calibDir=${repo}/CALIB
cores=20
rerun=calib0

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

    setup pfs_pipe2d 5.1.11
    workdir=/tigress/hassans/lam-processing
    setup -jr ${workdir}/drp_pfs_data

    echo "loadLSST etc completed."
fi

createrepo=y
if [ "$createrepo" == "n" ] ; then
    echo 'SKIPPING creating a new data repository.'
else
    echo "creating data repository ${repo}.."
    mkdir -p $repo
    mkdir -p $repo/CALIB
    [ -e $repo/_mapper ] || echo "lsst.obs.pfs.PfsMapper" > $repo/_mapper
    echo "Repo '${repo}' created"
fi

ingestraw=y
if [ "$ingestraw" == "n" ] ; then
    echo 'SKIPPING ingesting raw'
else
# Ingest raw 'RefDataSet's for bias/dark/flats
ingestPfsImages.py ${repo} --mode=link \
    ${rawData}/2019-04-26/PFLA0*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir=${pfsConfigDir}

# Ingest raw arcs of interest (visit=17244) 
ingestPfsImages.py ${repo} --mode=link \
    ${rawData}/2019-05-07/PFLA0*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir=${pfsConfigDir}
fi

# Ingest recent detectormaps
ingestCalibs.py ${repo}  --calib ${calibDir} --validity 1000 --mode=copy $DRP_PFS_DATA_DIR/detectorMap/detectorMap-2019Jul-*

bash pfs_build_calibs.sh -c ${cores} -C ${calibDir} -b visit="${bias_id}" -d visit="${dark_id}" -f visit="${dithered_flat_id}" -F visit="${fiber_trace_id}" -r ${rerun} ${repo}

reduceArc.py ${repo} --calib ${calibDir} --rerun arc --id visit=17244 arm=r -j ${cores}

echo 'processing DONE.'

