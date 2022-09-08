
# add generated grammar to demo binary target
add_executable(print_tree print_tree.cpp)
target_include_directories(print_tree PRIVATE ${ANTLR4_INCLUDE_DIRS})
target_link_libraries(print_tree antlr4_static sprklr)
