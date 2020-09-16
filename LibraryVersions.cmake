#########
# antlr #
#########

set(ANTLR_VERSION          2.7.7)
set(ANTLR_URL              http://dust.ess.uci.edu/nco/antlr-${ANTLR_VERSION}.tar.gz)
set(ANTLR_HASH             SHA512=130b5d7ea676f28f75fe75da9b5e11caf6d6c92f51e33ff80a9f624735c8da8a3d62a2ef7e86a6812c932984fa56525388124d9314c0a6bd418ab97b078d85cb)

#######
# GSL #
#######

set(GSL_VERSION            2.6)
set(GSL_URL                http://mirrors.ibiblio.org/gnu/ftp/gnu/gsl/gsl-${GSL_VERSION}.tar.gz)
set(GSL_HASH               SHA512=0be8240715f0b86aba2c63d9f12da4dba4719d4e350e9308d279e0dd3b2f0519ea26fd2e38a17f3e8cf43aacbaa2455207a7ca0d6c305f3b8725e8ece2250a74)

########
# jpeg #
########

set(JPEG_VERSION           9c)
set(JPEG_URL               http://www.ijg.org/files/jpegsrc.v${JPEG_VERSION}.tar.gz)
set(JPEG_HASH              SHA512=2b581c60ae401a79bbbe748ff2deeda5acd50bfd2ea22e5926e36d34b9ebcffb6580b0ff48e972c1441583e30e21e1ea821ca0423f9c67ce08a31dffabdbe6b7)

########
# zlib #
########

set(ZLIB_VERSION           1.2.11)
set(ZLIB_URL               http://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz)
set(ZLIB_HASH              SHA512=73fd3fff4adeccd4894084c15ddac89890cd10ef105dd5e1835e1e9bbb6a49ff229713bd197d203edfa17c2727700fce65a2a235f07568212d820dca88b528ae)

########
# szip #
########

set(SZIP_VERSION           2.1.1)
set(SZIP_URL               https://support.hdfgroup.org/ftp/lib-external/szip/${SZIP_VERSION}/src/szip-${SZIP_VERSION}.tar.gz)
set(SZIP_HASH              SHA512=ada6406efb096cd8a2daf8f9217fe9111a96dcae87e29d1c31f58ddd2ad2aa7bac03f23c7205dc9360f3b62d259461759330c7189ef0c2fe559704b1ea9d40dd)

########
# cURL #
########

set(CURL_VERSION           7.72.0)
set(CURL_URL               https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.xz)
set(CURL_HASH              SHA512=e5025a32eac6108ccb13d1fcce9c2de28b3a6d6e9a258a647c4be45d71718f75653e1ccd477ef5f29242a15588255c4ef43fe47bf9908b938b6769fccfaac107)

########
# HDF4 #
########

set(HDF4_VERSION           4.2.15)
set(HDF4_URL               https://support.hdfgroup.org/ftp/HDF/releases/HDF${HDF4_VERSION}/src/hdf-${HDF4_VERSION}.tar.gz)
set(HDF4_HASH              SHA512=7fdd3422e184e6e2bce018a753d3667771e0c20dfa41041cfa2c10eb65761d36d735679bfdb2d8813d9dfdd8ee99d170debecf487e9a892ca9e24b91a0e21d2b)

########
# HDF5 #
########

set(HDF5_MMVERSION         1.10)
set(HDF5_VERSION           1.10.6)
set(HDF5_URL               https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_MMVERSION}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz)
set(HDF5_HASH              SHA512=7667e65194b13df47cbc66fa36ff9aca02d65f8b96a0a5dd91af6932062aaff7a048b29df3b3664ec75aa75ddd531f3d03e3b171e2eb30ff0d8b0f9a647b0f41)

############
# netCDF-C #
############

set(NETCDF_VERSION         4.7.4)
set(NETCDF_URL             https://github.com/Unidata/netcdf-c/archive/v${NETCDF_VERSION}.tar.gz)
set(NETCDF_HASH            SHA512=15922818fdd71be285eb7dd2fc9be2594fe9af979de3ed316465636c7bbdaec65eb151ca57ef8b703e6a360cdba036b8f9bc193ddff01ff7ce4214c0a66efa79)

##################
# netcdf-Fortran #
##################

set(NETCDF_FORTRAN_VERSION 4.5.2)
set(NETCDF_FORTRAN_URL     https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz)
set(NETCDF_FORTRAN_HASH    SHA512=d9f5463ee31dab62d5a1b2feb0c780c344978f179237cd23f92ea32a4b400910a66a9ac4e446be734166ecc7578ef25a7183b4444926a6f386d9a5e02d1cf4f6)

###############
# netcdf-CXX4 #
###############

set(NETCDF_CXX4_VERSION    4.3.1)
set(NETCDF_CXX4_URL        https://github.com/Unidata/netcdf-cxx4/archive/v${NETCDF_CXX4_VERSION}.tar.gz)
set(NETCDF_CXX4_HASH       SHA512=404711eb80d5e78968c0f6cbdcb08855a2778d7fd94e7ee94bdc9d1cd72848ac3327613c6437a7634349f26bc463b950092a2999abb34ddab0a47ad185547d22)

########
# FLAP #
########

#set(FLAP_VERSION           geos/v1.9.0 )
#set(FLAP_URL               https://github.com/mathomp4/FLAP/archive/${FLAP_VERSION}.tar.gz)
#set(FLAP_HASH              SHA512=fbfc1363da52670f680e8aafc6f14a4717349e8a9b697b0e078e654b56de56d1199bf577c31e562106ce61f853b19ab493980a1c926bbafa0eef9b2ad74879d6)

########
# gFTL #
########

set(GFTL_VERSION           v1.2.6)
set(GFTL_URL               https://github.com/Goddard-Fortran-Ecosystem/gFTL/archive/${GFTL_VERSION}.tar.gz)
set(GFTL_HASH              SHA512=926da1d98e022113b6e8b27dd92a4e21dd69e2d5a5661af8c57004c0db330c36ce40d39e9773745dd805ad9e438162a8e0ca899111f7c12602a31c89609eb6c0)

###############
# gFTL-shared #
###############

set(GFTL_SHARED_VERSION    v1.0.7)
set(GFTL_SHARED_URL        https://github.com/Goddard-Fortran-Ecosystem/gFTL-shared/archive/${GFTL_SHARED_VERSION}.tar.gz)
set(GFTL_SHARED_HASH       SHA512=88a6cf8cdee555b8a275d590b6e36bdd27763fe2a5336a46c630ee7dd1439125c51159822a05db8c6ad4ea22c05eb01ff8665af9cbd28ff2746a1fb68d973c78)

##########
# pFUnit #
##########

set(PFUNIT_VERSION         v4.1.12)
set(PFUNIT_URL             https://github.com/Goddard-Fortran-Ecosystem/pFUnit/archive/${PFUNIT_VERSION}.tar.gz)
set(PFUNIT_HASH            SHA512=e75e4015ac1026e6c8d80a17bb77efbe5980bfdbaf7c6008e73506a6c390fdde231b837366276ad899566c0e02d86d18eec168c58d0f0602cc4f43f2613e9a73)

#############
# fArgParse #
#############

set(FARGPARSE_VERSION      v1.0.0)
set(FARGPARSE_URL          https://github.com/Goddard-Fortran-Ecosystem/fArgParse/archive/${FARGPARSE_VERSION}.tar.gz)
set(FARGPARSE_HASH         SHA512=fbaede237a1cdf209a22f0c27b529dadcecd618394bace32c56bff53a9c3b6953d03db08bfc3b00421420af3f3bf403784ec2e042289db6e156e286a328f9748)

############
# pFlogger #
############

set(PFLOGGER_VERSION       v1.4.5)
set(PFLOGGER_URL           https://github.com/Goddard-Fortran-Ecosystem/pFlogger/archive/${PFLOGGER_VERSION}.tar.gz)
set(PFLOGGER_HASH          SHA512=382c64c134641993fbf8c926700b0162dedb61c1b4a09d7e75a8eb6d2042cb11aaa0f230bf45bcd9ffe252c79c61917d8e13db78acae66750a74694f8485c060)

###########
# yaFyaml #
###########

set(YAFYAML_VERSION        v0.4.1)
set(YAFYAML_URL            https://github.com/Goddard-Fortran-Ecosystem/yaFyaml/archive/${YAFYAML_VERSION}.tar.gz)
set(YAFYAML_HASH           SHA512=7c3d6e24ee6b96b2e2795969841d9b1cfde2a861702ac6f962b3b58a80b85094b57aa524f785eee3887b60d41549ce3a66a9c4dfdd31da3804dcb588cd42a459)

#######
# NCO #
#######

set(NCO_VERSION            4.9.3)
set(NCO_URL                https://github.com/nco/nco/archive/${NCO_VERSION}.tar.gz)
set(NCO_HASH               SHA512=25da4b937dfe935f91857eee2eef7c0d4f57e2ade32b1cd5fd7b7888840fc4be8d4e5080dc95d90ad0586e86efc02d46d223e2a0d06637305ce4704e742bb648)

########
# ESMF #
########

#set(ESMF_VERSION )
#set(ESMF_URL )
#set(ESMF_HASH SHA512= )

############
# UDUNITS2 #
############

set(UDUNITS2_VERSION       2.2.26)
set(UDUNITS2_URL           ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-${UDUNITS2_VERSION}.tar.gz)
set(UDUNITS2_HASH          SHA512=9e5320454646458ac40ba0855b6b8e12f7edbdb4b9a6c687a4c38ad07400e2e0c0f7968069885f83eb73da64886e1c6dd1e462ebc23205df849c3a460cedb640)

#######
# CDO #
#######

set(CDO_VERSION            1.9.8)
set(CDO_ODDITY             20826)
set(CDO_URL                https://code.mpimet.mpg.de/attachments/download/${CDO_ODDITY}/cdo-${CDO_VERSION}.tar.gz)
set(CDO_HASH               SHA512=05bcaac5971dbcb5b3169b0ebf0939f2d727b0506beaee8364282d27fac03046dbc130241ec2501e8b261349365096f79bbbdb9bd67aae4488baea8c1343d2b2)

#########
# nccmp #
#########

set(NCCMP_VERSION          1.8.7.0)
set(NCCMP_URL              https://gitlab.com/remikz/nccmp/-/archive/${NCCMP_VERSION}/nccmp-${NCCMP_VERSION}.tar.bz2)
set(NCCMP_HASH             SHA512=0d00786f09829722c4ffae403007f8b9f1308456e92a75828c46f71d81d35d7fbab5d661fede02afbc3b566515bc61fac887fb37d315436f3d501e62a1fb58db)

############
# HDF-EOS2 #
############

set(HDFEOS_VERSION         2.20v1.00)
set(HDFEOS_URL             https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos/cb0f900d2732ab01e51284d6c9e90d0e852d61bba9bce3b43af0430ab5414903?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS2.20v1.00.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS2.20v1.00.tar.Z)
set(HDFEOS_HASH            SHA512=9ca7cf96d7357c02e82e9290aed5343fdbf27afcbaa755794fbf51f5f27ce3f02e6d9e15a69ced4136d5e9e2610448cc720af049430cd26e37c194983717400a)

############
# HDF-EOS5 #
############

set(HDFEOS5_VERSION        5.1.16)
set(HDFEOS5_URL            https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/hdfeos5/7054de24b90b6d9533329ef8dc89912c5227c83fb447792103279364e13dd452?response-content-disposition=attachment%3B%20filename%3D%22HDF-EOS5.1.16.tar.Z%22%3B%20filename*%3Dutf-8%27%27HDF-EOS5.1.16.tar.Z)
set(HDFEOS5_HASH           SHA512=d6576ef796903c7df97edc8f6ae8641c08dec7342f36c7a6ece361f696a7543281bbd7485fc47562a300b0bad87289e25322812bb6997d0191639eb5688424a8)

###############
# SDP Toolkit #
###############

set(SDPTK_VERSION          5.2.20v1.01)
set(SDPTK_URL              https://git.earthdata.nasa.gov/rest/git-lfs/storage/DAS/sdptoolkit/a7ccbb33de2fddf1bafb718cd2d57b9f7ea0416cd80ccb4cf03bd1ec9080d96b?response-content-disposition=attachment%3B%20filename%3D%22SDPTK5.2.20v1.01.tar.Z%22%3B%20filename*%3Dutf-8%27%27SDPTK5.2.20v1.01.tar.Z)
set(SDPTK_HASH             SHA512=446b3976dd4f21af5ea421dc325d6c8edbb8ea5178e02d37572b143726c0367740d2b07ef48120a5bd31ef700a34c34138f89c21215a921ce877cefbdf159d98)
