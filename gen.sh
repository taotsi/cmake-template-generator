#!/bin/zsh

proj_name=$1
proj_dir=$2
exe_name=$1

if [ $# -eq 2 ]; then
  exe_name=$1
elif [ $# -eq 3 ]; then
  exe_name=$3
else
  echo "error: wrong number of arguments!"
  echo "usage:\n  gen <project name> <project dir> [exe_name]"
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

touch .gitignore
echo build > .gitignore

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
echo "target_include_directories($exe_name PUBLIC \${PROJECT_SOURCE_DIR}/extern/little-utility/include/little-utility)" | tee -a CMakeLists.txt > /dev/null
echo "target_include_directories($exe_name PUBLIC \${PROJECT_SOURCE_DIR}/include/$proj_name)" | tee -a CMakeLists.txt > /dev/null
echo "target_include_directories($exe_name PUBLIC \${PROJECT_SOURCE_DIR}/extern/Catch2/single_include/catch2)" | tee -a CMakeLists.txt > /dev/null

echo "set_target_properties($exe_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY \${PROJECT_BINARY_DIR})" | tee -a CMakeLists.txt > /dev/null
touch $exe_name.cc
echo "#include \"utility.hh\"\n\nint main(int argc, const char** argv)\n{\n  \n  return 0;\n}" | tee $exe_name.cc > /dev/null
cd ..
# TODO: build test

# repo
git init

cd extern
git submodule add https://github.com/taotsi/little-utility
git submodule add https://github.com/catchorg/Catch2
cd ..

git add --all
git commit -m "init"

mkdir build

# TODO: ask for repo url

echo "cmake project "$proj_name" is successfully created!"