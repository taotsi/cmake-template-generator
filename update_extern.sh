#!/bin/zsh

cd extern/
rm -rf Catch2
rm -rf catch2

wget https://raw.githubusercontent.com/catchorg/Catch2/master/single_include/catch2/catch.hpp
mkdir catch2
mv catch.hpp ./catch2/

rm -rf little-utility
mkdir temp
cd temp
git clone https://github.com/taotsi/little-utility.git
cd ..
mv temp/little-utility/include/little-utility ./
rm -rf temp