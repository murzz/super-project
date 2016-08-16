set(COMMON_CMAKE_ARGS )

# parallel build
if (MSVC)
   set(COMMON_CMAKE_ARGS
      ${COMMON_CMAKE_ARGS}
      -DCMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP"
      -DCMAKE_C_FLAGS "${CMAKE_C_FLAGS} /MP"
   )
   set(ENV{CL} "/MP")
endif (MSVC)
