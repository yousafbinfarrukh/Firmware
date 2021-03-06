include(nuttx/px4_impl_nuttx)

add_definitions(
	-DFLASH_BASED_PARAMS
	-DPARAM_NO_ORB
	-DPARAM_NO_AUTOSAVE
	-DPARAMETER_BUFFER_SIZE=1024
)

px4_nuttx_configure(HWCLASS m4 CONFIG nsh)

# UAVCAN boot loadable Module ID
set(uavcanblid_sw_version_major 0)
set(uavcanblid_sw_version_minor 1)
add_definitions(
	-DAPP_VERSION_MAJOR=${uavcanblid_sw_version_major}
	-DAPP_VERSION_MINOR=${uavcanblid_sw_version_minor}
	)

# Bring in common uavcan hardware identity definitions
include(configs/uavcan_board_ident/esc35-v1)
add_definitions(
	-DHW_UAVCAN_NAME=${uavcanblid_name}
	-DHW_VERSION_MAJOR=${uavcanblid_hw_version_major}
	-DHW_VERSION_MINOR=${uavcanblid_hw_version_minor}
)

px4_nuttx_make_uavcan_bootloadable(BOARD ${BOARD}
	BIN ${CMAKE_CURRENT_BINARY_DIR}/src/firmware/nuttx/esc35-v1.bin
	HWNAME ${uavcanblid_name}
	HW_MAJOR ${uavcanblid_hw_version_major}
	HW_MINOR ${uavcanblid_hw_version_minor}
	SW_MAJOR ${uavcanblid_sw_version_major}
	SW_MINOR ${uavcanblid_sw_version_minor}
)

set(config_module_list
	#
	# Board support modules
	#
	drivers/boards
	drivers/device
	drivers/led
	drivers/stm32

	#
	# System commands
	#
	systemcmds/config
	systemcmds/reboot
	systemcmds/top
	systemcmds/param
	systemcmds/ver

	#
	# General system control
	#
	modules/uavcanesc
	modules/uavcanesc/nshterm
	modules/uavcanesc/commands/cfg
	modules/uavcanesc/commands/selftest
	modules/uavcanesc/commands/dc
	modules/uavcanesc/commands/rpm
	modules/uavcanesc/commands/stat

	#
	# Library modules
	#
	lib/micro-CDR
	lib/version
	modules/systemlib
	modules/systemlib/param
	modules/uORB
	platforms/common
	platforms/nuttx
	platforms/nuttx/px4_layer
)
