#!/bin/bash
IFS="
"
grep -E "^# " ../../caq.sh | cut -d' ' -f2- > ../../README.md
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
echo "Links" >> ../../README.md
echo "--------------------------------------------------------------------------------" >> ../../README.md
echo "" >> ../../README.md
for link in $(grep -E "^\[" LINKS.md); do
    echo " + ${link}" >> ../../README.md
done
echo "" >> ../../README.md
echo "" >> ../../README.md
cat LINKS.md >> ../../README.md
