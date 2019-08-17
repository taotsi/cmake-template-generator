#!/bin/zsh

if [ $# -ne 2 ]; then
  echo "error: wrong number of arguments!"
  echo "usage:\n  gen <project_name> <project_dir>"
  exit 1
fi

proj_name=$1
proj_dir=$2

# TODO: test if project_dir exists already
mkdir $proj_dir
cd $proj_dir

touch CMakeLists.txt
