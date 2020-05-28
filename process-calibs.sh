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

ingest_raw_calibs=y
if [ "$ingest_raw_calibs" == "n" ] ; then
    echo 'SKIPPING ingesting raw'
else
    # Ingest raw 'RefDataSet's for bias/dark/flats
    ingestPfsImages.py ${repo} --mode=link \
        ${rawData}/2019-04-26/PFLA0*.fits \
        -c clobber=True register.ignore=True --pfsConfigDir=${pfsConfigDir}
fi

ingest_raw_arc=y
if [ "$ingest_raw_arc" == "n" ] ; then
    echo 'SKIPPING ingesting raw arcs'
else
    # Ingest raw arcs of interest (visit=17244 etc)
    #dates='2019-05-07'
    dates='2019-05-07 2019-07-25 2019-07-26'
    for date in ${dates}; do 
        ingestPfsImages.py ${repo} --mode=link \
            ${rawData}/${date}/PFLA0*.fits \
            -c clobber=True register.ignore=True --pfsConfigDir=${pfsConfigDir}
    done
fi

# Ingest recent detectormaps
ingestPfsCalibs.py ${repo}  --calib ${calibDir} --validity 1000 --mode=copy $DRP_PFS_DATA_DIR/detectorMap/detectorMap-2019Jul-*
#ingestCalibs.py ${repo}  --calib ${calibDir} --validity 1000 --mode=copy $DRP_PFS_DATA_DIR/detectorMap/detectorMap-2019Jul-*

# Generate and ingest bootstrap data
bootstrapDetectorMap.py ${repo} --calib ${repo}/CALIB --rerun ${rerun} --flatId ${bootstrap_flat_id} --arcId ${start_arc_id} -c matchRadius=0.5
ingestCalibs.py ${repo} --calib ${repo}/CALIB --calib ${repo}/CALIB --validity 1000 --mode=copy ${repo}/rerun/${rerunDir}/DETECTORMAP/pfsDetectorMap-*.fits --config clobber=True

set -vx
bash pfs_build_calibs.sh -n -c ${cores} -C ${calibDir} -b "${bias_id}" -d "${dark_id}" -f "${dithered_flat_id}" -F "${fiber_trace_id}" -r ${rerun} ${repo}
#bash pfs_build_calibs.sh -n -c ${cores} -C ${calibDir} -b "${bias_id}" -d "${dark_id}" -f "${dithered_flat_id}" -r ${rerun} ${repo}
echo 'processing DONE.'

