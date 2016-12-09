cmake_minimum_required(VERSION 2.8)
project(cmake-tools)

#Set build path relative to each project
set(CMAKE_BUILD_DIRECTORY Build/)
set(LIBRARY_OUTPUT_PATH Build/lib)
set(EXECUTABLE_OUTPUT_PATH Build/bin)

SET_PROPERTY(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CTEST_LAUNCH_COMPILE}")

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	#Compile with debug flags
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g3 -O0")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
	#Compile withe optimisations on, -O3 mode si not recommended
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
endif()

#Set default compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")


message("Build type ${CMAKE_BUILD_TYPE}")
message("Compile options ${CMAKE_CXX_FLAGS}")

#Build sub projects
add_subdirectory(libhello)
add_subdirectory(helloworld)

#Enable tests
include( CTest )
add_subdirectory(libhello/tests/ut)
add_subdirectory(helloworld/tests/it)
add_subdirectory(helloworld/tests/perfo)
add_subdirectory(helloworld/tests/ut)
