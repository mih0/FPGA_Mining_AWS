cmake_minimum_required (VERSION 2.8)

project(fpga_miner)

message(STATUS "Creating Make for 'fpga_miner'...")

# Confirm CURL Has Been Installed
find_path( CURL_INCLUDE_DIR curl/curl.h  PATHS ${PC_CURL_INCLUDEDIR} ${PC_CURL_INCLUDE_DIRS} PATH_SUFFIXES include )
find_library( CURL_LIBRARIES NAMES curl PATHS ${PC_CURL_LIBDIR} ${PC_CURL_LIBRARY_DIRS} PATH_SUFFIXES lib )

IF (CURL_INCLUDE_DIR AND CURL_LIBRARIES)
	SET(CURL_FOUND TRUE)
ELSE (CURL_INCLUDE_DIR AND CURL_LIBRARIES)
	SET(CURL_FOUND FALSE)
ENDIF (CURL_INCLUDE_DIR AND CURL_LIBRARIES)

IF (CURL_FOUND)
	message(STATUS "  CURL:   Found")
ELSE (CURL_FOUND)
	message(STATUS "  CURL:   Not Found!")
ENDIF (CURL_FOUND)

# Confirm AWS SDK Has Been Installed
SET(AWS_SDK_INCLUDE_DIRS /path/to/include/aws CACHE STRING "aws-cpp-sdk include directories")
SET(AWS_SDK_CORE_LIB "-l:/path/to/libaws-cpp-sdk-core.so" CACHE STRING "aws-cpp-sdk link core lib")

FIND_PATH( AWS_SDK_INCLUDE_DIRS curl/curl.h  PATHS ${AWS_SDK_INCLUDE_DIRS}  PATH_SUFFIXES include )
FIND_LIBRARY( AWS_SDK_CORE_LIB NAMES fpga_mgmt PATHS ${AWS_SDK_CORE_LIB} PATH_SUFFIXES lib )

IF (AWS_SDK_INCLUDE_DIRS AND AWS_SDK_CORE_LIB)
	SET(SDK_FOUND TRUE)
ELSE (AWS_SDK_INCLUDE_DIRS AND AWS_SDK_CORE_LIB)
	SET(SDK_FOUND FALSE)
ENDIF (AWS_SDK_INCLUDE_DIRS AND AWS_SDK_CORE_LIB)

IF (SDK_FOUND)
	message(STATUS "  AWS SDK: Found")
ELSE (SDK_FOUND)
	message(STATUS "  AWS SDK: Not Found!")
ENDIF (SDK_FOUND)

add_subdirectory(compat/jansson)

include_directories( ~/aws-fpga/sdk/userspace/include  ~/aws-fpga/sdk/userspace/include/hal ${PROJECT_SOURCE_DIR} ${PROJECT_SOURCE_DIR}/algo ${PROJECT_SOURCE_DIR}/compat/jansson ${CURL_INCLUDE_DIR} ${LIBUSB_INCLUDE_DIR} ${AWS_SDK_INCLUDE_DIRS})

set(SRC_LIST fpga-miner.c
		api.c
		fpgautils.c
		util.c
		./algo/blakecoin.c
		./algo/decred.c
		./algo/groestl.c
		./algo/myr-groestl.c
		./algo/nist5.c
		./algo/phi.c
		./algo/poly.c
		./algo/sha2.c
		./algo/skunk.c
		./algo/tribus.c
		./sha3/mod_blakecoin.c
		./sha3/blake.c
		./sha3/cubehash.c
		./sha3/fugue.c
		./sha3/echo.c
		./sha3/gost.c
		./sha3/groestl.c
		./sha3/haval.c
		./sha3/jh.c
		./sha3/keccak.c
		./sha3/luffa.c
		./sha3/sha2.c
		./sha3/shabal.c
		./sha3/skein.c
	)
			
set(TARGET_NAME fpga_miner)

IF ( WIN32 )
	add_executable(${TARGET_NAME} ${SRC_LIST} ./compat/winansi.c)
ELSE ( WIN32 )
	add_executable(${TARGET_NAME} ${SRC_LIST})
ENDIF ( WIN32 )

target_link_libraries(${TARGET_NAME} crypto pthread ${CURL_LIBRARIES} jansson fpga_mgmt)

IF(WIN32)
	target_link_libraries(${TARGET_NAME} libcurl Ws2_32)
ENDIF(WIN32)

IF(UNIX)
	target_link_libraries(${TARGET_NAME} m)
ENDIF(UNIX)

set_target_properties( ${TARGET_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR} )
