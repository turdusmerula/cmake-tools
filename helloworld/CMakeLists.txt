cmake_minimum_required(VERSION 2.8)
project(helloworld)

#Set build path relative to each project
set(CMAKE_BUILD_DIRECTORY Build/)
set(LIBRARY_OUTPUT_PATH Build/lib)
set(EXECUTABLE_OUTPUT_PATH Build/bin)

#Add included packages here
find_package(Boost 1.53 COMPONENTS filesystem regex system REQUIRED)

#Include directories
include_directories(
	${Boost_INCLUDE_DIR}
	src
	../libhello/src
)

#Libraries to link
LINK_DIRECTORIES(${Boost_LIBRARY_DIRS})

#Source and header files
FILE(GLOB sources src/*.cpp)
FILE(GLOB headers src/*.h)

add_executable(${PROJECT_NAME} ${sources})
target_link_libraries(${PROJECT_NAME} libhello)
