# -------------
# ESMF_COMPILER
# -------------

if (NOT ESMF_COMPILER)
   # gfortran
   # --------
   if (CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
      if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
         set(ESMF_COMPILER gfortranclang)
      elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
         set(ESMF_COMPILER gfortran)
      endif()
   endif()

   # ifort
   # -----
   if (CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
      if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
         set(ESMF_COMPILER intelgcc)
      elseif(CMAKE_CXX_COMPILER_ID MATCHES "Intel")
         set(ESMF_COMPILER intel)
      endif()
   endif()

   # NAG
   # ---
   if (CMAKE_Fortran_COMPILER_ID MATCHES "NAG")
      if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
         set(ESMF_COMPILER nag)
      elseif(CMAKE_CXX_COMPILER_ID MATCHES "Intel")
         set(ESMF_COMPILER nagintel)
      endif()
   endif()

   # PGI
   # ---
   if (CMAKE_Fortran_COMPILER_ID MATCHES "PGI")
      if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
         if (CMAKE_SYSTEM_NAME MATCHES "Linux")
            set(ESMF_COMPILER pgigcc)
         else()
            message(FATAL_ERROR "PGI Fortran with GNU C++ not supported by ESMF on ${CMAKE_SYSTEM_NAME}")
         endif()
      elseif(CMAKE_CXX_COMPILER_ID MATCHES "PGI")
         set(ESMF_COMPILER pgi)
      endif()
   endif()

   if(NOT ESMF_COMPILER)
      message (FATAL_ERROR "ERROR: ESMF_COMPILER autodetection failed. Must specify a value for ESMF_COMPILER with cmake ... -DESMF_COMPILER=<compiler>.")
   endif()
   set(DETECTED_ESMF_COMPILER TRUE)
endif ()

message(STATUS "Using ESMF_COMPILER: ${ESMF_COMPILER}")
set(ESMF_COMPILER "${ESMF_COMPILER}" CACHE STRING "ESMF_COMPILER Value")
