cmake_minimum_required(VERSION 3.5)

project(cmake-tools)

# installing
install(PROGRAMS ecmake DESTINATION bin)
install(PROGRAMS ectest DESTINATION bin)
install(PROGRAMS ecpack DESTINATION bin)
install(PROGRAMS cmake/configure.cmake DESTINATION lib/ecmake)
