# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake

# The command to remove a file.
RM = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/kinyang/GitHub/UNIX_Environment_Programming

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/kinyang/GitHub/UNIX_Environment_Programming/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/fileflags.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/fileflags.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/fileflags.dir/flags.make

CMakeFiles/fileflags.dir/fileio/fileflags.cpp.o: CMakeFiles/fileflags.dir/flags.make
CMakeFiles/fileflags.dir/fileio/fileflags.cpp.o: ../fileio/fileflags.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/kinyang/GitHub/UNIX_Environment_Programming/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/fileflags.dir/fileio/fileflags.cpp.o"
	/Library/Developer/CommandLineTools/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/fileflags.dir/fileio/fileflags.cpp.o -c /Users/kinyang/GitHub/UNIX_Environment_Programming/fileio/fileflags.cpp

CMakeFiles/fileflags.dir/fileio/fileflags.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/fileflags.dir/fileio/fileflags.cpp.i"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/kinyang/GitHub/UNIX_Environment_Programming/fileio/fileflags.cpp > CMakeFiles/fileflags.dir/fileio/fileflags.cpp.i

CMakeFiles/fileflags.dir/fileio/fileflags.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/fileflags.dir/fileio/fileflags.cpp.s"
	/Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/kinyang/GitHub/UNIX_Environment_Programming/fileio/fileflags.cpp -o CMakeFiles/fileflags.dir/fileio/fileflags.cpp.s

# Object files for target fileflags
fileflags_OBJECTS = \
"CMakeFiles/fileflags.dir/fileio/fileflags.cpp.o"

# External object files for target fileflags
fileflags_EXTERNAL_OBJECTS =

fileflags: CMakeFiles/fileflags.dir/fileio/fileflags.cpp.o
fileflags: CMakeFiles/fileflags.dir/build.make
fileflags: CMakeFiles/fileflags.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/kinyang/GitHub/UNIX_Environment_Programming/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable fileflags"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/fileflags.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/fileflags.dir/build: fileflags

.PHONY : CMakeFiles/fileflags.dir/build

CMakeFiles/fileflags.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/fileflags.dir/cmake_clean.cmake
.PHONY : CMakeFiles/fileflags.dir/clean

CMakeFiles/fileflags.dir/depend:
	cd /Users/kinyang/GitHub/UNIX_Environment_Programming/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/kinyang/GitHub/UNIX_Environment_Programming /Users/kinyang/GitHub/UNIX_Environment_Programming /Users/kinyang/GitHub/UNIX_Environment_Programming/cmake-build-debug /Users/kinyang/GitHub/UNIX_Environment_Programming/cmake-build-debug /Users/kinyang/GitHub/UNIX_Environment_Programming/cmake-build-debug/CMakeFiles/fileflags.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/fileflags.dir/depend

