cmake_minimum_required(VERSION 2.8)

project(cmake-tools)

# installing
install(PROGRAMS ecmake DESTINATION bin)
install(PROGRAMS ectest DESTINATION bin)
install(PROGRAMS ecpack DESTINATION bin)

install(PROGRAMS cmake/cmake_script.cmake DESTINATION lib/ecmake)
install(PROGRAMS cmake/cpack_script.cmake DESTINATION lib/ecmake)
install(PROGRAMS cmake/ctest_script.cmake DESTINATION lib/ecmake)

install(PROGRAMS scripts/docker-remove-container DESTINATION bin)
install(PROGRAMS scripts/docker-remove-dangling DESTINATION bin)
install(PROGRAMS scripts/get-distribution DESTINATION bin)
install(PROGRAMS scripts/package-add DESTINATION bin)
install(PROGRAMS scripts/package-exist DESTINATION bin)
install(PROGRAMS scripts/package-release DESTINATION bin)
install(PROGRAMS scripts/package-next-release DESTINATION bin)
install(PROGRAMS scripts/package-split DESTINATION bin)
install(PROGRAMS scripts/ppa-create DESTINATION bin)
install(PROGRAMS scripts/root-check DESTINATION bin)
install(PROGRAMS scripts/ssh-copy-ids DESTINATION bin)
install(PROGRAMS scripts/ssh-publickey-check DESTINATION bin)

install(PROGRAMS scripts/ecpack/ecpack-debian DESTINATION share/cmake-tools/ecpack)
install(PROGRAMS scripts/ecpack/ecpack-docker DESTINATION share/cmake-tools/ecpack)
