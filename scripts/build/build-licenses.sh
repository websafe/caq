#!/bin/bash
# Compiles profiles into a format that can be added
# at the end of caq.sh and then parsed by bash functions.
IFS="
"
for licenseSource in ../../source/templates/licenses/*.md; do
    licenseName=$(basename $licenseSource .md)
    licenseContent="$(cat ${licenseSource})"
    echo $licenseName
    echo $licenseSource
    echo "$licenseContent"  | sed \
	-e "s/^/### LT:${licenseName}:/g"
    #echo "$profileContent";
    echo "###"
    echo "###"
done
