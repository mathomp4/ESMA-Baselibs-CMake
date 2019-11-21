# ESMA Baselibs

This git repository contains a simplified version of the "baselibs"
module first developed by Gerhard Theurich and later matained by Eugene
Mirvis, Denis Nadeau, and Matthew Thompson. The current version only
includes a minimal set of libraries needed for building GEOS at
NASA/GSFC:

* ESMF
* NetCDF-4 (C, Fortran, and C++ interfaces)
* UDUNITS 2
* HDF-4
* HDF-5
* zlib
* szlib
* jpeg
* HDF-EOS2
* HDF-EOS5
* NCO
* curl
* CDO
* pFUnit
* GSL
* antlr
* gFTL
* nccmp
* FLAP
* pFlogger
* gFTL-shared
* fArgParse

Consult the ChangeLog of the specific version number of these pakages.

Packages such as HDF-5 and OPeNDAP have already been implemented
there in a structure very similar to this one and can be imported very
easily if need arises.

For installation instructions, see file INSTALL.md
 
For additional information, contact Matthew.Thompson@nasa.gov


