#!/bin/bash

profile_path=`printenv PROFILE_PATH`
if [[ ! profile_path ]]; then
	profile_path="/home/docker/profiles"
fi

oldIFS="$IFS"
IFS=$'\n'
results=$( echo "SELECT key FROM server_machinegroup;" | python /home/docker/sal/manage.py dbshell | xargs | awk {'for (i=3; i<NF-1; i++) print $i'} )
read -rd '' -a lines <<<"$results"
IFS=$oldIFS
for line in "${lines[@]}"
do
	if [[ -z $1 ]]; then
		$profile_path/generate_sal_profile.py $line
	else
		$profile_path/generate_sal_profile.py $line --url $1
	fi
done