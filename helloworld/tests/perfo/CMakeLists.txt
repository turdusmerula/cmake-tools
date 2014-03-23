#Those tests are disabled by default

cmake_minimum_required(VERSION 2.8)
project(helloworld-perfo)

include_directories(
	src
)

FILE(GLOB sources src/*.cpp)

add_executable(${PROJECT_NAME} ${sources})
target_link_libraries(${PROJECT_NAME} cppunit )
