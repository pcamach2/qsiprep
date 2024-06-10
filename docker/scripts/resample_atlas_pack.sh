#!/bin/bash
# Resample the Atlas-Pack 1mm resolution atlases to LPS and add to qsirecon_atlases folder

# Make directory for resampled atlases only
mkdir /AtlasPack/lps
cd /AtlasPack/lps
# Resample to MNI space LPS orientation
for atlas_file in `ls /AtlasPack/tpl-MNI152NLin2009cAsym_*res-01*nii.gz`;
    do echo "Resampling ${atlas_file}" \
        && atlas_label=`echo ${atlas_file} | cut -d_ -f2 | cut -d- -f2` \ 
        && 3dresample -input /AtlasPack/${atlas_file} \
        -master /atlases/mni_1mm_t1w_lps.nii.gz \
        -prefix /AtlasPack/lps/tpl-MNI152NLin2009cAsym_res-01_atlas-${atlas_label}_desc-LPS_dseg.nii.gz; \
    done

# Make labels to add to atlas_config.json

# Copy NIFTIs to atlases
cp /AtlasPack/lps/* /atlases/
