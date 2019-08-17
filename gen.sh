#!/bin/zsh

proj_name=$1
proj_dir=$2

if [ $# -ne 2 ]; then
  echo "error: wrong number of arguments!"
  echo "usage:\n  gen <project name> <project dir>"
  exit 1
fi

echo "Project is named as: $proj_name"
echo "Project will be created in: $proj_dir"

if [ -d $proj_dir ]; then
  echo "$proj_dir already exists! exit now"
  exit 1
fi

mkdir $proj_dir

cp LICENSE $proj_dir

cd $proj_dir

touch CMakeLists.txt

touch .gitignore
echo build > .gitignore


echo "cmake project "$proj_name" is successfully created!"