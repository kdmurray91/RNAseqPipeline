#!/bin/bash

# source common function script
scriptdir="$(dirname $(readlink -f $0))"
basedir="$scriptdir/../"

source "$basedir/common.sh"


######### Setup ################
keyfile=$1

# kefile format: (tab seperated)
#Ordinal	Sample	<factor1_name> [<factor2_name>]


########## Run #################
# sort keyfile. -n make the header line come at the start, if it starts with a letter
sort -o $keyfile -k1n $keyfile

function getSamples() {
	grep -iv Ordinal < $keyfile | cut -f 2
}

echo "Samples are:"
echo "$(getSamples)"

cat $0
## enter steps ##

# step 1: from raw reads until counts
mkdir -p ./log/1-until_counts/
cat ${scriptdir}/1-until_counts.sh
getSamples |parallel "bash ${scriptdir}/1-until_counts.sh {} >./log/1-until_counts/{}.log 2>&1"


# step 2: differential expression
mkdir -p ./de
cat ${scriptdir}/edgeR-kmhons.R
R -f ${scriptdir}/edgeR-kmhons.R --args $keyfile >./log/de.log
