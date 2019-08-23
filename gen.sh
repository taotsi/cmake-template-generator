#!/bin/zsh

proj_name=$1
proj_dir=$2
exe_name=$1
test_name=${exe_name}_test

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
mkdir test
mkdir extern
mkdir docs
mkdir build

# TODO: google test

touch .gitignore
echo build > .gitignore

touch README.md
echo "# $proj_name" > README.md

include_dir=\${PROJECT_SOURCE_DIR}/include/$proj_name
include_dir_utility=\${PROJECT_SOURCE_DIR}/extern/little-utility/include/little-utility
include_dir_catch2=\${PROJECT_SOURCE_DIR}/extern/Catch2/single_include/catch2

touch CMakeLists.txt
echo "\
cmake_minimum_required(VERSION 3.7)
project($proj_name VERSION 1.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_subdirectory(src)
add_subdirectory(test)
enable_testing()
add_test(
  NAME $test_name
  COMMAND $<TARGET_FILE:$test_name> --success
)
" | tee -a CMakeLists.txt > /dev/null

cd src
touch CMakeLists.txt
echo "\
add_executable($exe_name main.cc)
target_include_directories($exe_name PUBLIC $include_dir)
target_include_directories($exe_name PUBLIC $include_dir_utility)

set_target_properties($exe_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY \${PROJECT_BINARY_DIR})
" | tee -a CMakeLists.txt > /dev/null

touch main.cc
echo "\
#include \"utility.hh\"

int main(int argc, const char** argv)
{

  return 0;
}
" | tee main.cc > /dev/null
cd ..

cd test
echo "\
add_executable($test_name test_main.cc $test_name.cc)
target_include_directories($test_name PUBLIC $include_dir)
target_include_directories($test_name PUBLIC $include_dir_catch2)
set_target_properties($test_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY \${PROJECT_BINARY_DIR})
" | tee -a CMakeLists.txt > /dev/null

touch test_main.cc
echo "\
#define CATCH_CONFIG_MAIN
#include \"catch.hpp\"
" | tee -a test_main.cc > /dev/null

touch $test_name.cc
echo "\
#include \"catch.hpp\"
" | tee -a $test_name.cc > /dev/null

cd ..

# repo
git init

cd extern
git submodule add https://github.com/taotsi/little-utility
git submodule add https://github.com/catchorg/Catch2
cd ..

git add --all
git commit -m "init"

# TODO: ask for repo url

# cd build
# cmake ..
# cmake --build .

echo "cmake project "$proj_name" is successfully created!"