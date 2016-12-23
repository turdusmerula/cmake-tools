cmake_minimum_required(VERSION 3.5)

project(cmake-tools)

# installing
install(PROGRAMS ecmake DESTINATION bin)
install(PROGRAMS ectest DESTINATION bin)
install(PROGRAMS ecpack DESTINATION bin)

install(PROGRAMS cmake/cmake_script.cmake DESTINATION lib/ecmake)
install(PROGRAMS cmake/cpack_script.cmake DESTINATION lib/ecmake)
install(PROGRAMS cmake/ctest_script.cmake DESTINATION lib/ecmake)

install(PROGRAMS scripts/check-ssh DESTINATION share/ecmake)
install(PROGRAMS scripts/get-distribution DESTINATION share/ecmake)
install(PROGRAMS scripts/package-add DESTINATION share/ecmake)
install(PROGRAMS scripts/package-exist DESTINATION share/ecmake)
install(PROGRAMS scripts/package-release DESTINATION share/ecmake)
install(PROGRAMS scripts/package-split DESTINATION share/ecmake)
install(PROGRAMS scripts/ppa-create DESTINATION share/ecmake)
