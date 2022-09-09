// print_tree.cpp: prints the parse tree of an input .sc or .scd file
#include "antlr4-runtime.h"
#include "SCLexer.h"
#include "SCParser.h"

#include <iostream>
#include <string>

int main(int argc, const char* argv[]) {
    if (argc != 2) {
      std::cerr << "usage: print_tree fileName.sc\n";
      return -1;
    }

    std::string filename(argv[1]);

    antlr4::ANTLRFileStream input;
    input.loadFromFile(filename);

    sprklr::SCLexer lexer(&input);
    antlr4::CommonTokenStream tokens(&lexer);
    tokens.fill();

    sprklr::SCParser parser(&tokens);
    antlr4::tree::ParseTree *tree = parser.root();

    if (parser.getNumberOfSyntaxErrors()) {
        for (auto token : tokens.getTokens()) {
            std::cout << token->toString() << std::endl;
        }

        std::cerr << filename << " got " << parser.getNumberOfSyntaxErrors() << " syntax errors.\n\n";
        return -1;
    }
/*
    std::cout << tree->toStringTree(&parser) << std::endl;
*/
    return 0;
}