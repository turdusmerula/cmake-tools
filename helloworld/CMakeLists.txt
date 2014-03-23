cmake_minimum_required(VERSION 2.8)
project(helloworld)

#Add included packages here
find_package(Boost 1.53 COMPONENTS filesystem regex system REQUIRED)

#Include directories
include_directories(
	${Boost_INCLUDE_DIR}
	src
)

#Libraries to link
LINK_DIRECTORIES(${Boost_LIBRARY_DIRS})

#Source and header files
FILE(GLOB sources src/*.cpp)
FILE(GLOB headers src/*.h)

#Build Tests
add_subdirectory(tests/tu)
add_subdirectory(tests/perfo)
