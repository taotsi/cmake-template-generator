#!/bin/zsh

proj_name=$1
proj_dir=$2
exe_name=$1
test_name=test_${exe_name}
lib_name=lib${exe_name}
generator_dir=$(pwd)

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
cp update_extern.sh $proj_dir
cp update_extern.cmd $proj_dir

cd $proj_dir
proj_dir=$(pwd)

mkdir -p include/$proj_name
mkdir src
mkdir test
mkdir extern
mkdir docs
mkdir build

touch .gitignore
echo build > .gitignore

touch README.md
echo "# $proj_name" > README.md

include_dir=\${PROJECT_SOURCE_DIR}/include/$proj_name
include_dir_utility=\${PROJECT_SOURCE_DIR}/extern/little-utility/
include_dir_catch2=\${PROJECT_SOURCE_DIR}/extern/catch2

touch CMakeLists.txt
echo "\
cmake_minimum_required(VERSION 3.7)

project($proj_name VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(include_dir ${include_dir})
set(utility_dir ${include_dir_utility})
set(catch2_dir ${include_dir_catch2})

add_subdirectory(src)
add_subdirectory(test)

enable_testing()
add_test(
  NAME $test_name
  COMMAND $<TARGET_FILE:$test_name> --success
)
" | tee -a CMakeLists.txt > /dev/null

cd include/$proj_name
touch ${proj_name}.hh
cd ../..

cd src

touch CMakeLists.txt
echo "\
add_library($lib_name ${proj_name}.cc)

target_include_directories($lib_name PUBLIC \${include_dir})
target_include_directories($lib_name PUBLIC \${utility_dir})

if(MSVC)
  set_target_properties($lib_name PROPERTIES ARCHIVE_OUTPUT_DIRECTORY  ${PROJECT_BINARY_DIR})
  set_target_properties($lib_name PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${PROJECT_BINARY_DIR})
  set_target_properties($lib_name PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${PROJECT_BINARY_DIR})
else()
  set_target_properties($lib_name PROPERTIES ARCHIVE_OUTPUT_DIRECTORY  ${PROJECT_BINARY_DIR})
endif(MSVC)

add_executable($exe_name main.cc)

target_include_directories($exe_name PUBLIC \${include_dir})
target_include_directories($exe_name PUBLIC \${utility_dir})

target_link_libraries($exe_name PRIVATE $lib_name)

if(MSVC)
  set_target_properties($exe_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
  set_target_properties($exe_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_BINARY_DIR})
  set_target_properties($exe_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_BINARY_DIR})
else()
  set_target_properties($exe_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
endif(MSVC)
" | tee -a CMakeLists.txt > /dev/null

touch main.cc
echo "\
#include \"utility.hh\"

using namespace taotsi;

int main(int argc, const char** argv)
{

  return 0;
}
" | tee main.cc > /dev/null

touch ${proj_name}.cc

cd ..

cd test
echo "\
add_executable($test_name test_main.cc $test_name.cc)

target_include_directories($test_name PUBLIC \${include_dir})
target_include_directories($test_name PUBLIC \${catch2_dir})
target_include_directories($test_name PUBLIC \${utility_dir})

target_link_libraries($test_name PRIVATE $lib_name)

if(MSVC)
  set_target_properties($test_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
  set_target_properties($test_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_BINARY_DIR})
  set_target_properties($test_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_BINARY_DIR})
else()
  set_target_properties($test_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
endif(MSVC)
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

cp -r ${generator_dir}/extern $proj_dir

echo ${generator_dir}/extern
echo $proj_dir

git init

git add --all
git commit -m "init"

echo "cmake project "$proj_name" is successfully created!"