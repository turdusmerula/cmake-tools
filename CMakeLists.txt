cmake_minimum_required(VERSION 2.8)
project(cmake-tools)

#Set build path relative to each project
set(CMAKE_BUILD_DIRECTORY Build/)
set(LIBRARY_OUTPUT_PATH Build/lib)
set(EXECUTABLE_OUTPUT_PATH Build/bin)

#Set default compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

SET_PROPERTY(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CTEST_LAUNCH_COMPILE}")

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	#Compile with debug flags
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g3 -O0")
elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
	#Compile withe optimisations on, -O3 mode si not recommended
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
elseif(CMAKE_BUILD_TYPE STREQUAL "gcov")
    #Compile with gcov to get code coverage informations
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage")
	set(COVERAGE_COMMAND "${COVERAGE_COMMAND} /usr/bin/gcov")
elseif(PROFILE_TYPE STREQUAL "valgrind")
	set(CTEST_MEMORYCHECK_COMMAND "/usr/bin/valgrind")
	set(CTEST_MEMORYCHECK_COMMAND_OPTIONS "--trace-children=yes --quiet --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=100 --verbose --demangle=yes")
elseif(CMAKE_BUILD_TYPE STREQUAL "ftrace")
    #TODO
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -fprofile-arcs -ftest-coverage")
endif()


message("Build type ${CMAKE_BUILD_TYPE}")
message("Profile type ${PROFILE_TYPE}")

#Build sub projects
add_subdirectory(libhello)
add_subdirectory(helloworld)

#Enable tests
include( CTest )
add_subdirectory(libhello/tests/tu)
add_subdirectory(helloworld/tests/perfo)
add_subdirectory(helloworld/tests/tu)
