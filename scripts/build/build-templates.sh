#!/bin/bash
# Compiles profiles into a format that can be added
# at the end of caq.sh and then parsed by bash functions.
IFS="
"
for templateSource in ../../source/templates/*.template; do
    templateName=$(basename $templateSource .template)
    templateContent="$(cat ${templateSource})"
    echo "$templateContent"  | sed \
	-e "s/^/### FT:${templateName}:/g"
    #echo "$profileContent";
    echo "###"
    echo "###"
done
