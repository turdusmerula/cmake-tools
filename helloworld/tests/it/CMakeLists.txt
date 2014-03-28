cmake_minimum_required(VERSION 2.8)
project(helloworld-integration-test)

#Set build path relative to each project
set(CMAKE_BUILD_DIRECTORY Build/)
set(LIBRARY_OUTPUT_PATH Build/lib)
set(EXECUTABLE_OUTPUT_PATH Build/bin)

set(CMAKE_BUILD_DIRECTORY Build/)
set(EXECUTABLE_OUTPUT_PATH Build/bin)

include_directories(
	src
)

FILE(GLOB sources src/*.cpp)

add_executable(${PROJECT_NAME} ${sources})
target_link_libraries(${PROJECT_NAME} cppunit )

#Add test to be run by ctest
enable_testing()
add_test(tests ${PROJECT_NAME})
