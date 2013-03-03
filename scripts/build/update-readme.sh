#!/bin/sh

grep -E "^# " ../../caq.sh | cut -d' ' -f2- > ../../README.md
