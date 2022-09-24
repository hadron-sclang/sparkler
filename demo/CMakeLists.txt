add_executable(print_tree print_tree.cpp)
if(WIN32)
    set_property(TARGET print_tree PROPERTY
        MSVC_RUNTIME_LIBRARY "MultiThreadedDLL"
    )
endif()

target_link_libraries(print_tree sprklr)
