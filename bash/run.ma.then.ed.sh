#!/bin/bash
cd ~/pecan
./bash/meta.analysis.sh $1
wait
./bash/write.configs.sh $1
wait
./bash/start.runs.sh $1