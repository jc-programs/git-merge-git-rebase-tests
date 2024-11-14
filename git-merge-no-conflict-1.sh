#!/bin/bash

DIR=$(basename "$0" .sh) # DIR contains the name of this script without extension
if [ -d ${DIR} ]; then
  # if dir already exists then do nothing
  exit 1
fi

CURRENT_DIR=$(pwd)
mkdir "${DIR}"
cd "${DIR}"
git init .
# get current branch. Can be master/main or other name set by user in his git config
BRANCH_MASTER=$(git branch --show-current)
BRANCH_OTHER=branch-6-7-8

# content for master/main
for NUMBER in 1 2 3 4 5; do
  echo "content for file ${NUMBER}.java" > "${NUMBER}.java"
  git add .
  git commit -m "add file ${NUMBER}.java"
done

# create new branch but from commit of file 3.java (SHA1 was stored in var SHA_3)
SHA_3=$(git log --oneline | head -n 3 | tail -n 1 | awk '{print $1}')
git checkout -b ${BRANCH_OTHER} ${SHA_3}


# more content
for NUMBER in 6 7 8; do
  echo "content for file ${NUMBER}.java" > "${NUMBER}.java"
  git add .
  git commit -m "add file ${NUMBER}.java"
done

# Merge: no conflict
git merge ${BRANCH_MASTER}

if [ "$1" == "solve" ]; then
  # No conflicts to solve. now we can merge this branch to master
  git checkout ${BRANCH_MASTER}
  git merge ${BRANCH_OTHER}
fi

cd "${CURRENT_DIR}"
