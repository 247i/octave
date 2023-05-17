# - Config file for the double-conversion package
# It defines the following variables
# double-conversion_INCLUDE_DIRS
# double-conversion_LIBRARIES

get_filename_component(double-conversion_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

if(EXISTS "${double-conversion_CMAKE_DIR}/CMakeCache.txt")
  include("${double-conversion_CMAKE_DIR}/double-conversionBuildTreeSettings.cmake")
else()
  set(double-conversion_INCLUDE_DIRS "/scratch/build/mxe-octave-w64-32-release/usr/x86_64-w64-mingw32/include/double-conversion")
endif()

include("/scratch/build/mxe-octave-w64-32-release/usr/x86_64-w64-mingw32/lib/cmake/double-conversion/double-conversionLibraryDepends.cmake")

set(double-conversion_LIBRARIES double-conversion)
