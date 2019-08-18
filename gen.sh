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


mkdir -p include/$proj_name
mkdir src
mkdir app
mkdir test
mkdir extern
mkdir docs

# TODO: google test
# TODO: submodule little-utility


# .gitignore
touch .gitignore
echo build > .gitignore

# README.md
touch README.md
echo "# $proj_name" > README.md

# CMakwLists.txt
touch CMakeLists.txt
echo "cmake_minimum_required(VERSION 3.7)" | tee -a CMakeLists.txt > /dev/null
echo "project($proj_name VERSION 1.0 LANGUAGES CXX)" | tee -a CMakeLists.txt > /dev/null
echo "add_subdirectory(src)" | tee -a CMakeLists.txt > /dev/null
echo "add_subdirectory(app)" | tee -a CMakeLists.txt > /dev/null

cd src
touch CMakeLists.txt
cd ..

cd app
touch CMakeLists.txt
echo "add_executable($exe_name $exe_name.cc)"  | tee -a CMakeLists.txt > /dev/null
echo "set_target_properties($exe_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY \${PROJECT_BINARY_DIR})" | tee -a CMakeLists.txt > /dev/null
touch $exe_name.cc
echo "int main(int argc, const char** argv)\n{\n  \n  return 0;\n}" | tee $exe_name.cc > /dev/null
cd ..

# git
git init
git add *
git commit -m "init"
# TODO: ask for repo url

echo "cmake project "$proj_name" is successfully created!"