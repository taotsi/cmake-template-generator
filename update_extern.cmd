REM @echo off
cd extern/
if exist temp rmdir Catch2 /s /q
if exist catch2 rmdir catch2 /s /q
mkdir temp
cd temp
git clone https://github.com/catchorg/Catch2.git
cd ..
mkdir catch2
move temp/Catch2/single_include/catch2/catch.hpp ./catch2/
rmdir temp /s /q

rmdir little-utility /s /q
mkdir temp
cd temp
git clone https://github.com/taotsi/little-utility.git
cd ..
move temp/little-utility/include/little-utility ./
rmdir temp /s /q

cd ..
