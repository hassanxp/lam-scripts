#!/usr/bin/bash

dirName=$(dirname "$0")
echo "sourcing ${dirName}/common.sh .."
source ${dirName}/common.sh
echo "source done."

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

# Ingest raw arcs of interest (visit=17244 etc) 
ingestPfsImages.py ${repo} --mode=link \
    ${rawData}/2019-05-07/PFLA0*.fits \
    -c clobber=True register.ignore=True --pfsConfigDir=${pfsConfigDir}
fi

# Ingest recent detectormaps
ingestCalibs.py ${repo}  --calib ${calibDir} --validity 1000 --mode=copy $DRP_PFS_DATA_DIR/detectorMap/detectorMap-2019Jul-*

bash pfs_build_calibs.sh -n -c ${cores} -C ${calibDir} -b visit="${bias_id}" -d visit="${dark_id}" -f visit="${dithered_flat_id}" -F visit="${fiber_trace_id}" -r ${rerun} ${repo}

reduceArc.py ${repo} --calib ${calibDir} --rerun arc --id visit=17244 arm=r -j ${cores}

echo 'processing DONE.'

