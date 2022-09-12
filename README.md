# Sparkler

A SuperCollider parser library.

Sparkler uses ANTLR to generate SuperCollider parsers in C++, Python,
and JavaScript. We also plan to add unofficial parser generator support
to ANTLR to generate a SuperCollider parser in SuperCollider.

# Using the Generated Parsers

The SuperCollider grammar files are in the `grammar` folder. The ANTLR
program can generate code in a variety of languages. The generated code
can parse SuperCollider input programs to produce a parse tree.

# Rebuilding The Parser Libraries

TBD

## macOS

Homebrew includes ANTLR4:

`brew install antlr`

To get the [VScode ANTLR](https://github.com/mike-lischke/vscode-antlr4)
extension working, install the [JRE](https://www.java.com/en/download/).
