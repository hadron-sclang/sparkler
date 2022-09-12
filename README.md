# Sparkler

A SuperCollider parser library.

## Background

A *parser* is a software tool that consumes an input source code string and produces an output parse tree. The parse
tree represents the structure of the input source code and is helpful for a variety of language analysis tasks.

Writing parsers can be tricky, a combination of subtle side effects and primarily repetitive boilerplate code. Parser
generators can help. They are programs that consume an input *grammar,* a document that describes the allowed patterns
of input program text; and produce output source code for a parser.

The SuperCollider interpreter uses a parser generator called Bison to generate its parser in sclang. During the
interpreter build process, Bison consumes the input grammar and generates C++ source code for parsing SuperCollider
programs. The Bison-generated parser inside SuperCollider is optimized for the compiler and produces an abstract syntax
tree that has already been pre-processed for subsequent stages in the interpreter process. As such, it's not as useful
for general language analysis purposes.

A parser that produces a *concrete* syntax tree which is a strict representation of the input program is useful for a
variety of purposes. It can help with code completion, automatic code reformatting, bug detection, and program
translation. To aid in parsing SuperCollider input, Sparkler provides a SuperCollider grammar for the ANTLR parser
generator. ANTLR can generate parsers in a variety of languages, including C++, Python, Java, JavaScript and more.

This is can be a confusing point when talking about parser generators; there can be up to three different programming
languages under consideration:

* The language the generated parser will parse, called the *input language* here. Sparkler includes a grammar to parse
  SuperCollider programs and could also be extended to parse inputs containing SCLang mixed with other inputs.
* The language the generated parser is in, here called the *parser language.* Sparkler currently supports generating
  C++ parsers but adding parser languages from the set that ANTLR already supports should be relatively
  straightforward. PRs welcome!
* The language the parser generator itself is written in, which we'll call the *implementation language*. ANTLR is
  written in Java.

At present, ANTLR doesn't support SuperCollider as a parser language. No one has yet written the requisite Java code
(ANTLR's implementation language) to generate SuperCollider output code. I'd like to include SuperCollider parser
generation for ANTLR in this project and will likely get to it at some point, but PRs welcome for this, too!

## Sparkler C++ Library

The CMakeLists.txt files describe a C++ library called `sprklr` that bundles the Sparkler SuperCollider parser with the
ANTLR C++ runtime static library. The `demo/` directory contains an example C++ program that prints the parse tree from
a provided input file.

## macOS

Homebrew includes ANTLR4:

`brew install antlr`

To get the [VScode ANTLR](https://github.com/mike-lischke/vscode-antlr4) extension working, install the
[JRE](https://www.java.com/en/download/).
