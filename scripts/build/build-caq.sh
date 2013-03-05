#!/bin/bash
# Compiles profiles into a format that can be added
# at the end of caq.sh and then parsed by bash functions.
IFS="
"

OUTPUTFILE=caq.sh

cat ../../source/caq-core.sh > ./${OUTPUTFILE}.tmp
./build-profiles.sh >> ./${OUTPUTFILE}.tmp
./build-licenses.sh >> ./${OUTPUTFILE}.tmp
./build-templates.sh >> ./${OUTPUTFILE}.tmp
echo -n "### EOF" >> ./${OUTPUTFILE}.tmp
#chmod +x ./${OUTPUTFILE}.tmp
cat ./${OUTPUTFILE}.tmp \
    | sed -e "s/\t/    /g" -e "s/ $//g" \
    > ./${OUTPUTFILE}.tmp2
chmod +x ./${OUTPUTFILE}.tmp2
mv -v ./${OUTPUTFILE}.tmp2 ../../${OUTPUTFILE}
rm ./${OUTPUTFILE}.tmp
