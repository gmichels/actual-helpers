#!/bin/sh

CRONTAB_DIR=/home/node

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
    echo $component >> $CRONTAB_DIR/crontab
    i=$(($i+1))
done

# load crontab for the `node` user
crontab -u node $CRONTAB_DIR/crontab

# run cron in the foreground
crond -f
