#!/bin/bash
IFS="
"
echo "" > ../../README.md

cat ../../source/partial-content/ABOUT.md > ../../README.md
echo "" >> ../../README.md

cat ../../source/partial-content/INSTALL.md >> ../../README.md
echo "" >> ../../README.md

cat ../../source/partial-content/USAGE.md >> ../../README.md
echo "" >> ../../README.md

cat ../../source/partial-content/CONTRIBUTE.md >> ../../README.md
echo "" >> ../../README.md

cat ../../source/partial-content/REQUIREMENTS.md >> ../../README.md
echo "" >> ../../README.md

cat ../../source/partial-content/TODO.md >> ../../README.md
echo "" >> ../../README.md

cat ../../source/partial-content/HOW_THIS_WORKS.md >> ../../README.md
echo "" >> ../../README.md

echo "" >> ../../README.md
cat ../../source/partial-content/LICENSE.md >> ../../README.md
grep -E "(^# |^#$)" ../../caq.sh | cut -d'#' -f2- | cut -d' ' -f2- >> ../../README.md
echo "" >> ../../README.md

echo "" >> ../../README.md
echo "Links" >> ../../README.md
echo "--------------------------------------------------------------------------------" >> ../../README.md
echo "" >> ../../README.md
for linkrow in $(grep -E "^\[" ../../source/partial-content/LINKS.md | sort); do
    linktitle=$(echo $linkrow | cut -d'[' -f2 | cut -d']' -f1)
    linkuri=$(echo $linkrow | cut -d':' -f2- | cut -d'"' -f1 | tr -d ' ')
    linkdescr=$(echo $linkrow | cut -d':' -f2- | cut -d'"' -f2 | grep -vE "^ ")
    #echo " + ${link}" >> ../../README.md
    echo " + [${linktitle}] - ${linkdescr}" >> ../../README.md
done

echo "" >> ../../README.md
echo "" >> ../../README.md
cat ../../source/partial-content/LINKS.md >> ../../README.md

