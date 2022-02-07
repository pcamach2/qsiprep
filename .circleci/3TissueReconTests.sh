#!/bin/bash

cat << DOC

Reconstruction workflow tests
=============================

All supported reconstruction workflows get tested

This tests the following features:
 - Blip-up + Blip-down DWI series for TOPUP/Eddy
 - Eddy is run on a CPU
 - Denoising is skipped
 - A follow-up reconstruction using the dsi_studio_gqi workflow

Inputs:
-------

 - qsiprep single shell results (data/DSDTI_fmap)
 - qsiprep multi shell results (data/DSDTI_fmap)

DOC

source ./get_data.sh
TESTDIR=${PWD}
get_config_data ${TESTDIR}
get_bids_data ${TESTDIR} singleshell_output
get_bids_data ${TESTDIR} multishell_output
CFG=${TESTDIR}/data/nipype.cfg
EDDY_CFG=${TESTDIR}/data/eddy_config.json
export FS_LICENSE=${TESTDIR}/data/license.txt

# Test 3tissue with ACT
TESTNAME=mrtrix_singleshell_ss3t_test
setup_dir ${TESTDIR}/${TESTNAME}
TEMPDIR=${TESTDIR}/${TESTNAME}/work
OUTPUT_DIR=${TESTDIR}/${TESTNAME}/derivatives
BIDS_INPUT_DIR=${TESTDIR}/data/singleshell_output/qsiprep

qsiprep-docker -i pennbbl/qsiprep:latest \
	-e qsiprep_DEV 1 -u $(id -u) \
	--config ${CFG} ${PATCH} -w ${TEMPDIR} \
	 ${BIDS_INPUT_DIR} ${OUTPUT_DIR} \
	 participant \
	 --recon-input ${BIDS_INPUT_DIR} \
	 --sloppy \
	 --recon-spec mrtrix_singleshell_ss3t \
	 --recon-only \
	 --mem_mb 4096 \
	 --nthreads 1 -vv


# Test 3tissue without ACT
TESTNAME=mrtrix_singleshell_ss3t_noACT_test
setup_dir ${TESTDIR}/${TESTNAME}
TEMPDIR=${TESTDIR}/${TESTNAME}/work
OUTPUT_DIR=${TESTDIR}/${TESTNAME}/derivatives
BIDS_INPUT_DIR=${TESTDIR}/data/singleshell_output/qsiprep

qsiprep-docker -i pennbbl/qsiprep:latest \
	-e qsiprep_DEV 1 -u $(id -u) \
	--config ${CFG} ${PATCH} -w ${TEMPDIR} \
	 ${BIDS_INPUT_DIR} ${OUTPUT_DIR} \
	 participant \
	 --recon-input ${BIDS_INPUT_DIR} \
	 --sloppy \
	 --recon-spec mrtrix_singleshell_ss3t_noACT \
	 --recon-only \
	 --mem_mb 4096 \
	 --nthreads 1 -vv
