function(target_install target)
  # install the target and create export-set
  install(TARGETS ${target}
          EXPORT ${target}Targets
          LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
          ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
          RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
          INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
endfunction()

function(target_install_export target)
  # generate and install export file
  install(EXPORT ${target}Targets
          FILE ${target}Targets.cmake
          NAMESPACE ${target}::
          DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${target}
  )
endfunction()

function(target_set_version target version)
  string(REGEX MATCH "^([0-9]+)\..*" _ ${version})
  set_property(TARGET ${target} PROPERTY VERSION ${version})
  set_property(TARGET ${target} PROPERTY SOVERSION ${CMAKE_MATCH_1})
  set_property(TARGET ${target} PROPERTY
    INTERFACE_${target}_MAJOR_VERSION ${CMAKE_MATCH_1})
  set_property(TARGET ${target} APPEND PROPERTY
    COMPATIBLE_INTERFACE_STRING ${target}_MAJOR_VERSION
  )
endfunction()

function(target_generate_version target version)
  # generate the version file for the config file
  write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${target}ConfigVersion.cmake"
    VERSION "${version}"
    COMPATIBILITY AnyNewerVersion
  )
endfunction()

function(target_create_config)
  # create config file
  configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/${target}Config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${target}
  )
endfunction()

function(target_install_config target)
  # install config files
  install(FILES
            "${CMAKE_CURRENT_BINARY_DIR}/${target}Config.cmake"
            "${CMAKE_CURRENT_BINARY_DIR}/${target}ConfigVersion.cmake"
          DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${target}
  )
endfunction()

function(target_export target namespace)
  # generate the export targets for the build tree
  export(EXPORT ${target}Targets
        FILE "${CMAKE_CURRENT_BINARY_DIR}/cmake/${target}Targets.cmake"
        NAMESPACE ${namespace}::
  )
endfunction()

function(target_create_package)
  include(CMakePrintHelpers)

  set(options)
  set(oneValueArgs TARGET VERSION NAMESPACE)
  set(multiValueArgs)
  cmake_parse_arguments(PARSE_ARGV 0 ARGUMENT
    "${options}" "${oneValueArgs}" "${multiValueArgs}"
  )

  set(target ${ARGUMENT_TARGET})
  set(version ${ARGUMENT_VERSION})
  set(namespace ${ARGUMENT_NAMESPACE})
  if(NOT namespace)
    set(namespace ${target})
  endif()

  cmake_print_variables(namespace)

  # install the target and create export-set
  target_install(${target})

  # generate and install export file
  target_install_export(${target})

  # include CMakePackageConfigHelpers macro
  include(CMakePackageConfigHelpers)

  # set version
  # set(version 3.4.1)
  target_set_version(${target} ${version})

  # generate the version file for the config file
  target_generate_version(${target} ${version})

  # create config file
  target_create_config(${target})

  # install config files
  target_install_config(${target})

  # generate the export targets for the build tree
  target_export(${target} ${namespace})
endfunction()
