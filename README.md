[![Codacy Badge](https://api.codacy.com/project/badge/Grade/8fbf2d9b0c044a63b34eeb6ab6e7add8)](https://www.codacy.com/manual/mathomp4/ESMA-Baselibs-CMake?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=mathomp4/ESMA-Baselibs-CMake&amp;utm_campaign=Badge_Grade) ![GitHub repo size](https://img.shields.io/github/repo-size/mathomp4/ESMA-Baselibs-CMake) ![GitHub release (latest by date)](https://img.shields.io/github/v/release/mathomp4/ESMA-Baselibs-CMake) ![GitHub issues](https://img.shields.io/github/issues/mathomp4/ESMA-Baselibs-CMake)

# ESMA Baselibs

This git repository contains a simplified version of the "baselibs"
module first developed by Gerhard Theurich and later maintained by Eugene
Mirvis, Denis Nadeau, and Matthew Thompson. 

These libraries are used to build the [GEOS Earth System
Models](https://github.com/GEOS-ESM/).

## Installation Instructions

The simple installation instructions are:
```
mkdir build
cd build
cmake ..
```

CMake will attempt to construct a default installation prefix (based on
`ESMF_COMM` and `ESMF_COMPILER`, see below) though you can override it
with `-DCMAKE_INSTALL_PREFIX=<path>`. (Note that due to GEOS oddities,
you'll want to have the last node of the installation directory end in
Linux or Darwin depending on your own OS. CMake will inform you if this
is not set correctly.)

### Options

There are five options for this build:

* `-DBUILD_MPI=ON|OFF`
   * This option is whether to build parallel HDF5 and thus support in
     netCDF. The default is **ON**
* `-DBUILD_CURL=ON|OFF`
   * Whether to build cURL. The default is **ON**
* `-DBUILD_HDFEOS=ON|OFF`
   * Whether to build HDF-EOS2. The default is **OFF**
* `-DBUILD_HDFEOS5=ON|OFF`
   * Whether to build HDF-EOS5. The default is **OFF**
* `-DBUILD_SDPTOOLKIT=ON|OFF`
   * Whether to build SDPToolkit. The default is **OFF**

### ESMF Options

This environment supports the passing in of three ESMF options:

* `ESMF_COMM`
* `ESMF_COMPILER`
* `ESMF_BOPT`

If none are provided, the system will try to automatically detect your
compiler and MPI stack and will set `ESMF_BOPT=O`. 


## Current State of Libraries

| Library                                                                  | Version     |
| ---                                                                      | ---         |
| [ESMF](https://www.earthsystemcog.org/projects/esmf/)                    | 8.0.1beta02 |
| [netCDF](https://github.com/Unidata/netcdf-c)                            | 4.7.4       |
| [netCDF Fortran](https://github.com/Unidata/netcdf-fortran)              | 4.5.2       |
| [netCDF C++](https://github.com/Unidata/netcdf-cxx4)                     | 4.3.1       |
| [HDF5](https://portal.hdfgroup.org/display/support)                      | 1.10.6      |
| [HDF4](https://portal.hdfgroup.org/display/support)                      | 4.2.15      |
| [pFUnit](https://github.com/Goddard-Fortran-Ecosystem/pFUnit)            | v4.1.7      |
| [gFTL](https://github.com/Goddard-Fortran-Ecosystem/gFTL)                | v1.2.5      |
| [gFTL-shared](https://github.com/Goddard-Fortran-Ecosystem/gFTL-shared)  | v1.0.5      |
| [fArgParse](https://github.com/Goddard-Fortran-Ecosystem/fArgParse)      | v0.9.3      |
| [pFlogger](https://github.com/Goddard-Fortran-Ecosystem/pFlogger)        | v1.4.1      |
| [yaFyaml](https://github.com/Goddard-Fortran-Ecosystem/yaFyaml)          | v0.3.1      |
| [antlr](https://www.antlr.org/)                                          | 2.7.7       |
| [GSL](https://www.gnu.org/software/gsl/)                                 | 2.6         |
| [jpeg](http://www.ijg.org/)                                              | 9c          |
| [zlib](http://www.zlib.net/)                                             | 1.2.11      |
| [szip](https://support.hdfgroup.org/doc_resource/SZIP/)                  | 2.1.1       |
| [cURL](https://curl.haxx.se/)                                            | 7.70.0      |
| [UDUNITS2](https://github.com/Unidata/UDUNITS-2)                         | 2.2.26      |
| [NCO](http://nco.sourceforge.net/)                                       | 4.9.1       |
| [CDO](https://code.mpimet.mpg.de/projects/cdo)                           | 1.9.8       |
| [nccmp](https://gitlab.com/remikz/nccmp)                                 | 1.8.7.0     |
| [FLAP](https://github.com/mathomp4/FLAP)                                 | geos/v1.9.0 |
| [HDF-EOS2](http://hdfeos.org/software/library.php)                       | 2.20        |
| [HDF-EOS5](http://hdfeos.org/software/library.php)                       | 1.16        |
| [SDP Toolkit](https://newsroom.gsfc.nasa.gov/sdptoolkit/TKDownload.html) | 5.2.20      |

For additional information, contact Matthew.Thompson@nasa.gov
