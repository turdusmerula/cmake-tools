cmake_minimum_required(VERSION 2.8)
project(helloworld-test)

include_directories(
	src
)

FILE(GLOB sources src/*.cpp)

add_executable(${PROJECT_NAME} ${sources})
target_link_libraries(${PROJECT_NAME} cppunit )

#Add test to be run by ctest
add_test(tests Build/bin/${PROJECT_NAME})
