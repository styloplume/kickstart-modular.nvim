Once CMakeLists.txt is edited and ready :
mkdir build
cd build
cmake .. -G Ninja (choco install ninja if necessary)
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .. -G Ninja (to generate compile commands)
cmake --build .
