#!/bin/bash

#Build script version 1.0.0

#TODO: add target to build rpm/deb/... install packet
#TODO: add ftrace
#TODO: add an update from github of tools

function usage()
{
	echo "$0 [<targets> ...]"
	echo "Available targets:"
	echo "    clean:         clean sources" 
	echo "    depclean:      clean sources and makefiles" 
	echo "    test:          rum unit tests" 
	echo "    perfo:         run performance tests" 
	echo "    cdash:         perform unit tests with gcov and send results to cdash" 
	echo "    eclipse:       generate eclipse projet" 
	echo "	  upgrate:		 upgrade tools with latest version from github"
	echo "Build options:"
	echo "    debug/release: build with debuging informations or not" 
	echo "    clang:         build with clang instead of gcc" 
	echo "    gcov:          add covering informations, imply debug" 
	echo "    valgrind:      run valgrind tests, imply debug" 
	echo "    callgrind:     run callgrind tests, imply debug" 
	echo "    ftrace:        run callgrind tests, imply debug" 
	echo "    verbose:       enable verbose mode" 
	echo
	echo "help: output command help and quit" 
	exit 0
}
possible_args="clean depclean test perfo cdash eclipse debug release clang gcov valgrind callgrind ftrace verbose help"

function clean()
{
	make clean	
}

function depclean()
{
	find . -type d -name Build -exec rm -rf {} \;
	find . -type d -name CMakeFiles -exec rm -rf {} \;
	find . -type d -name _CPack_Packages -exec rm -rf {} \;
	find . -type d -name Testing -exec rm -rf {} \;
	find . -type f -name install_manifest.txt -exec rm -f {} \;
	find . -type f -name Makefile -exec rm -f {} \;
	find . -type f -name CMakeCache.txt -exec rm -f {} \;
	find . -type f \( -name "*.cmake" ! -name "CTestConfig.cmake" \) -exec rm -f {} \;
	find . -type f -name "*.db" -exec rm -f {} \;
	find . -type f -name "*.defs" -exec rm -f {} \;
	find . -type f -name "DartConfiguration.tcl" -exec rm -f {} \;
		rm -rf lib*.deb Testing
	rm -rf tmp
}

#valgrind_memcheck="/usr/bin/valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --callgrind-out-file=../../Testing/callgrind.out.%p"
valgrind_callgrind="/usr/bin/valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --callgrind-out-file=../../Testing/callgrind.out.%p"

#Performance tests 
function performance_tests()
{
	echo	
}

#Unit tests
function unit_tests()
{
	#	$command_opts ctest -V		
	$command_opts make test		
}

function cdash()
{
	$command_opts ctest -V -D Experimental -D NightlyMemCheck
}

function eclipse()
{
	cmake . -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER_ARG1=-std=c++11
}

function upgrade()
{
	wget https://raw.githubusercontent.com/turdusmerula/ftrace/master/build.sh 	
}

callgrind=0
valgrind=0
perfo=0
test=0

cmake_opts="-DCTEST_USE_LAUNCHERS=ON"
command_opts=""

#test command line arguments
for arg in "$@"
do
	if [[ ! $possible_args =~ $arg ]]
	then
		usage
		exit 1 
	fi
done

#Explore each argument to set options
for arg in "$@"
do
	if [[ "_$arg" == "_debug" ]]
	then
		buildtype=Debug
	elif [[ "_$arg" == "_release" ]]
	then
		buildtype=Release
	elif [[ "_$arg" == "_clang" ]]
	then
		perfo=1
	elif [[ "_$arg" == "_gcov" ]]
	then
		buildtype=gcov
	elif [[ "_$arg" == "_ftrace" ]]
	then
		buildtype=ftrace
	elif [[ "_$arg" == "_callgrind" ]]
	then
		cmake_opts="$cmake_opts -DPROFILE_TYPE=callgrind"
		command_opts="/usr/bin/valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --callgrind-out-file=../../Testing/callgrind.out.%p"
	elif [[ "_$arg" == "_valgrind" ]]
	then
		cmake_opts="$cmake_opts -DPROFILE_TYPE=valgrind"
		valgrind=0
	elif [[ "_$arg" == "_verbose" ]]
	then
		export VERBOSE=1
	fi
done

if [[ "_$buildtype" == "_" ]]
then
	buildtype=Debug
fi

cmake_opts="$cmake_opts -DCMAKE_BUILD_TYPE=$buildtype"

#Build makefiles
cmake . $cmake_opts

target=0
#Explore each argument again to run targets
for arg in "$@"
do
	if [[ "_$arg" == "_clean" ]]
	then
		target=1
		clean
	elif [[ "_$arg" == "_depclean" ]]
	then
		target=1
		depclean
	elif [[ "_$arg" == "_test" ]]
	then
		target=1
		unit_tests
	elif [[ "_$arg" == "_perfo" ]]
	then
		target=1
		performance_tests	
	elif [[ "_$arg" == "_cdash" ]]
	then
		target=1
		cdash
	elif [[ "_$arg" == "_eclipse" ]]
	then
		eclipse
	fi

	if [[ "_$arg" == "_help" ]]
	then
		usage
	fi

done

#Nothing was asked so by default we build the code
if [[ "_$target" == "_0" ]]
then
	make
fi

