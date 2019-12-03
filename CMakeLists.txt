cmake_minimum_required(VERSION 3.15.5)

project(ESMA-Baselibs
   VERSION 6.0.2
   LANGUAGES Fortran C CXX
   )

cmake_policy(SET CMP0074 NEW)

if ("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
   message(FATAL_ERROR "In-source builds are disabled. Please
      issue cmake command in separate build directory.")
endif ("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})

set(CMAKE_INSTALL_MESSAGE LAZY)

set_property(DIRECTORY PROPERTY EP_BASE ${CMAKE_BINARY_DIR})

include(GNUInstallDirs)

include(GetEnvironmentModules)

add_subdirectory(etc)

option(BUILD_MPI        "Build with MPI"   ON)
option(BUILD_CURL       "Build cURL"       ON)
option(BUILD_HDFEOS     "Build HDFEOS"     OFF)
option(BUILD_HDFEOS5    "Build HDFEOS5"    OFF)
option(BUILD_SDPTOOLKIT "Build SDPToolkit" OFF)

if(BUILD_SDPTOOLKIT AND NOT BUILD_HDFEOS)
   message(FATAL_ERROR "You must set -DBUILD_HDFEOS=ON to build SDPToolkit")
endif()
if(BUILD_SDPTOOLKIT AND NOT BUILD_HDFEOS5)
   message(FATAL_ERROR "You must set -DBUILD_HDFEOS5=ON to build SDPToolkit")
endif()

set(SERIAL_C_COMPILER       ${CMAKE_C_COMPILER})
set(SERIAL_CXX_COMPILER     ${CMAKE_CXX_COMPILER})
set(SERIAL_Fortran_COMPILER ${CMAKE_Fortran_COMPILER})

find_package(OpenMP)

if (BUILD_MPI)
   message (STATUS "MPI Build requested")
   set(MPI_DETERMINE_LIBRARY_VERSION TRUE)

   find_package(MPI REQUIRED)

   set(PARALLEL_C_COMPILER       ${MPI_C_COMPILER})
   set(PARALLEL_CXX_COMPILER     ${MPI_CXX_COMPILER})
   set(PARALLEL_Fortran_COMPILER ${MPI_Fortran_COMPILER})

   set(H5_PARALLEL --enable-parallel)

   set(H5_C_COMPILER       ${CMAKE_INSTALL_PREFIX}/bin/h5pcc)
   set(H5_Fortran_COMPILER ${CMAKE_INSTALL_PREFIX}/bin/h5pfc)

   set(NC_PAR_TESTS --enable-parallel-tests)

else ()
   set(PARALLEL_C_COMPILER       ${CMAKE_C_COMPILER})
   set(PARALLEL_CXX_COMPILER     ${CMAKE_CXX_COMPILER})
   set(PARALLEL_Fortran_COMPILER ${CMAKE_Fortran_COMPILER})

   set(H5_PARALLEL --disable-parallel)

   set(H5_C_COMPILER       ${CMAKE_INSTALL_PREFIX}/bin/h5cc)
   set(H5_Fortran_COMPILER ${CMAKE_INSTALL_PREFIX}/bin/h5fc)

   set(NC_PAR_TESTS --disable-parallel-tests)

endif ()

include(DetermineESMFCOMM)
include(DetermineESMFCOMPILER)
include(InstallDirectoryCheck)

set(H4_C_COMPILER       ${CMAKE_INSTALL_PREFIX}/bin/h4cc-hdf4)
set(H4_Fortran_COMPILER ${CMAKE_INSTALL_PREFIX}/bin/h4fc-hdf4)

if (CMAKE_Fortran_COMPILER_ID MATCHES "NAG")
   set(HDF5_ENABLE_F2003 --disable-fortran2003)
   set(FORTRAN_PIC_FLAG -PIC)
else ()
   set(HDF5_ENABLE_F2003 --enable-fortran2003)
   set(FORTRAN_PIC_FLAG -fPIC)
endif ()

set (BASELIBS_C_FLAGS "-fPIC")


find_package(Java COMPONENTS Runtime)

#message(FATAL_ERROR "exiting")

include(ExternalProject)

include(FetchContent)
#set(FETCHCONTENT_QUIET FALSE)
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)

include(LibraryVersions.cmake)

find_program(MAKE_EXE NAMES gmake make)

#########
# ANTLR #
#########

if (Java_FOUND)
   FetchContent_Declare(antlr
      URL      ${ANTLR_URL}
      URL_HASH ${ANTLR_HASH}
   )
   FetchContent_GetProperties(antlr)
   if(NOT antlr_POPULATED)
      message(STATUS "Fetching antlr...")
      FetchContent_Populate(antlr)
   endif()

   ExternalProject_Add(antlr
      SOURCE_DIR ${antlr_SOURCE_DIR}

      CONFIGURE_COMMAND <SOURCE_DIR>/configure 
         --prefix=<INSTALL_DIR> 
         --includedir=<INSTALL_DIR>/include
         CC=${SERIAL_C_COMPILER}
         CFLAGS=${BASELIBS_C_FLAGS}

      BUILD_COMMAND $(MAKE)

      INSTALL_COMMAND $(MAKE) install
      INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

      LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/antlr
      LOG_CONFIGURE         TRUE
      LOG_BUILD             TRUE
      LOG_INSTALL           TRUE
      LOG_MERGED_STDOUTERR  TRUE
      LOG_OUTPUT_ON_FAILURE TRUE
      )
   ExternalProject_Get_property(antlr SOURCE_DIR INSTALL_DIR)
   set(ANTLR_SOURCE_DIR ${SOURCE_DIR})
   set(ANTLR_INCLUDE_DIR ${INSTALL_DIR}/include/antlr)
else ()
   add_custom_target(antlr
      COMMENT "Java not found. antlr not being built")
endif ()

#######
# GSL #
#######

if (Java_FOUND)
   FetchContent_Declare(gsl
      URL      ${GSL_URL}
      URL_HASH ${GSL_HASH}
   )
   FetchContent_GetProperties(gsl)
   if(NOT gsl_POPULATED)
      message(STATUS "Fetching gsl...")
      FetchContent_Populate(gsl)
   endif()

   ExternalProject_Add(gsl
      SOURCE_DIR ${gsl_SOURCE_DIR}

      CONFIGURE_COMMAND <SOURCE_DIR>/configure 
         --prefix=<INSTALL_DIR> 
         --includedir=<INSTALL_DIR>/include
         CC=${SERIAL_C_COMPILER}
         CFLAGS=${BASELIBS_C_FLAGS}
         CXX=${SERIAL_CXX_COMPILER}
         FC=${SERIAL_Fortran_COMPILER}

      BUILD_COMMAND $(MAKE)

      INSTALL_COMMAND $(MAKE) install
      INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

      LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/gsl
      LOG_CONFIGURE         TRUE
      LOG_BUILD             TRUE
      LOG_INSTALL           TRUE
      LOG_MERGED_STDOUTERR  TRUE
      LOG_OUTPUT_ON_FAILURE TRUE
      )
   ExternalProject_Get_property(gsl SOURCE_DIR INSTALL_DIR)
   set(GSL_SOURCE_DIR ${SOURCE_DIR})
   set(GSL_INCLUDE_DIR ${INSTALL_DIR}/include/gsl)
else ()
   add_custom_target(gsl
      COMMENT "Java not found. gsl not being built")
endif ()

########
# jpeg #
########

FetchContent_Declare(jpeg
   URL      ${JPEG_URL}
   URL_HASH ${JPEG_HASH}
)
FetchContent_GetProperties(jpeg)
if(NOT jpeg_POPULATED)
   message(STATUS "Fetching jpeg...")
   FetchContent_Populate(jpeg)
endif()

ExternalProject_Add(jpeg
   SOURCE_DIR ${jpeg_SOURCE_DIR}

   CONFIGURE_COMMAND <SOURCE_DIR>/configure 
      --prefix=<INSTALL_DIR> 
      --includedir=<INSTALL_DIR>/include/jpeg
      CC=${SERIAL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/jpeg
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   )
ExternalProject_Get_property(jpeg SOURCE_DIR INSTALL_DIR)
set(JPEG_SOURCE_DIR ${SOURCE_DIR})
set(JPEG_INCLUDE_DIR ${INSTALL_DIR}/include/jpeg)

########
# zlib #
########

FetchContent_Declare(zlib
   URL      ${ZLIB_URL}
   URL_HASH ${ZLIB_HASH}
)
FetchContent_GetProperties(zlib)
if(NOT zlib_POPULATED)
   message(STATUS "Fetching zlib...")
   FetchContent_Populate(zlib)
endif()

ExternalProject_Add(zlib
   SOURCE_DIR ${zlib_SOURCE_DIR}

   ################################################
   # CMAKE_ARGS                                   #
   #    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> #
   #    -DCMAKE_C_FLAGS=${BASELIBS_C_FLAGS}       #
   ################################################

   CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/zlib

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/zlib
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   )
ExternalProject_Get_property(zlib SOURCE_DIR INSTALL_DIR)
set(ZLIB_SOURCE_DIR ${SOURCE_DIR})
set(ZLIB_INCLUDE_DIR ${INSTALL_DIR}/include/zlib)

########
# szip #
########

FetchContent_Declare(szip
   URL      ${SZIP_URL}
   URL_HASH ${SZIP_HASH}
)
FetchContent_GetProperties(szip)
if(NOT szip_POPULATED)
   message(STATUS "Fetching szip...")
   FetchContent_Populate(szip)
endif()

ExternalProject_Add(szip
   SOURCE_DIR ${szip_SOURCE_DIR}

   #######################################################
   # CMAKE_ARGS                                          #
   #    -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX} #
   #    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>        #
   #######################################################

   CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/szip
      CC=${SERIAL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/szip
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   )
ExternalProject_Get_property(szip SOURCE_DIR INSTALL_DIR)
set(SZIP_SOURCE_DIR ${SOURCE_DIR})
set(SZIP_INCLUDE_DIR ${INSTALL_DIR}/include/szip)

########
# cURL #
########

if (BUILD_CURL)
   FetchContent_Declare(curl
      URL      ${CURL_URL}
      URL_HASH ${CURL_HASH}
   )
   FetchContent_GetProperties(curl)
   if(NOT curl_POPULATED)
      message(STATUS "Fetching curl...")
      FetchContent_Populate(curl)
   endif()

   ExternalProject_Add(curl
      SOURCE_DIR ${curl_SOURCE_DIR}

      ################################################
      # CMAKE_ARGS                                   #
      #    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> #
      #    -DCURL_DISABLE_LDAP:BOOL=ON               #
      #    -DZLIB_ROOT:PATH=${ZLIB_INSTALL_DIR}      #
      ################################################

      CONFIGURE_COMMAND <SOURCE_DIR>/configure
         --prefix=<INSTALL_DIR>
         --includedir=<INSTALL_DIR>/include
         --libdir=<INSTALL_DIR>/lib
         --with-zlib=${CMAKE_INSTALL_PREFIX}
         --disable-ldap
         --enable-manual
         --without-libidn
         --without-libidn2
         CC=${SERIAL_C_COMPILER}
         CFLAGS=${BASELIBS_C_FLAGS}
         CXX=${SERIAL_CXX_COMPILER}
         FC=${SERIAL_Fortran_COMPILER}

      BUILD_COMMAND $(MAKE)

      INSTALL_COMMAND $(MAKE) install
      INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

      LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/curl
      LOG_CONFIGURE         TRUE
      LOG_BUILD             TRUE
      LOG_INSTALL           TRUE
      LOG_MERGED_STDOUTERR  TRUE
      LOG_OUTPUT_ON_FAILURE TRUE
      
      DEPENDS zlib
      )
   ExternalProject_Get_property(curl SOURCE_DIR INSTALL_DIR)
   set(CURL_SOURCE_DIR ${SOURCE_DIR})
   set(CURL_INCLUDE_DIR ${INSTALL_DIR}/include/curl)
else ()
   add_custom_target(curl
      COMMENT "cURL build not requested")
endif ()

########
# hdf4 #
########

FetchContent_Declare(hdf4
   URL      ${HDF4_URL}
   URL_HASH ${HDF4_HASH}
)
FetchContent_GetProperties(hdf4)
if(NOT hdf4_POPULATED)
   message(STATUS "Fetching hdf4...")
   FetchContent_Populate(hdf4)
endif()

ExternalProject_Add(hdf4
   SOURCE_DIR ${hdf4_SOURCE_DIR}

   #######################################################################
   # CMAKE_ARGS                                                          #
   #    -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}                 #
   #    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>                        #
   #    -DHDF4_ENABLE_NETCDF:BOOL=OFF                                    #
   #    -DJPEG_LIBRARY:FILEPATH=${JPEG_INSTALL_DIR}/lib/libjpeg.a        #
   #    -DJPEG_INCLUDE_DIR:PATH=${JPEG_INSTALL_DIR}/include              #
   #    -DZLIB_LIBRARY:FILEPATH=${ZLIB_INSTALL_DIR}/lib/libz.a           #
   #    -DZLIB_INCLUDE_DIR:PATH=${ZLIB_INSTALL_DIR}/include              #
   #    -DSZIP_LIBRARY:FILEPATH=${SZIP_INSTALL_DIR}/lib/libszip-static.a #
   #    -DSZIP_INCLUDE_DIR:PATH=${SZIP_INSTALL_DIR}/include              #
   #######################################################################

   CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --program-suffix=-hdf4
      --includedir=<INSTALL_DIR>/include/hdf
      --with-zlib=${ZLIB_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
      --with-szlib=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
      --with-jpeg=${JPEG_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
      --disable-netcdf
      CC=${SERIAL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      CXX=${SERIAL_CXX_COMPILER}
      FC=${SERIAL_Fortran_COMPILER}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/hdf4
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   
   DEPENDS jpeg
   DEPENDS zlib
   DEPENDS szip
   )
ExternalProject_Get_property(hdf4 SOURCE_DIR INSTALL_DIR)
set(HDF4_SOURCE_DIR ${SOURCE_DIR})
set(HDF4_INCLUDE_DIR ${INSTALL_DIR}/include/hdf)

########
# hdf5 #
########

FetchContent_Declare(hdf5
   URL      ${HDF5_URL}
   URL_HASH ${HDF5_HASH}
)
FetchContent_GetProperties(hdf5)
if(NOT hdf5_POPULATED)
   message(STATUS "Fetching hdf5...")
   FetchContent_Populate(hdf5)
endif()

ExternalProject_Add(hdf5
   SOURCE_DIR ${hdf5_SOURCE_DIR}

   #######################################################################
   # CMAKE_ARGS                                                          #
   #    -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}                 #
   #    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>                        #
   #    -DHDF5_BUILD_FORTRAN:BOOL=ON                                     #
   #    -DHDF5_BUILD_CPP_LIB:BOOL=OFF                                    #
   #    -DHDF5_ENABLE_PARALLEL:BOOL=ON                                   #
   #    -DHDF5_BUILD_HL_LIB:BOOL=ON                                      #
   #    -DJPEG_LIBRARY:FILEPATH=${JPEG_INSTALL_DIR}/lib/libjpeg.a        #
   #    -DJPEG_INCLUDE_DIR:PATH=${JPEG_INSTALL_DIR}/include              #
   #    -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON                              #
   #    -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON                               #
   #    -DHDF5_ENABLE_SZIP_ENCODING:BOOL=ON                              #
   #    -DZLIB_LIBRARY:FILEPATH=${ZLIB_INSTALL_DIR}/lib/libz.a           #
   #    -DZLIB_INCLUDE_DIR:PATH=${ZLIB_INSTALL_DIR}/include              #
   #    -DSZIP_LIBRARY:FILEPATH=${SZIP_INSTALL_DIR}/lib/libszip-static.a #
   #    -DSZIP_INCLUDE_DIR:FILEPATH=${SZIP_INSTALL_DIR}/include          #
   #######################################################################

   CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/hdf5
      --with-zlib=${ZLIB_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
      --with-szlib=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
      --disable-netcdf
      --disable-cxx
      --enable-hl
      --enable-fortran
      ${H5_PARALLEL}
      ${HDF5_ENABLE_F2003}
      CC=${PARALLEL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      CXX=${PARALLEL_CXX_COMPILER}
      FC=${PARALLEL_Fortran_COMPILER}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/hdf5
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   
   DEPENDS zlib
   DEPENDS szip
   )
ExternalProject_Get_property(hdf5 SOURCE_DIR INSTALL_DIR)
set(HDF5_SOURCE_DIR ${SOURCE_DIR})
set(HDF5_INCLUDE_DIR ${INSTALL_DIR}/include/hdf5)

############
# netCDF-C #
############

if (BUILD_CURL)
   set(BUILD_DAP --enable-dap)
   set(ENABLE_DAP ON)
else ()
   set(BUILD_DAP --disable-dap)
   set(ENABLE_DAP OFF)
endif ()

list(APPEND NETCDF_NEEDED_INCLUDES -I${ZLIB_INCLUDE_DIR})
list(APPEND NETCDF_NEEDED_INCLUDES -I${SZIP_INCLUDE_DIR})
list(APPEND NETCDF_NEEDED_INCLUDES -I${HDF4_INCLUDE_DIR})
list(APPEND NETCDF_NEEDED_INCLUDES -I${HDF5_INCLUDE_DIR})
if (BUILD_CURL)
   list(APPEND NETCDF_NEEDED_INCLUDES -I${CURL_INCLUDE_DIR})
endif (BUILD_CURL)
string(REPLACE ";" " " NETCDF_NEEDED_INCLUDES_STRING "${NETCDF_NEEDED_INCLUDES}")

#set(CURL_LIBS "-lssl -lcrypto -lz")

FetchContent_Declare(netcdf
   URL      ${NETCDF_URL}
   URL_HASH ${NETCDF_HASH}
)
FetchContent_GetProperties(netcdf)
if(NOT netcdf_POPULATED)
   message(STATUS "Fetching netcdf...")
   FetchContent_Populate(netcdf)
endif()

ExternalProject_Add(netcdf
   SOURCE_DIR ${netcdf_SOURCE_DIR}

   #######################################################################
   # CMAKE_ARGS                                                          #
   #    -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}/hdf5            #
   #    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>                        #
   #    -DENABLE_NETCDF_4:BOOL=ON                                        #
   #    -DENABLE_PARALLEL4:BOOL=ON                                       #
   #    -DENABLE_HDF4:BOOL=ON                                            #
   #    -DENABLE_DAP:BOOL=${ENABLE_DAP}                                  #
   #    -DCMAKE_C_COMPILER=${PARALLEL_C_COMPILER}                        #
   #    -DCMAKE_CXX_COMPILER=${PARALLEL_CXX_COMPILER}                    #
   #    -DCMAKE_Fortran_COMPILER=${PARALLEL_Fortran_COMPILER}            #
   #    -DMFHDF_H_INCLUDE_DIR=${HDF4_INSTALL_DIR}/include                #
   #    -DHDF4_DF_LIB:FILEPATH=${HDF4_INSTALL_DIR}/lib                   #
   #    -DHDF4_MFHDF_LIB:FILEPATH=${HDF4_INSTALL_DIR}/lib                #
   #    -DJPEG_LIBRARY:FILEPATH=${JPEG_INSTALL_DIR}/lib/libjpeg.a        #
   #    -DJPEG_INCLUDE_DIR:PATH=${JPEG_INSTALL_DIR}/include              #
   #    -DZLIB_LIBRARY:FILEPATH=${ZLIB_INSTALL_DIR}/lib/libz.a           #
   #    -DZLIB_INCLUDE_DIR:PATH=${ZLIB_INSTALL_DIR}/include              #
   #    -DSZIP_LIBRARY:FILEPATH=${SZIP_INSTALL_DIR}/lib/libszip-static.a #
   #    -DSZIP_INCLUDE_DIR:PATH=${SZIP_INSTALL_DIR}/include              #
   #######################################################################

   CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/netcdf
      --enable-hdf4
      ${BUILD_DAP}
      ${NC_PAR_TESTS}
      --disable-examples
      --enable-netcdf-4
      CC=${PARALLEL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      CXX=${PARALLEL_CXX_COMPILER}
      FC=${PARALLEL_Fortran_COMPILER}
      "CPPFLAGS=${NETCDF_NEEDED_INCLUDES_STRING}"
      "LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib ${CURL_LIBS}"

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/netcdf
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   
   DEPENDS hdf5
   DEPENDS hdf4
   DEPENDS curl
   )
ExternalProject_Get_property(netcdf SOURCE_DIR INSTALL_DIR)
set(NETCDF_SOURCE_DIR ${SOURCE_DIR})
set(NETCDF_INCLUDE_DIR ${INSTALL_DIR}/include/netcdf)

##################
# netCDF-Fortran #
##################

FetchContent_Declare(netcdf-fortran
   URL      ${NETCDF_FORTRAN_URL}
   URL_HASH ${NETCDF_FORTRAN_HASH}
)
FetchContent_GetProperties(netcdf-fortran)
if(NOT netcdf-fortran_POPULATED)
   message(STATUS "Fetching netcdf-fortran...")
   FetchContent_Populate(netcdf-fortran)
endif()

ExternalProject_Add(netcdf-fortran
   SOURCE_DIR ${netcdf-fortran_SOURCE_DIR}

   CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH}" <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/netcdf
      ${NC_PAR_TESTS}
      CC=${PARALLEL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      FFLAGS=${FORTRAN_PIC_FLAG}
      FCFLAGS=${FORTRAN_PIC_FLAG}
      CXX=${PARALLEL_CXX_COMPILER}
      FC=${PARALLEL_Fortran_COMPILER}
      "CPPFLAGS=-I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
      "LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib"

   BUILD_COMMAND ${MAKE_EXE} -j1

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/netcdf-fortran
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   
   DEPENDS netcdf
   )

###############
# netCDF-CXX4 #
###############

FetchContent_Declare(netcdf-cxx4
   URL      ${NETCDF_CXX4_URL}
   URL_HASH ${NETCDF_CXX4_HASH}
)
FetchContent_GetProperties(netcdf-cxx4)
if(NOT netcdf-cxx4_POPULATED)
   message(STATUS "Fetching netcdf-cxx4...")
   FetchContent_Populate(netcdf-cxx4)
endif()

ExternalProject_Add(netcdf-cxx4
   SOURCE_DIR ${netcdf-cxx4_SOURCE_DIR}

   CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH}" <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/netcdf
      --with-nc-config=<INSTALL_DIR>/bin
      CC=${PARALLEL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      CXXFLAGS=${BASELIBS_C_FLAGS}
      CXX=${PARALLEL_CXX_COMPILER}
      FC=${PARALLEL_Fortran_COMPILER}
      "CPPFLAGS=-I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
      "LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib -lnetcdf -lhdf5"

   BUILD_COMMAND ${MAKE_EXE} -j1

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/netcdf-cxx4
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   
   DEPENDS netcdf
   )

############
# UDUNITS2 #
############

FetchContent_Declare(udunits2
   URL      ${UDUNITS2_URL}
   URL_HASH ${UDUNITS2_HASH}
)
FetchContent_GetProperties(udunits2)
if(NOT udunits2_POPULATED)
   message(STATUS "Fetching udunits2...")
   FetchContent_Populate(udunits2)
endif()

ExternalProject_Add(udunits2
   SOURCE_DIR ${udunits2_SOURCE_DIR}

   #######################################################
   # CMAKE_ARGS                                          #
   #    -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX} #
   #    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>        #
   #######################################################

   CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/udunits2
      CC=${SERIAL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/udunits2
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   )
ExternalProject_Get_property(udunits2 SOURCE_DIR INSTALL_DIR)
set(UDUNITS2_SOURCE_DIR ${SOURCE_DIR})
set(UDUNITS2_INCLUDE_DIR ${INSTALL_DIR}/include/udunits2)

########
# FLAP #
########

FetchContent_Declare(flap
   GIT_REPOSITORY https://github.com/mathomp4/FLAP.git
   GIT_TAG        geos/v1.5.0
   GIT_SHALLOW    TRUE
   GIT_PROGRESS   TRUE
)
FetchContent_GetProperties(flap)
if(NOT flap_POPULATED)
   message(STATUS "Fetching flap...")
   FetchContent_Populate(flap)
endif()

ExternalProject_Add(flap
   SOURCE_DIR ${flap_SOURCE_DIR}

   CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/flap
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE

   )

########
# gFTL #
########

FetchContent_Declare(gftl
   URL      ${GFTL_URL}
   URL_HASH ${GFTL_HASH}
)
FetchContent_GetProperties(gftl)
if(NOT gftl_POPULATED)
   message(STATUS "Fetching gftl...")
   FetchContent_Populate(gftl)
endif()

ExternalProject_Add(gftl
   SOURCE_DIR ${gftl_SOURCE_DIR}

   CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/gftl
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   )

###############
# gFTL-shared #
###############

FetchContent_Declare(gftl-shared
   URL      ${GFTL_SHARED_URL}
   URL_HASH ${GFTL_SHARED_HASH}
)
FetchContent_GetProperties(gftl-shared)
if(NOT gftl-shared_POPULATED)
   message(STATUS "Fetching gftl-shared...")
   FetchContent_Populate(gftl-shared)
endif()

ExternalProject_Add(gftl-shared
   SOURCE_DIR ${gftl-shared_SOURCE_DIR}

   CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/gftl-shared
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE

   DEPENDS gftl
   )

#############
# fArgParse #
#############

FetchContent_Declare(fargparse
   URL      ${FARGPARSE_URL}
   URL_HASH ${FARGPARSE_HASH}
)
FetchContent_GetProperties(fargparse)
if(NOT fargparse_POPULATED)
   message(STATUS "Fetching fargparse...")
   FetchContent_Populate(fargparse)
endif()

ExternalProject_Add(fargparse
   SOURCE_DIR ${fargparse_SOURCE_DIR}

   CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/fargparse
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE

   DEPENDS gftl
   DEPENDS gftl-shared
   )

##########
# pFUnit #
##########

FetchContent_Declare(pfunit
   URL      ${PFUNIT_URL}
   URL_HASH ${PFUNIT_HASH}
)
FetchContent_GetProperties(pfunit)
if(NOT pfunit_POPULATED)
   message(STATUS "Fetching pfunit...")
   FetchContent_Populate(pfunit)
endif()

ExternalProject_Add(pfunit
   SOURCE_DIR ${pfunit_SOURCE_DIR}

   CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
      -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
      -DSKIP_OPENMP:BOOL=YES

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/pfunit
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE

   DEPENDS gftl
   DEPENDS gftl-shared
   DEPENDS fargparse
   )

########
# esmf #
########

FetchContent_Declare(esmf
   GIT_REPOSITORY https://git.code.sf.net/p/esmf/esmf
   GIT_TAG ESMF_8_0_1_beta_snapshot_02
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(esmf)
if(NOT esmf_POPULATED)
   message(STATUS "Fetching esmf...")
   FetchContent_Populate(esmf)
endif()

ExternalProject_Add(esmf
   SOURCE_DIR ${esmf_SOURCE_DIR}

   CONFIGURE_COMMAND ""

   BUILD_COMMAND ${CMAKE_COMMAND} -E env "PATH=${CMAKE_INSTALL_PREFIX}/bin:$ENV{PATH}" $(MAKE) lib
      ESMF_DIR=<SOURCE_DIR>
      ESMF_INSTALL_PREFIX=<INSTALL_DIR>
      ESMF_INSTALL_HEADERDIR=<INSTALL_DIR>/include/esmf
      ESMF_INSTALL_MODDIR=<INSTALL_DIR>/include/esmf
      ESMF_INSTALL_LIBDIR=<INSTALL_DIR>/lib
      ESMF_INSTALL_BINDIR=<INSTALL_DIR>/bin
      ESMF_COMPILER=${ESMF_COMPILER}
      ESMF_COMM=${ESMF_COMM}
      ESMF_NETCDF=split
      ESMF_NETCDF_INCLUDE=<INSTALL_DIR>/include/netcdf
      ESMF_NETCDF_LIBPATH=<INSTALL_DIR>/lib
      ESMF_OS=${CMAKE_SYSTEM_NAME}
      ESMF_MACHINE=${CMAKE_SYSTEM_PROCESSOR}

   BUILD_IN_SOURCE TRUE

   INSTALL_COMMAND ${CMAKE_COMMAND} -E env "PATH=${CMAKE_INSTALL_PREFIX}/bin:$ENV{PATH}" $(MAKE) install
      ESMF_DIR=<SOURCE_DIR>
      ESMF_INSTALL_PREFIX=<INSTALL_DIR>
      ESMF_INSTALL_HEADERDIR=<INSTALL_DIR>/include/esmf
      ESMF_INSTALL_MODDIR=<INSTALL_DIR>/include/esmf
      ESMF_INSTALL_LIBDIR=<INSTALL_DIR>/lib
      ESMF_INSTALL_BINDIR=<INSTALL_DIR>/bin
      ESMF_COMPILER=${ESMF_COMPILER}
      ESMF_COMM=${ESMF_COMM}
      ESMF_NETCDF=split
      ESMF_NETCDF_INCLUDE=<INSTALL_DIR>/include/netcdf
      ESMF_NETCDF_LIBPATH=<INSTALL_DIR>/lib
      ESMF_OS=${CMAKE_SYSTEM_NAME}
      ESMF_MACHINE=${CMAKE_SYSTEM_PROCESSOR}
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/esmf
   LOG_CONFIGURE         TRUE
   #LOG_BUILD             TRUE  # If this is enabled, esmf will not build
   #LOG_INSTALL           TRUE  # If this is enabled, esmf will not install
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE

   DEPENDS netcdf-fortran
   )

#######
# nco #
#######

if (Java_FOUND)
   set(BUILD_NCAP2 --enable-ncap2)
   set(USE_GSL     --enable-gsl)
else ()
   set(BUILD_NCAP2 --disable-ncap2)
   set(USE_GSL     --disable-gsl)
endif ()

FetchContent_Declare(nco
   URL      ${NCO_URL}
   URL_HASH ${NCO_HASH}
)
FetchContent_GetProperties(nco)
if(NOT nco_POPULATED)
   message(STATUS "Fetching nco...")
   FetchContent_Populate(nco)
endif()

ExternalProject_Add(nco
   SOURCE_DIR ${nco_SOURCE_DIR}

   CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH}" <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/nco
      ${BUILD_NCAP2}
      ${USE_GSL}
      --enable-nco_cplusplus
      --disable-mpi
      --enable-openmp
      --enable-netcdf4
      --enable-udunits2
      --disable-doc
      CC=${PARALLEL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      FFLAGS=${FORTRAN_PIC_FLAG}
      FCFLAGS=${FORTRAN_PIC_FLAG}
      CXX=${PARALLEL_CXX_COMPILER}
      FC=${PARALLEL_Fortran_COMPILER}
      NETCDF_ROOT=${CMAKE_INSTALL_PREFIX}
      NETCDF_LIB=${CMAKE_INSTALL_PREFIX}/lib
      NETCDF_INC=${NETCDF_INCLUDE_DIR}
      ANTLR_ROOT=${CMAKE_INSTALL_PREFIX}
      ANTLR_LIB=${CMAKE_INSTALL_PREFIX}/lib
      ANTLR_INC=${CMAKE_INSTALL_PREFIX}/include
      GSL_ROOT=${CMAKE_INSTALL_PREFIX}
      GSL_LIB=${CMAKE_INSTALL_PREFIX}/lib
      GSL_INC=${CMAKE_INSTALL_PREFIX}/include
      UDUNITS2_PATH=${CMAKE_INSTALL_PREFIX}
      "CPPFLAGS=-I${UDUNITS2_INCLUDE_DIR} -I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
      "LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib"

   BUILD_COMMAND $(MAKE)

   BUILD_IN_SOURCE TRUE

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/nco
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   
   DEPENDS netcdf
   DEPENDS udunits2
   DEPENDS antlr
   DEPENDS gsl
   )

#######
# cdo #
#######

FetchContent_Declare(cdo
   URL      ${CDO_URL}
   URL_HASH ${CDO_HASH}
)
FetchContent_GetProperties(cdo)
if(NOT cdo_POPULATED)
   message(STATUS "Fetching cdo...")
   FetchContent_Populate(cdo)
endif()

ExternalProject_Add(cdo
   SOURCE_DIR ${cdo_SOURCE_DIR}

   CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH}" <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/cdo
      --with-zlib=<INSTALL_DIR>
      --with-szlib=<INSTALL_DIR>
      --with-hdf5=<INSTALL_DIR>
      --with-netcdf=<INSTALL_DIR>
      --with-udunits2=<INSTALL_DIR>
      --disable-grib
      --disable-openmp
      CC=${PARALLEL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      CXX=${PARALLEL_CXX_COMPILER}
      FC=${PARALLEL_Fortran_COMPILER}
      "CPPFLAGS=-I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
      "LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib"

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/cdo
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   
   DEPENDS netcdf
   DEPENDS udunits2
   )

#########
# nccmp #
#########

FetchContent_Declare(nccmp
   URL      ${NCCMP_URL}
   URL_HASH ${NCCMP_HASH}
)
FetchContent_GetProperties(nccmp)
if(NOT nccmp_POPULATED)
   message(STATUS "Fetching nccmp...")
   FetchContent_Populate(nccmp)
endif()

ExternalProject_Add(nccmp
   SOURCE_DIR ${nccmp_SOURCE_DIR}

   CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH}" <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/nccmp
      --with-netcdf=${NETCDF_SOURCE_DIR}
      CC=${PARALLEL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      FFLAGS=${FORTRAN_PIC_FLAG}
      FCFLAGS=${FORTRAN_PIC_FLAG}
      CXX=${PARALLEL_CXX_COMPILER}
      FC=${PARALLEL_Fortran_COMPILER}
      "CPPFLAGS=-I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
      "LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib"

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

   LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/nccmp
   LOG_CONFIGURE         TRUE
   LOG_BUILD             TRUE
   LOG_INSTALL           TRUE
   LOG_MERGED_STDOUTERR  TRUE
   LOG_OUTPUT_ON_FAILURE TRUE
   
   DEPENDS netcdf
   )

##########
# hdfeos #
##########

if (BUILD_HDFEOS)
   FetchContent_Declare(hdfeos
      URL      ${HDFEOS_URL}
      URL_HASH ${HDFEOS_HASH}
   )
   FetchContent_GetProperties(hdfeos)
   if(NOT hdfeos_POPULATED)
      message(STATUS "Fetching hdfeos...")
      FetchContent_Populate(hdfeos)
   endif()

   ExternalProject_Add(hdfeos
      SOURCE_DIR ${hdfeos_SOURCE_DIR}

      CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH}" <SOURCE_DIR>/configure
         --prefix=<INSTALL_DIR>
         --includedir=<INSTALL_DIR>/include/hdfeos
         --with-zlib=${ZLIB_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-szlib=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-jpeg=${JPEG_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-hdf4=${HDF4_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         CC=${H4_C_COMPILER}
         CFLAGS=${BASELIBS_C_FLAGS}
         "CPPFLAGS=-Df2cfortran -I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
         FC=${H4_Fortran_COMPILER}

      BUILD_COMMAND $(MAKE)

      INSTALL_COMMAND $(MAKE) install
            COMMAND $(MAKE) -C include install
      INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

      LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/hdfeos
      LOG_CONFIGURE         TRUE
      LOG_BUILD             TRUE
      LOG_INSTALL           TRUE
      LOG_MERGED_STDOUTERR  TRUE
      LOG_OUTPUT_ON_FAILURE TRUE
      
      DEPENDS hdf4
      )
   ExternalProject_Get_property(hdfeos SOURCE_DIR INSTALL_DIR)
   set(HDFEOS_SOURCE_DIR ${SOURCE_DIR})
   set(HDFEOS_INCLUDE_DIR ${INSTALL_DIR}/include/hdfeos)
endif (BUILD_HDFEOS)

###########
# hdfeos5 #
###########

if (BUILD_HDFEOS5)
   FetchContent_Declare(hdfeos5
      URL      ${HDFEOS5_URL}
      URL_HASH ${HDFEOS5_HASH}
   )
   FetchContent_GetProperties(hdfeos5)
   if(NOT hdfeos5_POPULATED)
      message(STATUS "Fetching hdfeos5...")
      FetchContent_Populate(hdfeos5)
   endif()

   ExternalProject_Add(hdfeos5
      SOURCE_DIR ${hdfeos5_SOURCE_DIR}

      CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH}" <SOURCE_DIR>/configure
         --prefix=<INSTALL_DIR>
         --includedir=<INSTALL_DIR>/include/hdfeos5
         --with-zlib=${ZLIB_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-szlib=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-jpeg=${JPEG_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-hdf5=${HDF5_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         CC=${H5_C_COMPILER}
         CFLAGS=${BASELIBS_C_FLAGS}
         "CPPFLAGS=-Df2cfortran -I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
         FC=${H5_Fortran_COMPILER}

      BUILD_COMMAND $(MAKE)

      INSTALL_COMMAND $(MAKE) install
            COMMAND $(MAKE) -C include install
      INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

      LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/hdfeos5
      LOG_CONFIGURE         TRUE
      LOG_BUILD             TRUE
      LOG_INSTALL           TRUE
      LOG_MERGED_STDOUTERR  TRUE
      LOG_OUTPUT_ON_FAILURE TRUE
      
      DEPENDS hdf5
      )
   ExternalProject_Get_property(hdfeos5 SOURCE_DIR INSTALL_DIR)
   set(HDFEOS5_SOURCE_DIR ${SOURCE_DIR})
   set(HDFEOS5_INCLUDE_DIR ${INSTALL_DIR}/include/hdfeos5)
endif (BUILD_HDFEOS5)

##############
# sdptoolkit #
##############

if (BUILD_SDPTOOLKIT)
   FetchContent_Declare(sdptoolkit
      URL      ${SDPTK_URL}
      URL_HASH ${SDPTK_HASH}
   )
   FetchContent_GetProperties(sdptoolkit)
   if(NOT sdptoolkit_POPULATED)
      message(STATUS "Fetching sdptoolkit...")
      FetchContent_Populate(sdptoolkit)
   endif()

   ExternalProject_Add(sdptoolkit
      SOURCE_DIR ${sdptoolkit_SOURCE_DIR}

      CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:$ENV{LD_LIBRARY_PATH}" <SOURCE_DIR>/configure
         --prefix=<INSTALL_DIR>
         --includedir=<INSTALL_DIR>/include/SDPToolkit
         --with-zlib=${ZLIB_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-szlib=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-jpeg=${JPEG_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-hdf4=${HDF4_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-hdf5=${HDF5_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-hdfeos=${HDFEOS_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         --with-hdfeos5=${HDFEOS5_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
         CC=${PARALLEL_C_COMPILER}
         CFLAGS=${BASELIBS_C_FLAGS}
         "CPPFLAGS=-Df2cfortran -I${HDFEOS_INCLUDE_DIR} -I${HDFEOS5_INCLUDE_DIR} -I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
         FC=${PARALLEL_Fortran_COMPILER}

      BUILD_COMMAND $(MAKE)
      BUILD_IN_SOURCE TRUE

      INSTALL_COMMAND $(MAKE) install
      INSTALL_DIR ${CMAKE_INSTALL_PREFIX}

      LOG_DIR               ${CMAKE_INSTALL_PREFIX}/logs/sdptoolkit
      LOG_CONFIGURE         TRUE
      LOG_BUILD             TRUE
      LOG_INSTALL           TRUE
      LOG_MERGED_STDOUTERR  TRUE
      LOG_OUTPUT_ON_FAILURE TRUE
      
      DEPENDS hdfeos
      DEPENDS hdfeos5
      )
   ExternalProject_Get_property(sdptoolkit SOURCE_DIR INSTALL_DIR)
   set(SDPTOOLKIT_SOURCE_DIR ${SOURCE_DIR})
   set(SDPTOOLKIT_INCLUDE_DIR ${INSTALL_DIR}/include/SDPToolkit)
endif (BUILD_SDPTOOLKIT)

install(FILES ChangeLog DESTINATION ${CMAKE_INSTALL_SYSCONFDIR})
