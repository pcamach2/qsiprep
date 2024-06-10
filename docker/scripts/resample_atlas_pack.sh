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
        # Make labels to add to atlas_config.json
        echo "Creating labels for ${atlas_label}" && \
            # Extract index and label from .tsv file from AtlasPack
            tsv_file="/AtlasPack/atlas-*${atlas_label}*dseg.tsv"
            # Generate JSON entry with file, node_names, node_ids
            file_name="tpl-MNI152NLin2009cAsym_res-01_atlas-${atlas_label}_desc-LPS_dseg.nii.gz"
            echo "{ \"file\": ${file_name}" > /AtlasPack/lps/${atlas_label}.json
            # Extract the label label_data from the column based on the column name
            label_data=$(awk -v colname="label" 'BEGIN { FS="\t"; } { for (i=1; i<=NF; i++) { if ($i == colname) { col=i; break; } } } NR>1 { print $col; }' $tsv_file)
            # Write the label_data to the output JSON file, with the column name as the key
            echo "\"node_names\": [" >> /AtlasPack/lps/${atlas_label}.json
            for d in $label_data; do
            echo "\"$d\"," >> /AtlasPack/lps/${atlas_label}.json
            done
            echo "]" >> ${atlas_label}.json
            index_data=$(awk -v colname="index" 'BEGIN { FS="\t"; } { for (i=1; i<=NF; i++) { if ($i == colname) { col=i; break; } } } NR>1 { print $col; }' $tsv_file)
             # Write the index_data to the output JSON file, with the column name as the key
            echo "\"node_ids\": [" >> /AtlasPack/lps/${atlas_label}.json
            for dd in $index_data; do
            echo $dd, >> /AtlasPack/lps/${atlas_label}.json
            done
            echo "]" >> /AtlasPack/lps/${atlas_label}.json
            echo "}" >> /AtlasPack/lps/${atlas_label}.json
    done

# Add label json data to atlas_config.json
for atlas_label in `ls /AtlasPack/lps/*json`;
    # combine the 4SX56 atlas label jsons into atlas_config.json
done


# Copy NIFTIs and atlas_config.json to atlases
cp /AtlasPack/lps/* /atlases/
