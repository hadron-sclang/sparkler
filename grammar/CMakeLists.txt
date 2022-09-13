# add macros to generate ANTLR Cpp code from grammar
find_package(ANTLR REQUIRED)

# Call macro to add lexer and grammar to your build dependencies.
antlr_target(SCLexer SCLexer.g4 LEXER
             PACKAGE sprklr)
antlr_target(SCParser SCParser.g4 PARSER
             PACKAGE sprklr
             DEPENDS_ANTLR SCLexer
             COMPILE_FLAGS -lib ${ANTLR_SCLexer_OUTPUT_DIR}
             LISTENER
             VISITOR)

add_library(sprklr STATIC
            ${ANTLR_SCLexer_CXX_OUTPUTS}
            ${ANTLR_SCParser_CXX_OUTPUTS})

target_include_directories(sprklr PUBLIC
    ${ANTLR4_INCLUDE_DIRS}
    ${ANTLR_SCLexer_OUTPUT_DIR}
    ${ANTLR_SCParser_OUTPUT_DIR}
)

target_link_libraries(sprklr
    antlr4_static
)
