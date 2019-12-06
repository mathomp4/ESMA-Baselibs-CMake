# Most users of this software do not (should not?) have permissions to
# install in the cmake default of /usr/local (or equiv on other os's).
# Below, the default is changed to a directory within the main tree
# unless the user explicitly sets CMAKE_INSTALL_PREFIX in the cache.

include(SetColors)

# Try to make good guesses
# ------------------------
if(DETECTED_ESMF_COMPILER)
   if(ESMF_COMPILER STREQUAL "intel")
      set(DEFAULT_INSTALL_Fortran_COMPILER_NAME ifort)
   elseif(ESMF_COMPILER STREQUAL "intelgcc")
      set(DEFAULT_INSTALL_Fortran_COMPILER_NAME ifort)
      set(DEFAULT_INSTALL_C_COMPILER_NAME gcc)
   elseif(ESMF_COMPILER STREQUAL "pgi")
      set(DEFAULT_INSTALL_Fortran_COMPILER_NAME pgfortran)
   elseif(ESMF_COMPILER STREQUAL "pgigcc")
      set(DEFAULT_INSTALL_Fortran_COMPILER_NAME pgfortran)
      set(DEFAULT_INSTALL_C_COMPILER_NAME gcc)
   elseif(ESMF_COMPILER STREQUAL "gnu")
      set(DEFAULT_INSTALL_Fortran_COMPILER_NAME gfortran)
   elseif(ESMF_COMPILER STREQUAL "nag")
      set(DEFAULT_INSTALL_Fortran_COMPILER_NAME nagfor)
   elseif(ESMF_COMPILER STREQUAL "nagintel")
      set(DEFAULT_INSTALL_Fortran_COMPILER_NAME nagfor)
      set(DEFAULT_INSTALL_C_COMPILER_NAME icc)
   else()
      set(DEFAULT_INSTALL_Fortran_COMPILER_NAME ${ESMF_COMPILER})
   endif()
endif()

if(NOT DETECTED_ESMF_COMPILER)
   set(INSTALL_COMPILER_NAME ${ESMF_COMPILER})
elseif(DEFAULT_INSTALL_C_COMPILER_NAME)
   set(INSTALL_COMPILER_NAME ${DEFAULT_INSTALL_Fortran_COMPILER_NAME}_${CMAKE_Fortran_COMPILER_VERSION}-${DEFAULT_INSTALL_C_COMPILER_NAME}_${CMAKE_C_COMPILER_VERSION})
else()
   set(INSTALL_COMPILER_NAME ${DEFAULT_INSTALL_Fortran_COMPILER_NAME}_${CMAKE_Fortran_COMPILER_VERSION})
endif()

if("${DETECTED_MPI_VERSION_STRING}" STREQUAL "")
   set(INSTALL_MPI_NAME ${ESMF_COMM})
else ()
   set(INSTALL_MPI_NAME ${ESMF_COMM}_${DETECTED_MPI_VERSION_STRING})
endif()

set(DEFAULT_INSTALL_NAME ${INSTALL_COMPILER_NAME}-${INSTALL_MPI_NAME})
#message(STATUS "DEFAULT_INSTALL_NAME: ${DEFAULT_INSTALL_NAME}")

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
   message(STATUS "*** Attempt to use default CMAKE_INSTALL_PREFIX which is usually only writable by root so not allowed")
   set (CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/${DEFAULT_INSTALL_NAME}/${CMAKE_SYSTEM_NAME}" CACHE PATH "Default install path" FORCE )
   message(STATUS "*** Setting default install prefix to ${BoldYellow}${CMAKE_INSTALL_PREFIX}${ColorReset}")
   message(STATUS "*** Override with -DCMAKE_INSTALL_PREFIX=<path>.")
else()
   get_filename_component(LAST_DIR_NODE ${CMAKE_INSTALL_PREFIX} NAME)
   #message(STATUS "LAST_DIR_NODE: ${LAST_DIR_NODE}")
   if (NOT LAST_DIR_NODE STREQUAL ${CMAKE_SYSTEM_NAME})
      message(FATAL_ERROR 
         "Due to current scripting limitations in GEOS, the last node of the Baselibs installation must\
         match the CMAKE_SYSTEM_NAME (aka 'uname -s') which for this machine is ${BoldYellow}${CMAKE_SYSTEM_NAME}${ColorReset}\
         Please change your CMAKE_INSTALL_PREFIX so that the last folder in the directory\
         path is ${BoldYellow}${CMAKE_SYSTEM_NAME}${ColorReset} a la:
         ${BoldWhite}${CMAKE_INSTALL_PREFIX}/${CMAKE_SYSTEM_NAME}${ColorReset}
         "
         )
   endif ()
   message (STATUS "Installing to ${BoldYellow}${CMAKE_INSTALL_PREFIX}${ColorReset}")
endif()


