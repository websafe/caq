#!/bin/bash
# Compiles profiles into a format that can be added
# at the end of caq.sh and then parsed by bash functions.
IFS="
"
for profilesource in ../../source/profiles/*.profile; do
    profileName=$(basename $profilesource .profile)
    profileContent=$(cat ${profilesource})
    echo "$profileContent"  | sed \
	-e "s/^SA:/SA:${profileName}:/g" \
	-e "s/^PKG:/PKG:${profileName}:/g" \
	-e "s/^PKGD:/PKGD:${profileName}:/g" \
	-e "s/^/### /g"
    #echo "$profileContent";
    echo "###"
    echo "###"
done
