#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <getopt.h>

#define DEFAULT_STACK_SIZE 30000

extern FILE *yyin;
extern int yyparse(void);

// Options description
static struct option longopts[] = {
	{ "assembly", no_argument,       NULL, 'a' },
	{ "help",     no_argument,       NULL, 'h' },
	{ "output",   required_argument, NULL, 'o' },
	{ "stack",    required_argument, NULL, 's' },
	{ NULL,       0,                 NULL, 0 }
};

bool assembly_output = false;
FILE *in_file        = NULL;
FILE *out_file       = NULL;
size_t stack_size    = DEFAULT_STACK_SIZE;

static void usage(const char*);

int
main(int argc, char *argv[])
{
	int ret = EXIT_FAILURE;
	int c;
	char *in_path = NULL, *out_path = NULL;

	while ((c = getopt_long(argc, argv, "aho:s:", longopts, NULL)) != -1) {
		switch (c) {
			case 'a':
				// Generate assembly rather than C
				assembly_output = true;
				break;
			case 'h':
				usage(argv[0]);
				ret = EXIT_SUCCESS;
				goto cleanup;
			case 'o':
				// Set output file
				out_path = optarg;
				break;
			case 's':
				// Set stack size
				stack_size = atoi(optarg);
				break;
			default:
				usage(argv[0]);
				goto cleanup;
				break;
		}
	}

	// Get input file path from the command line if specified
	if ( optind < argc ) {
		in_path = argv[optind];
	}

	// Check that the stack size is valid
	if ( stack_size < 1 ) {
		usage(argv[0]);
		goto cleanup;
	}

	// Set input file
	if ( NULL != in_path ) {
		in_file = fopen(in_path, "r");

		if ( NULL == in_file ) {
			perror(in_path);
			goto cleanup;
		}
	} else {
		in_file = stdin;
	}

	// Set output file
	if ( NULL != out_path ) {
		out_file = fopen(out_path, "w");

		if ( NULL == out_file ) {
			perror(out_path);
			goto cleanup;
		}
	} else {
		out_file = stdout;
	}

	// Run parser
	yyin = in_file;
	yyparse();

	ret = EXIT_SUCCESS;
cleanup:
	if ( NULL != in_path )  { fclose(in_file); }
	if ( NULL != out_path ) { fclose(out_file); }

	return ret;
}

void
usage(const char *program_name)
{
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "\t%s [OPTIONS] INPUT_FILE\n", program_name);
	fprintf(stderr, "\n");
	fprintf(stderr, "Options:\n");
	fprintf(stderr, "\t-a, --assembly\tproduce assembly output\n");
	fprintf(stderr, "\t-h, --help\tdisplay this help and quit\n");
	fprintf(stderr, "\t-o FILE, --output=FILE\tspecify output file (default: standard output)\n");
	fprintf(stderr, "\t-s NUM, --stack=NUM\tset the stack size in bytes (default: %d)\n", DEFAULT_STACK_SIZE);
	fprintf(stderr, "\nIf INPUT_FILE is not specified, the program reads from the standard input\n");
}
