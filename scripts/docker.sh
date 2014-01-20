#!/bin/bash

set -e
set -x

uname -a

work=$(dirname $(readlink --canonicalize $(dirname "$0")))

docker -d -H tcp://localhost &
sleep 1
job_id=$!

cd $work
ls -1

kill -9 $job_id

sleep 1
ps -auxf

echo "DONE"

exit 0

