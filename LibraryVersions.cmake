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

set(CURL_VERSION           7.69.1)
set(CURL_URL               https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.xz)
set(CURL_HASH              SHA512=dcb917ce9a6f34b30adae10e2e635d7a8c67781d69789cc5617ab2b49e898394ecfeee546453b14ab168d4b3b52baf974b2ec07e7a4b199addbc1ba57274d8fa)

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

set(NETCDF_VERSION         4.7.3)
set(NETCDF_URL             https://github.com/Unidata/netcdf-c/archive/v${NETCDF_VERSION}.tar.gz)
set(NETCDF_HASH            SHA512=5cef5b3499b230b503f87d99cbf5d1ef107550f81489d9be6bb64740692fdd6f967f95f6cb2ab6174d968ee77a08a4e5f3f9d401b2ebc6b482c0e7ded6036f7a)

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

set(FLAP_VERSION           geos/v1.5.0 )
set(FLAP_URL               https://github.com/mathomp4/FLAP/archive/${FLAP_VERSION}.tar.gz)
set(FLAP_HASH              SHA512=18ed3b740ff1bba31949739203f12370ac1f9f1e17282d7bacc7871ca4bf1c6233298e6e7e87227d59e0f99677c6c7fe80a7a2ce71d5b370947d2aff409cd27e)

########
# gFTL #
########

set(GFTL_VERSION           v1.2.5)
set(GFTL_URL               https://github.com/Goddard-Fortran-Ecosystem/gFTL/archive/${GFTL_VERSION}.tar.gz)
set(GFTL_HASH              SHA512=6a2f5f1bfa2dc3d90bbb6d9a02407a1b7cbac2b9e34be8e9d0470aba529286907e830e4269f7f888f9ddf15fa24184930fa98db6514adfe78fd428fd6c46bcd8)

###############
# gFTL-shared #
###############

set(GFTL_SHARED_VERSION    v1.0.5)
set(GFTL_SHARED_URL        https://github.com/Goddard-Fortran-Ecosystem/gFTL-shared/archive/${GFTL_SHARED_VERSION}.tar.gz)
set(GFTL_SHARED_HASH       SHA512=87e627d6f48c50550c010e15739bd1fec57edeb06f80389aebd8981ec050f7f2e7f7eb117442221ec3f7f5646a6a9e98b67605f26018b9bbe063fb2627224508)

##########
# pFUnit #
##########

set(PFUNIT_VERSION         v4.1.7)
set(PFUNIT_URL             https://github.com/Goddard-Fortran-Ecosystem/pFUnit/archive/${PFUNIT_VERSION}.tar.gz)
set(PFUNIT_HASH            SHA512=2ddd9b0d7acf2dd342468da9df6e290ef483631c1dea114e44b93bfef5fb6116121cbc5b4b1c0dca8776311609ff8d49f0c568a4571fa158052d05022d0101d5)

#############
# fArgParse #
#############

set(FARGPARSE_VERSION      v0.9.3)
set(FARGPARSE_URL          https://github.com/Goddard-Fortran-Ecosystem/fArgParse/archive/${FARGPARSE_VERSION}.tar.gz)
set(FARGPARSE_HASH         SHA512=84e1382d39b9a075d48b40ccd9879228d559c8c5ebbfd1c90b7c681abad5f866c4586030f7fa07f4ca20259a698bbaff4c663b254d53a0a9956c830361cc957b)

############
# pFlogger #
############

set(PFLOGGER_VERSION       v1.4.0)
set(PFLOGGER_URL           https://github.com/Goddard-Fortran-Ecosystem/pFlogger/archive/${PFLOGGER_VERSION}.tar.gz)
set(PFLOGGER_HASH          SHA512=bd1b903dee6ca0272a39c0037d516f8e2c8114a038f172c060ffd818276ef8fccf94e7a1f0ef651a9a0c8a7ae67513f6433e324710c94903677fbda56aa82d62)

###########
# yaFyaml #
###########

set(YAFYAML_VERSION        v0.3.1)
set(YAFYAML_URL            https://github.com/Goddard-Fortran-Ecosystem/yaFyaml/archive/${YAFYAML_VERSION}.tar.gz)
set(YAFYAML_HASH           SHA512=eb42cce8480f8978e3e92fff5d864bc7770311f21c6b78deda5e6a7266490679d6c14e419da4034c8152b6e488f73b04c9daba5abecbfe5fadf34e65c66643be)

#######
# NCO #
#######

set(NCO_VERSION            4.9.1)
set(NCO_URL                https://github.com/nco/nco/archive/${NCO_VERSION}.tar.gz)
set(NCO_HASH               SHA512=00c785ff5a34313df53d5d4d3badcdc358368b15099f7a2a8e0fe11efdbdee20859a31b93e3609bee7c7a1f9dba60a0897abb101243085f0316fbcb8b02ba2f8)

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

set(NCCMP_VERSION          1.8.6.5)
set(NCCMP_URL              https://gitlab.com/remikz/nccmp/-/archive/${NCCMP_VERSION}/nccmp-${NCCMP_VERSION}.tar.bz2)
set(NCCMP_HASH             SHA512=aaf0e1b56336b48bfffe1f705fbae65b280d63ca1efab065ee4ce37b114b2ffce35823d027f37685bc0b57ac6a326c26634ebf6bb3cd7e3957cb5c42122249ef)

############
# HDF-EOS2 #
############

set(HDFEOS_VERSION         2.20v1.00)
set(HDFEOS_URL             https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos/latest_release/HDF-EOS${HDFEOS_VERSION}.tar.Z)
set(HDFEOS_HASH            SHA512=9ca7cf96d7357c02e82e9290aed5343fdbf27afcbaa755794fbf51f5f27ce3f02e6d9e15a69ced4136d5e9e2610448cc720af049430cd26e37c194983717400a)

############
# HDF-EOS5 #
############

set(HDFEOS5_VERSION        5.1.16)
set(HDFEOS5_URL            https://observer.gsfc.nasa.gov/ftp/edhs/hdfeos5/latest_release/HDF-EOS${HDFEOS5_VERSION}.tar.Z)
set(HDFEOS5_HASH           SHA512=d6576ef796903c7df97edc8f6ae8641c08dec7342f36c7a6ece361f696a7543281bbd7485fc47562a300b0bad87289e25322812bb6997d0191639eb5688424a8)

###############
# SDP Toolkit #
###############

set(SDPTK_VERSION          5.2.20v1.01)
set(SDPTK_URL              https://observer.gsfc.nasa.gov/ftp/edhs/sdptk/latest_release/SDPTK${SDPTOOLKIT_VERSION}.tar.Z)
set(SDPTK_HASH             SHA512=446b3976dd4f21af5ea421dc325d6c8edbb8ea5178e02d37572b143726c0367740d2b07ef48120a5bd31ef700a34c34138f89c21215a921ce877cefbdf159d98)
