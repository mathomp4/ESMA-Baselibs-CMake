# ---------
# ESMF_COMM
# ---------

if(NOT ESMF_COMM)
   if(NOT BUILD_MPI)
      set(ESMF_COMM mpiuni)
      set(DETECTED_MPI_VERSION_STRING "")
   else ()
      if (ESMF_COMM MATCHES "mpiuni")
         message(FATAL_ERROR "You cannot build with BUILD_MPI=ON and ESMF_COMM=mpiuni")
      endif ()

      string(REPLACE " " ";" MPI_Fortran_LIBRARY_VERSION_LIST ${MPI_Fortran_LIBRARY_VERSION_STRING})
      list(GET MPI_Fortran_LIBRARY_VERSION_LIST 0 MPI_Fortran_LIBRARY_VERSION_FIRSTWORD)

      if(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "Intel")
         set(ESMF_COMM intelmpi)
         set(DETECTED_MPI_VERSION_STRING ${CMAKE_Fortran_COMPILER_VERSION})
      elseif(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "MVAPICH2")
         set(ESMF_COMM mvapich2)
         list(GET MPI_Fortran_LIBRARY_VERSION_LIST 3 DETECTED_MPI_VERSION_STRING)
      elseif(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "HPE")
         set(ESMF_COMM mpt)
         list(GET MPI_Fortran_LIBRARY_VERSION_LIST 2 DETECTED_MPI_VERSION_STRING)
      elseif(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "MPICH")
         set(ESMF_COMM mpich3)
         list(GET MPI_Fortran_LIBRARY_VERSION_LIST 1 DETECTED_MPI_VERSION_STRING_WITH_EXTRA_SPACES)
         # MPICH3 has a weird output. Need to make it a list in an ugly way...
         string(REGEX REPLACE "[ \t\r\n]" ";" DETECTED_MPI_VERSION_STRING_LIST ${DETECTED_MPI_VERSION_STRING_WITH_EXTRA_SPACES})
         # Then grab the second field
         list(GET DETECTED_MPI_VERSION_STRING_LIST 1 DETECTED_MPI_VERSION_STRING)
      elseif(MPI_Fortran_LIBRARY_VERSION_FIRSTWORD MATCHES "Open")
         set(ESMF_COMM openmpi)
         list(GET MPI_Fortran_LIBRARY_VERSION_LIST 2 DETECTED_MPI_VERSION_STRING_WITH_COMMA)
         string(REPLACE "," "" DETECTED_MPI_VERSION_STRING_WITH_V ${DETECTED_MPI_VERSION_STRING_WITH_COMMA})
         string(REPLACE "v" "" DETECTED_MPI_VERSION_STRING        ${DETECTED_MPI_VERSION_STRING_WITH_V})
      endif()
   endif()

   if(NOT ESMF_COMM)
      message (FATAL_ERROR "ERROR: ESMF_COMM autodetection failed. Must specify a value for ESMF_COMM with cmake ... -DESMF_COMM=<mpistack>.")
   endif()
else ()
   set(DETECTED_MPI_VERSION_STRING "")
endif ()

message(STATUS "Using ESMF_COMM: ${ESMF_COMM}")
set(ESMF_COMM "${ESMF_COMM}" CACHE STRING "ESMF_COMM Value")
