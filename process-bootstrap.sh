#!/usr/bin/bash

dirName=$(dirname "$0")
echo "sourcing ${dirName}/common.sh .."
source ${dirName}/common.sh
echo "source done."

set -vx

bootstrapDetectorMap.py ${repo} --calib ${repo}/CALIB --rerun ${rerun} --flatId ${bootstrap_flat_id} --arcId ${start_arc_id} -c matchRadius=0.5
#bootstrapDetectorMap.py ${repo} --calib ${repo}/CALIB --rerun ${rerun} --flatId visit=${flat_visit} --arcId visit=${start_arc} -c matchRadius=0.5
ingestCalibs.py ${repo} --calib ${repo}/CALIB --calib ${repo}/CALIB --validity 1000 --mode=copy ${repo}/rerun/${rerunDir}/DETECTORMAP/pfsDetectorMap-*.fits --config clobber=True
echo 'processing DONE.'

