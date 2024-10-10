#!/bin/sh

# set up timezone
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone

# disable wildcard (*) expansion
set -o noglob

# save the original IFS
OLD_IFS=$IFS

# set IFS to the delimiter
IFS=":"

# read the input string into an array-like structure
set -- $ACTUAL_HELPERS_TASKS

# restore original IFS
IFS=$OLD_IFS

# iterate over the components
echo "Adding the following tasks to the crontab:"
i=1
for component in "$@"; do
    echo "    $component"
    echo $component >> /usr/src/app/crontab
    i=$(($i+1))
done

# load crontab for the `node` user
crontab -u node /usr/src/app/crontab

# run cron in the foreground
crond -f
