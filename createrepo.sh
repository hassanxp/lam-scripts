#!/bin/bash

if [ -z "$1" ]
  then
    echo "Need the name of the repo"
    exit 1
fi

repo="$(pwd)/$1"

if [ -d "${repo}" ] 
then
    echo "Directory '${repo}' already exists."
    exit 1 
fi

## Construct repo
mkdir -p $repo
mkdir -p $repo/CALIB
[ -e $repo/_mapper ] || echo "lsst.obs.pfs.PfsMapper" > $repo/_mapper

echo "Repo '${repo}' created"

