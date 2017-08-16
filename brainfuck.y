/*******************************************************************************
 * Brainfuck parser
*******************************************************************************/
%{
#include <stdbool.h>
#include <stdio.h>

static void header();
static void footer();
static void ptr_inc();
static void ptr_dec();
static void data_inc();
static void data_dec();
static void read();
static void write();
static void data_dump();
static void data_flush();
static void loop_begin();
static void loop_end();

extern int yylex(); 

extern int yylineno;
extern FILE *out_file;
extern size_t stack_size;

extern bool assembly_output;
extern FILE *out_file;
extern size_t stack_size;

void yyerror(const char *p) { fprintf(stderr, "%s at line %d\n", p, yylineno); }

%}

%token PTR_INC PTR_DEC
%token DATA_INC DATA_DEC
%token LOOP_BEGIN LOOP_END
%token READ WRITE
%token DUMP FLUSH UNKNOWN

/*******************************************************************************
 * Grammar rules
*******************************************************************************/

%%

start: begin prog end
	 ;

begin: /* epsilon */	{ header(); }
	 ;

prog: /* epsilon */
	 | instr prog
	 ;

instr: PTR_INC			{ ptr_inc(); }
	 | PTR_DEC			{ ptr_dec(); }
	 | DATA_INC			{ data_inc(); }
	 | DATA_DEC			{ data_dec(); }
	 | READ				{ read(); }
	 | WRITE			{ write(); }
	 | DUMP				{ data_dump(); }
	 | FLUSH			{ data_flush(); }
	 | loop         	{ }
	 ;

loop: loop_begin prog loop_end
	;

loop_begin: LOOP_BEGIN	{ loop_begin(); }
		  ;

loop_end: LOOP_END		{ loop_end(); }
		;

end: /* epsilon */		{ footer(); }
   ;


%%

/*******************************************************************************
 * Function definitions
*******************************************************************************/

void
header()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "#include <stdio.h>\n");
		fprintf(out_file, "#include <stdlib.h>\n");
		fprintf(out_file, "\n");
		fprintf(out_file, "#include <string.h>\n");
		fprintf(out_file, "\n");
		fprintf(out_file, "#define STACK_SIZE %zu\n", stack_size);
		fprintf(out_file, "\n");
		fprintf(out_file, "int\n");
		fprintf(out_file, "main(int argc, char *argv[])\n");
		fprintf(out_file, "{\n");
		fprintf(out_file, "\tuint8_t stack[STACK_SIZE];\n");
		fprintf(out_file, "\tsize_t ptr;\n");
		fprintf(out_file, "\tchar c;\n");
		fprintf(out_file, "\tint i;\n");
		fprintf(out_file, "\n");
		fprintf(out_file, "\tmemset(stack, 0x00, STACK_SIZE);\n");
		fprintf(out_file, "\tptr = 0;\n");
	}
}

void
footer()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\treturn 0;\n");
		fprintf(out_file, "}\n");
	}
}

void
ptr_inc()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\tptr++;\n");
	}
}

void
ptr_dec()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\tptr--;\n");
	}
}

void
data_inc()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\tstack[ptr]++;\n");
	}
}

void
data_dec()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\tstack[ptr]--;\n");
	}
}

void
read()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\tc = getchar();\n");
		fprintf(out_file, "\tstack[ptr] = c;\n");
	}
}

void
write()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\tprintf(\"%%c\", stack[ptr]);\n");
	}
}

void
data_dump()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\tprintf(\"%%zu: \", ptr);\n");
		fprintf(out_file, "\tfor ( i = 0 ; i < STACK_SIZE - 1 ; ++i )\n");
		fprintf(out_file, "\t{\n");
		fprintf(out_file, "\t\tprintf(\"%%02x \",stack[i]);\n");
		fprintf(out_file, "\t}\n");
		fprintf(out_file, "\tprintf(\"%%02x\\n\",stack[STACK_SIZE  - 1]);\n");
	}
}

void
data_flush()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\tmemset(stack, 0x00, STACK_SIZE);\n");
		fprintf(out_file, "\tptr = 0;\n");
	}
}

void
loop_begin()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\twhile(stack[ptr])\n");
		fprintf(out_file, "\t{\n");
	}
}

void
loop_end()
{
	if ( assembly_output ) {
	} else {
		fprintf(out_file, "\t}\n");
	}
}
