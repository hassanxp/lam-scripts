#!/usr/bin/bash

dirName=$(dirname "$0")
echo "sourcing ${dirName}/common.sh .."
source ${dirName}/common.sh
echo "source done."

#set -evx
for ((visit=start_arc; visit<=end_arc; visit++)); do
   echo "processing arc visit: ${visit}"
   reduceArc.py ${repo} --calib ${calibDir} --rerun ${rerun} --id visit=${visit} arm=r -c identifyLines.matchRadius=1.0 -j ${cores} || exit 1
   #detrend.py ${repo} --calib ${calibDir} --rerun ${rerun} --id visit=${visit} arm=r -c isr.doWrite=True --doraise || exit 1
   #reduceExposure.py ${repo} --calib ${repo}/CALIB --rerun ${rerun} --id visit=${visit} arm=r --doraise  || exit 1
done

echo 'processing DONE.'

