#!/bin/zsh

proj_name=$1
proj_dir=$2
exe_name=$3

if [ $# -ne 3 ]; then
  echo "error: wrong number of arguments!"
  echo "usage:\n  gen <project name> <project dir> <exe_name>"
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

# TODO: use a seris `read` to configure


# include/
mkdir -p include/$proj_name

# src/
mkdir src
cd src
touch CMakeLists.txt
# TODO: ask if user builds lib and ask for lib name
cd ..

# app/
mkdir $exe_name
cd $exe_name
touch CMakeLists.txt
touch $exe_name.cc
cd ..

# test/
mkdir test

# extern/
mkdir extern
# TODO: put google test here

# docs/
mkdir docs

# .gitignore
touch .gitignore
echo build > .gitignore

# README.md
touch README.md
echo "# $proj_name" > README.md

# CMakwLists.txt
touch CMakeLists.txt

# TODO: git init


echo "cmake project "$proj_name" is successfully created!"