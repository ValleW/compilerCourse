#include <iostream>
#include <fstream>
#include "binary.tab.hh"
extern std::string toWrite;
extern Node root;
extern FILE *yyin;

void yy::parser::error(std::string const&err)
{
  std::cout << "It's one of the bad ones... " << err << std::endl;
}

int main(int argc, char **argv)
{
	yy::parser parser;
	yyin = fopen(argv[1], "r");
	
  	if(!parser.parse())
    	root.dump();
    	
    	std::ofstream outfile("parse.dot");
    	root.dumps_dot(outfile);
    	outfile.close();
  	return 0;
}
