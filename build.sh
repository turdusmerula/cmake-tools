#!/bin/bash

#Build script version 1.0.0
#History:
#Version 1.0.0: first working and released version of the script


#TODO add a configuration file for env path

function usage()
{
	echo "$0 [<targets> ...]"
	echo "Available targets:"
	echo "    clean:         clean sources" 
	echo "    depclean:      clean sources and makefiles" 
	echo "    build:         run all tests" 
	echo "    run-tests:     run all tests" 
	echo "    run-tu:        run unit tests" 
	echo "    run-perfo:     run performance tests" 
	echo "    run-it:        run integration tests" 
	echo "    package:       create source and install packages" 
	echo "    install:       install packages on the system" 
	echo "    cdash:         perform unit tests with gcov and send results to cdash" 
	echo "    eclipse:       generate eclipse project" 
	echo "    upgrade-tools: upgrade tools with latest version from github"
	echo "Build options:"
	echo "    -release:           build with release informations (by default debug build is made with debug informations)" 
	echo "    -clang:             build with clang instead of gcc" 
	echo "    -MemorySanitizer:   use MemorySanitizer tool (available for gcc and clang)" 
	echo "    -AddressSanitizer:  use AddressSanitizer tools (available for gcc and clang)" 
	echo "    -ThreadSanitizer:   use ThreadSanitizer tools (available for gcc and clang)" 
	echo "    -DataFlowSanitizer: use DataFlowSanitizer tools (available for gcc and clang)" 
	echo "    -gcov:              add covering informations, imply debug" 
	echo "    -valgrind:          run tests through valgrind" 
	echo "    -callgrind:         run tests through callgrind" 
	echo "    -ftrace:            add ftrace instrumentation on build and tests" 
	echo "    -ddd:               run tests through ddd debugger"
	echo "    -verbose:           enable verbose mode" 
	echo
	echo "help: output command help and quit" 
	exit 0
}
possible_args="clean depclean build run-tests run-tu run-perfo run-it cdash eclipse upgrade-tools -release -clang -ThreadSanitizer -AddressSanitizer -ThreadSanitizer -DataFlowSanitizer -gcov -valgrind -callgrind -ftrace -verbose -ddd help"

#Options
release=0 
clang=0
MemorySanitizer=0 
AddressSanitizer=0
ThreadSanitizer=0
DataFlowSanitizer=0
gcov=0
callgrind=0
valgrind=0
ftrace=0
verbose=0 
ddd=0

#Targets
clean=0
depclean=0 
build=0
run_tu=0 
run_perfo=0 
run_it=0 
cdash=0 
eclipse=0
upgrade_tools=0

target=0

cmake_opts="-DCTEST_USE_LAUNCHERS=ON"
make_opts=""
command=""
post_command=""

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
	if [[ "_$arg" == "_clean" ]]
	then
		clean=1
		target=1
	elif [[ "_$arg" == "_depclean" ]]
	then
		depclean=1
		target=1
	elif [[ "_$arg" == "_depclean" ]]
	then
		build=1
		target=1
	elif [[ "_$arg" == "_run-tests" ]]
	then
		run_tu=1
		run_perfo=1
		run_it=1
		build=1		
		target=1
	elif [[ "_$arg" == "_run-tu" ]]
	then
		run_tu=1
		target=1
		build=1		
	elif [[ "_$arg" == "_run-perfo" ]]
	then
		run_perfo=1
		target=1
		build=1		
	elif [[ "_$arg" == "_run-it" ]]
	then
		run_it=1
		target=1
		build=1
	elif [[ "_$arg" == "_cdash" ]]
	then
		cdash=1
		target=1
	elif [[ "_$arg" == "_eclipse" ]]
	then
		eclipse=1
		target=1
	elif [[ "_$arg" == "_upgrade-tools" ]]
	then
		upgrade_tools=1
		target=1
	elif [[ "_$arg" == "_-release" ]]
	then
		release=1
	elif [[ "_$arg" == "_-clang" ]]
	then
		clang=1
	elif [[ "_$arg" == "_-MemorySanitizer" ]]
	then
		clang=1
		MemorySanitizer=1
	elif [[ "_$arg" == "_-AddressSanitizer" ]]
	then
		clang=1
		AddressSanitizer=1
	elif [[ "_$arg" == "_-ThreadSanitizer" ]]
	then
		clang=1
		ThreadSanitizer=1
	elif [[ "_$arg" == "_-DataFlowSanitizer" ]]
	then
		clang=1
		DataFlowSanitizer=1
	elif [[ "_$arg" == "_-gcov" ]]
	then
		gcov=1
	elif [[ "_$arg" == "_-valgrind" ]]
	then
		valgrind=1
	elif [[ "_$arg" == "_-callgrind" ]]
	then
		callgrind=1
	elif [[ "_$arg" == "_-ftrace" ]]
	then
		ftrace=1
	elif [[ "_$arg" == "_-verbose" ]]
	then
		verbose=1
	elif [[ "_$arg" == "_-ddd" ]]
	then
		ddd=1
		elif [[ "_$arg" == "_help" ]]
	then
		usage
		exit 0
	fi
done

function custom_clean()
{
	echo -n
}

function custom_depclean()
{
	echo -n
}
	
function custom_performance_tests()
{
	echo -n
}

function custom_unit_tests()
{
	echo -n
}

function custom_integration_tests()
{
	echo -n
}

if [ -f init.sh ]
then
	source init.sh
fi

function clean()
{
	make clean	
	custom_clean
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
	find . -type f -name "cmake_install.cmake" -exec rm -f {} \;
	find . -type f -name "CTestConfig.cmake" -exec rm -f {} \;
	find . -type f -name "CTestTestfile.cmake" -exec rm -f {} \;
	find . -type f -name "*.db" -exec rm -f {} \;
	find . -type f -name "*.defs" -exec rm -f {} \;
	find . -type f -name "DartConfiguration.tcl" -exec rm -f {} \;
	rm -rf lib*.deb Testing
	rm -rf tmp
	
	custom_depclean
}

#Performance tests 
function performance_tests()
{
	find . -type f -name "*-perfo-test" > /tmp/.tests 

	exec 3</tmp/.tests 
	while read -u3 command    
	do    
	    echo "Run performance test $command"    
		cd $(dirname $command)
		./$(basename $command)
		cd -
	done
	
	custom_performance_tests
}

#Unit tests
function unit_tests()
{
	find . -type f -name "*-unit-test" > /tmp/.tests 
	
	exec 3</tmp/.tests 
	while read -u3 command    
	do
	    echo "Run unit test $command"    
		cd $(dirname $command)
		./$(basename $command)
		cd -
	done
	
	custom_unit_tests
}

#Unit tests
function integration_tests()
{
	find . -type f -name "*-integration-test" > /tmp/.tests 
	
	exec 3</tmp/.tests 
	while read -u3 command    
	do    
	    echo "Run integration test $command"    
		cd $(dirname $command)
		./$(basename $command)
		cd -
	done
	
	custom_integration_tests
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
	mv $0 $0.bak
	wget https://raw.githubusercontent.com/turdusmerula/cmake-tools/master/build.sh
	chmod +x build.sh
}

if [ -f init.sh ]
then
	source init.sh 
fi

#Output anything outputted by the test program if the test should fail.
CTEST_OUTPUT_ON_FAILURE=true

if [ $gcov -eq 1 ] || [ $callgrind -eq 1 ] || [ $valgrind -eq 1 ] || [ $ftrace -eq 1 ]
then
	#No build type added in this case
	release=0
	#TODO: add a check to forbing usage of those options at the same time
elif [ $release -eq 1 ]
then
	cmake_opts="$cmake_opts -DCMAKE_BUILD_TYPE=Release"
else
	cmake_opts="$cmake_opts -DCMAKE_BUILD_TYPE=Debug"
fi 

if [ $clang -eq 1 ]
then
	#TODO: add configuration for clang path
	cmake_opts="$cmake_opts -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++"	
fi

if [ $gcov -eq 1 ]
then
	#TODO: add configuration for gcov path
	cmake_opts="$cmake_opts -DCMAKE_CXX_FLAGS:STRING=\"-g -O0 -fprofile-arcs -ftest-coverage\""	
	cmake_opts="$cmake_opts -DCMAKE_C_FLAGS:STRING=\"-g -O0 -fprofile-arcs -ftest-coverage\""	
	cmake_opts="$cmake_opts -DCOVERAGE_COMMAND:STRING=/usr/bin/gcov"	
fi

if [ $valgrind -eq 1 ]
then
	#TODO: add configuration for valgrind path
	command="/usr/bin/valgrind --trace-children=yes --quiet --tool=memcheck --leak-check=yes --show-reachable=yes --num-callers=100 --verbose --demangle=yes"
	cmake_opts="$cmake_opts -DCMAKE_CXX_FLAGS:STRING=\"-g -O0\""	
	cmake_opts="$cmake_opts -DCMAKE_C_FLAGS:STRING=\"-g -O0\""	
fi

if [ $callgrind -eq 1 ]
then
	#TODO: add configuration for valgrind path
	command="/usr/bin/valgrind --tool=callgrind --dump-instr=yes --simulate-cache=yes --callgrind-out-file=Testing/callgrind.out.%p"
	cmake_opts="$cmake_opts -DCMAKE_CXX_FLAGS:STRING=\"-g -O0\""	
	cmake_opts="$cmake_opts -DCMAKE_C_FLAGS:STRING=\"-g -O0\""	
	post_command="kcachegrind $(ls -t -1 Testing/callgrind.out.* | head -n1)"
fi

if [ $ftrace -eq 1 ]
then
	#TODO: add ftrace tool
	echo
fi

if [ $ddd -eq 1 ]
then
	#TODO: add configuration for valgrind path
	command="ddd"
	cmake_opts="$cmake_opts -DCMAKE_BUILD_TYPE=Debug"	
fi

if [ $verbose -eq 1 ]
then
	cmake_opts="$cmake_opts -DCMAKE_VERBOSE_MAKEFILE=ON"
	make_opts="$make_opts VERBOSE=1"
fi

if [ $target -eq 0 ]
then
	build=1
fi
 
if [ $depclean -eq 1 ]
then
	depclean
fi

if [ $clean -eq 1 ]
then
	clean
fi

if [ $build -eq 1 ]
then
	eval "cmake $cmake_opts ."
	make $make_opts	
fi

if [ $run_tu -eq 1 ]
then
	unit_tests
fi

if [ $run_perfo -eq 1 ]
then
	performance_tests
fi

if [ $run_it -eq 1 ]
then
	integration_tests
fi

if [ $cdash -eq 1 ]
then
	cdash
fi

if [ $eclipse -eq 1 ]
then
	eclipse
fi

if [ $upgrade_tools -eq 1 ]
then
	upgrade
fi

$post_command
