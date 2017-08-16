/*******************************************************************************
 * Brainfuck lexer
*******************************************************************************/

%{
#include "brainfuck.tab.h"
%}

%option noinput
%option nounput
%option noyywrap

%%

"<"		{ return PTR_DEC; }
">"		{ return PTR_INC; }
"-"		{ return DATA_DEC; }
"+"		{ return DATA_INC; }
"["		{ return LOOP_BEGIN; }
"]"		{ return LOOP_END; }
","		{ return READ; }
"."		{ return WRITE; }
"?"		{ return DUMP; }
"!"		{ return FLUSH; }
\n		{ }
.		{ }

%%
