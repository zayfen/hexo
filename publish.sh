#!/bin/bash

./build_deploy.sh

timestamp () {
  date +"%T" 
}

git add .
git commit -m "PUBLISH: $(timestamp)"
git push
