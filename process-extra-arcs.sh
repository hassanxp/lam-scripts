#!/usr/bin/bash

dirName=$(dirname "$0")
echo "sourcing ${dirName}/common.sh .."
source ${dirName}/common.sh
echo "source done."

#set -evx

visit=21400
# Ingest raw arcs of interest (visit=21274 etc) 
#ingestPfsImages.py ${repo} --mode=link${rawData}/2019-07-25/PFLA0*${visit}*.fits -c clobber=True register.ignore=True --pfsConfigDir=${pfsConfigDir}

reduceArc.py ${repo} --calib ${calibDir} --rerun ${rerun} --id visit=${visit} arm=r -c identifyLines.matchRadius=0.5 -j ${cores} || exit 1
#detrend.py ${repo} --calib ${calibDir} --rerun ${rerun} --id visit=${visit} arm=r -c isr.doWrite=True --doraise || exit 1
#reduceExposure.py ${repo} --calib ${repo}/CALIB --rerun ${rerun} --id visit=${visit} arm=r --doraise  || exit 1

echo 'processing DONE.'

