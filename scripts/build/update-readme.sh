#!/bin/sh

grep -E "^# " ../../caq.sh | cut -d' ' -f2- > ../../README.md
echo "" >> ../../README.md
cat INSTALL.md >> ../../README.md
echo "" >> ../../README.md
cat USAGE.md >> ../../README.md
echo "" >> ../../README.md
cat CONTRIBUTE.md >> ../../README.md
echo "" >> ../../README.md
cat LINKS.md >> ../../README.md
