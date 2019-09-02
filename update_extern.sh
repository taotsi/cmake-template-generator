#!/bin/zsh

cd extern/
rm -rf Catch2
rm -rf catch2
mkdir temp
cd temp
git clone https://github.com/catchorg/Catch2.git
cd ..
mkdir catch2
mv temp/Catch2/single_include/catch2/catch.hpp ./catch2/
rm -rf temp

rm -rf little-utility
mkdir temp
cd temp
git clone https://github.com/taotsi/little-utility.git
cd ..
mv temp/little-utility/include/little-utility ./
rm -rf temp