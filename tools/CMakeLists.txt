add_custom_target(tools)

include(python.cmake)

if (WITH_NINJA)
   include(ninja.cmake)
else()
   add_custom_target(ninja)
endif()

include(perl.cmake)

if (WITH_CMAKE)
   include(cmake.cmake)
else()
   add_custom_target(cmake)
endif()

include(jom.cmake)

include(opkg.cmake)
