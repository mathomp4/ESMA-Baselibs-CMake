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

#########
# ANTLR #
#########

if (Java_FOUND)
   FetchContent_Declare(antlr
      URL http://dust.ess.uci.edu/nco/antlr-2.7.7.tar.gz
      URL_HASH SHA512=130b5d7ea676f28f75fe75da9b5e11caf6d6c92f51e33ff80a9f624735c8da8a3d62a2ef7e86a6812c932984fa56525388124d9314c0a6bd418ab97b078d85cb
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
      URL http://mirrors.ibiblio.org/gnu/ftp/gnu/gsl/gsl-2.6.tar.gz
      URL_HASH SHA512=0be8240715f0b86aba2c63d9f12da4dba4719d4e350e9308d279e0dd3b2f0519ea26fd2e38a17f3e8cf43aacbaa2455207a7ca0d6c305f3b8725e8ece2250a74
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
   GIT_REPOSITORY https://github.com/libjpeg-turbo/ijg.git
   GIT_TAG jpeg-9c
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(jpeg)
if(NOT jpeg_POPULATED)
   message(STATUS "Cloning jpeg...")
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
   )
ExternalProject_Get_property(jpeg SOURCE_DIR INSTALL_DIR)
set(JPEG_SOURCE_DIR ${SOURCE_DIR})
set(JPEG_INCLUDE_DIR ${INSTALL_DIR}/include/jpeg)

########
# zlib #
########

FetchContent_Declare(zlib
   GIT_REPOSITORY https://github.com/madler/zlib.git
   GIT_TAG v1.2.11
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(zlib)
if(NOT zlib_POPULATED)
   message(STATUS "Cloning zlib...")
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
   )
ExternalProject_Get_property(zlib SOURCE_DIR INSTALL_DIR)
set(ZLIB_SOURCE_DIR ${SOURCE_DIR})
set(ZLIB_INCLUDE_DIR ${INSTALL_DIR}/include/zlib)

########
# szip #
########

FetchContent_Declare(szip
   URL https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
   URL_HASH SHA512=ada6406efb096cd8a2daf8f9217fe9111a96dcae87e29d1c31f58ddd2ad2aa7bac03f23c7205dc9360f3b62d259461759330c7189ef0c2fe559704b1ea9d40dd
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
   )
ExternalProject_Get_property(szip SOURCE_DIR INSTALL_DIR)
set(SZIP_SOURCE_DIR ${SOURCE_DIR})
set(SZIP_INCLUDE_DIR ${INSTALL_DIR}/include/szip)

########
# cURL #
########

if (BUILD_CURL)
   FetchContent_Declare(curl
      URL https://curl.haxx.se/download/curl-7.67.0.tar.xz
      URL_HASH SHA512=1d5a344be92dd61b1ba5189eff0fe337e492f2e850794943570fe71c985d0af60bd412082be646e07aaa8639908593e1ce4bb2d07db35394ec377e8ce8b9ae29
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
   GIT_REPOSITORY https://bitbucket.hdfgroup.org/scm/hdffr/hdf4.git
   GIT_TAG hdf-4_2_14
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(hdf4)
if(NOT hdf4_POPULATED)
   message(STATUS "Cloning hdf4...")
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
      --with-szip=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
      --with-jpeg=${JPEG_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
      --disable-netcdf
      CC=${SERIAL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      CXX=${SERIAL_CXX_COMPILER}
      FC=${SERIAL_Fortran_COMPILER}

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
   
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
   GIT_REPOSITORY https://bitbucket.hdfgroup.org/scm/hdffv/hdf5.git
   GIT_TAG hdf5-1_10_5
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(hdf5)
if(NOT hdf5_POPULATED)
   message(STATUS "Cloning hdf5...")
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
      --with-szip=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
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
   GIT_REPOSITORY https://github.com/Unidata/netcdf-c.git
   GIT_TAG v4.7.2
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(netcdf)
if(NOT netcdf_POPULATED)
   message(STATUS "Cloning netcdf...")
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
   GIT_REPOSITORY https://github.com/Unidata/netcdf-fortran.git
   GIT_TAG v4.5.2
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(netcdf-fortran)
if(NOT netcdf-fortran_POPULATED)
   message(STATUS "Cloning netcdf-fortran...")
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

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
   
   DEPENDS netcdf
   )

###############
# netCDF-CXX4 #
###############

FetchContent_Declare(netcdf-cxx4
   GIT_REPOSITORY https://github.com/Unidata/netcdf-cxx4.git
   GIT_TAG v4.3.1
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(netcdf-cxx4)
if(NOT netcdf-cxx4_POPULATED)
   message(STATUS "Cloning netcdf-cxx4...")
   FetchContent_Populate(netcdf-cxx4)
endif()

ExternalProject_Add(netcdf-cxx4
   SOURCE_DIR ${netcdf-cxx4_SOURCE_DIR}

   CONFIGURE_COMMAND <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --includedir=<INSTALL_DIR>/include/netcdf
      ${NC_PAR_TESTS}
      CC=${PARALLEL_C_COMPILER}
      CFLAGS=${BASELIBS_C_FLAGS}
      CXXFLAGS=${BASELIBS_C_FLAGS}
      CXX=${PARALLEL_CXX_COMPILER}
      FC=${PARALLEL_Fortran_COMPILER}
      "CPPFLAGS=-I${NETCDF_INCLUDE_DIR} ${NETCDF_NEEDED_INCLUDES_STRING}"
      "LDFLAGS=-L${CMAKE_INSTALL_PREFIX}/lib ${CURL_LIBS}"

   BUILD_COMMAND $(MAKE)

   INSTALL_COMMAND $(MAKE) install
   INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
   
   DEPENDS netcdf
   )

############
# UDUNITS2 #
############

FetchContent_Declare(udunits2
   URL ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.26.tar.gz
   URL_HASH SHA512=9e5320454646458ac40ba0855b6b8e12f7edbdb4b9a6c687a4c38ad07400e2e0c0f7968069885f83eb73da64886e1c6dd1e462ebc23205df849c3a460cedb640
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
   )
ExternalProject_Get_property(udunits2 SOURCE_DIR INSTALL_DIR)
set(UDUNITS2_SOURCE_DIR ${SOURCE_DIR})
set(UDUNITS2_INCLUDE_DIR ${INSTALL_DIR}/include/udunits2)

########
# FLAP #
########

FetchContent_Declare(flap
   GIT_REPOSITORY https://github.com/mathomp4/FLAP.git
   GIT_TAG geos/v1.4.0
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(flap)
if(NOT flap_POPULATED)
   message(STATUS "Cloning flap...")
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
   )

########
# gFTL #
########

FetchContent_Declare(gftl
   GIT_REPOSITORY https://github.com/Goddard-Fortran-Ecosystem/gFTL.git
   GIT_TAG v1.2.2
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(gftl)
if(NOT gftl_POPULATED)
   message(STATUS "Cloning gftl...")
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
   )

###############
# gFTL-shared #
###############

FetchContent_Declare(gftl-shared
   GIT_REPOSITORY https://github.com/Goddard-Fortran-Ecosystem/gFTL-shared.git
   GIT_TAG v1.0.2
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(gftl-shared)
if(NOT gftl-shared_POPULATED)
   message(STATUS "Cloning gftl-shared...")
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

   DEPENDS gftl
   )

#############
# fArgParse #
#############

FetchContent_Declare(fargparse
   GIT_REPOSITORY https://github.com/Goddard-Fortran-Ecosystem/fArgParse.git
   GIT_TAG v0.9.1
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(fargparse)
if(NOT fargparse_POPULATED)
   message(STATUS "Cloning fargparse...")
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

   DEPENDS gftl
   )

##########
# pFUnit #
##########

FetchContent_Declare(pfunit
   GIT_REPOSITORY https://github.com/Goddard-Fortran-Ecosystem/pFUnit.git
   GIT_TAG v4.1.1
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(pfunit)
if(NOT pfunit_POPULATED)
   message(STATUS "Cloning pfunit...")
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
   message(STATUS "Cloning esmf...")
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
   GIT_REPOSITORY https://github.com/nco/nco.git
   GIT_TAG 4.8.1
   GIT_SHALLOW TRUE
   GIT_PROGRESS TRUE
)
FetchContent_GetProperties(nco)
if(NOT nco_POPULATED)
   message(STATUS "Cloning nco...")
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
   
   DEPENDS netcdf
   DEPENDS udunits2
   DEPENDS antlr
   DEPENDS gsl
   )

#######
# cdo #
#######

FetchContent_Declare(cdo
   URL https://code.mpimet.mpg.de/attachments/download/20826/cdo-1.9.8.tar.gz
   URL_HASH SHA512=05bcaac5971dbcb5b3169b0ebf0939f2d727b0506beaee8364282d27fac03046dbc130241ec2501e8b261349365096f79bbbdb9bd67aae4488baea8c1343d2b2
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
      --with-szip=<INSTALL_DIR>
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
   
   DEPENDS netcdf
   DEPENDS udunits2
   )

#########
# nccmp #
#########

FetchContent_Declare(nccmp
   URL https://gitlab.com/remikz/nccmp/-/archive/1.8.5.0/nccmp-1.8.5.0.tar.bz2
   URL_HASH SHA512=7c243a9ff4a33dae5224fd9cb7b5fa8954ea55677c85ed7478ccf071eed63c96ddc4f03be08f0fd0646dfb10b9615696198ecbb003d522cc186fe9dc60283846
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
   
   DEPENDS netcdf
   )

##########
# hdfeos #
##########

if (BUILD_HDFEOS)
   FetchContent_Declare(hdfeos
      URL https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos/latest_release/HDF-EOS2.20v1.00.tar.Z
      URL_HASH SHA512=9ca7cf96d7357c02e82e9290aed5343fdbf27afcbaa755794fbf51f5f27ce3f02e6d9e15a69ced4136d5e9e2610448cc720af049430cd26e37c194983717400a
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
         --with-szip=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
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
      URL https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos5/latest_release/HDF-EOS5.1.16.tar.Z
      URL_HASH SHA512=d6576ef796903c7df97edc8f6ae8641c08dec7342f36c7a6ece361f696a7543281bbd7485fc47562a300b0bad87289e25322812bb6997d0191639eb5688424a8
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
         --with-szip=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
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
      URL https://observer.gsfc.nasa.gov/ftp/edhs/sdptk/latest_release/SDPTK5.2.20v1.01.tar.Z
      URL_HASH SHA512=446b3976dd4f21af5ea421dc325d6c8edbb8ea5178e02d37572b143726c0367740d2b07ef48120a5bd31ef700a34c34138f89c21215a921ce877cefbdf159d98
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
         --with-szip=${SZIP_INCLUDE_DIR},${CMAKE_INSTALL_PREFIX}/lib
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
      
      DEPENDS hdfeos
      DEPENDS hdfeos5
      )
   ExternalProject_Get_property(sdptoolkit SOURCE_DIR INSTALL_DIR)
   set(SDPTOOLKIT_SOURCE_DIR ${SOURCE_DIR})
   set(SDPTOOLKIT_INCLUDE_DIR ${INSTALL_DIR}/include/SDPToolkit)
endif (BUILD_SDPTOOLKIT)

install(FILES ChangeLog DESTINATION ${CMAKE_INSTALL_SYSCONFDIR})
