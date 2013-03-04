#!/bin/bash
IFS="
"
cat ABOUT.md > ../../README.md
echo "" >> ../../README.md

cat INSTALL.md >> ../../README.md
echo "" >> ../../README.md

cat USAGE.md >> ../../README.md
echo "" >> ../../README.md

cat CONTRIBUTE.md >> ../../README.md
echo "" >> ../../README.md

cat REQUIREMENTS.md >> ../../README.md
echo "" >> ../../README.md

cat TODO.md >> ../../README.md
echo "" >> ../../README.md

cat HOW_THIS_WORKS.md >> ../../README.md
echo "" >> ../../README.md
echo "" >> ../../README.md

echo "" >> ../../README.md
grep -E "(^# |^#$)" ../../caq.sh | cut -d'#' -f2- | cut -d' ' -f2- >> ../../README.md
echo "" >> ../../README.md

echo "" >> ../../README.md
echo "Links" >> ../../README.md
echo "--------------------------------------------------------------------------------" >> ../../README.md
echo "" >> ../../README.md
for linkrow in $(grep -E "^\[" LINKS.md | sort); do
    linktitle=$(echo $linkrow | cut -d'[' -f2 | cut -d']' -f1)
    linkuri=$(echo $linkrow | cut -d':' -f2- | cut -d'"' -f1 | tr -d ' ')
    linkdescr=$(echo $linkrow | cut -d':' -f2- | cut -d'"' -f2 | grep -vE "^ ")
    #echo " + ${link}" >> ../../README.md
    echo " + [${linktitle}] - ${linkdescr}" >> ../../README.md
done

echo "" >> ../../README.md
echo "" >> ../../README.md
cat LINKS.md >> ../../README.md

