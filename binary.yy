%skeleton "lalr1.cc"
%defines
%define api.value.type variant
%define api.token.constructor
%code requires{
	#include "Node.h"
}
%code{
    #include <string>
    #define YY_DECL yy::parser::symbol_type yylex()

    YY_DECL;

    Node root;
}

%type <Node> Chunk
%type <Node> ChunkRep
%type <Node> Block
%type <Node> Stat
%type <Node> Laststat
%type <Node> Funcname
%type <Node> FuncnameRep
%type <Node> Function
%type <Node> Functioncall
%type <Node> Functionbody
%type <Node> Parameterlist
%type <Node> Arguments

%type <Node> If
%type <Node> Elseiflist
%type <Node> Elseif
%type <Node> Else
%type <Node> Var
%type <Node> Varlist
%type <Node> Exp
%type <Node> Explist
%type <Node> Prefixexp

%type <Node> Name
%type <Node> Namelist
%type <Node> Field
%type <Node> Fieldlist
%type <Node> FieldlistRep
%type <Node> OptFieldsep
%type <Node> Fieldsep
%type <Node> Tableconstructor
%type <Node> String

%type <Node> Operator
%type <Node> Operator_1
%type <Node> Operator_2
%type <Node> Operator_3
%type <Node> Operator_4
%type <Node> Operator_5
%type <Node> Operator_6
%type <Node> Operator_7
%type <Node> Operator_8
%type <Node> Operator_9


%token <std::string> DO
%token <std::string> WHILE
%token <std::string> FOR
%token <std::string> UNTIL
%token <std::string> REPEAT
%token <std::string> END
%token <std::string> IN
%token <std::string> IF
%token <std::string> THEN
%token <std::string> ELSEIF
%token <std::string> ELSE
%token <std::string> LOCAL
%token <std::string> FUNCTION
%token <std::string> RETURN
%token <std::string> BREAK
%token <std::string> NIL
%token <std::string> FALSE
%token <std::string> TRUE
%token <std::string> AND
%token <std::string> OR
%token <std::string> SQUARE
%token <std::string> NOT

%token <std::string> PLUS
%token <std::string> MINUS
%token <std::string> MULTIPLY
%token <std::string> DIVIDE
%token <std::string> POWER
%token <std::string> MODULO
%token <std::string> EQUALS
%token <std::string> LESS_THAN
%token <std::string> MORE_THAN
%token <std::string> LEQUAL
%token <std::string> MEQUAL
%token <std::string> TEQUAL
%token <std::string> APPEND

%token <std::string> NUMBER
%token <std::string> STRING
%token <std::string> TRIDOT
%token <std::string> NAME
%token <std::string> ASSIGN
%token <std::string> DOT
%token <std::string> COLON
%token <std::string> COMMA
%token <std::string> SEMICOLON
%token <std::string> LBRACES
%token <std::string> RBRACES
%token <std::string> LBRACKET
%token <std::string> RBRACKET
%token <std::string> LPARANTHESES
%token <std::string> RPARANTHESES

%token EXIT 0 "end of file"

%%

Block	: Chunk
		{
			$$ = Node("Block","");
			$$.children.push_back($1);
			root = $$;
		}
		;

Chunk	: ChunkRep Laststat {
	  		$$ = $1;
			$$.children.push_back($2);
	  	}
		| ChunkRep {
	  		$$ = $1;
		}
		| Laststat {
			$$ = Node("Chunk","");
			$$.children.push_back($1);
		}
		;

ChunkRep	: Stat OptionalSemi
	   	{	
			$$ = Node("Chunk","");
			$$.children.push_back($1);
		}
	   	| Chunk Stat OptionalSemi {
			$$ = $1;
			$$.children.push_back($2);
		}
		;

OptionalSemi	: SEMICOLON {}
		| /* empty */
		;

Laststat: RETURN Explist OptionalSemi {
			$$ = Node("return","explist");
			$$.children.push_back($2);
		}
		| RETURN OptionalSemi {
			$$ = Node("return","empty");
		}
		| BREAK OptionalSemi {
			$$ = Node("return","break");
			$$.children.push_back(Node("break",""));
		}
		;

Stat	: Varlist ASSIGN Explist {
			$$ = Node("varass", "");
			$$.children.push_back($1);
			$$.children.push_back($3);
		}
		| LOCAL Namelist ASSIGN Explist {
			$$ = Node("varass","local");
			$$.children.push_back($2);
			$$.children.push_back($4);
		}
		| LOCAL Namelist {
			$$ = Node("vardef","local");
			$$.children.push_back($2);
		}
		| FUNCTION Funcname Functionbody {
			$$ = Node("funcdef","");
			$$.children.push_back($2);
			$$.children.push_back($3);
		}
		| LOCAL FUNCTION Name Functionbody {
			$$ = Node("funcdef","local");
			$$.children.push_back($3);
			$$.children.push_back($4);
		}
		| Functioncall {
			$$ = $1;
		}
		| DO Block END {
			$$ = Node("do", "");
			$$.children.push_back($2);
		}
		| WHILE Exp DO Block END {
			$$ = Node("while","");
			$$.children.push_back($2);
			$$.children.push_back($4);
		}
		| REPEAT Block UNTIL Exp {
			$$ = Node("repeat","");
			$$.children.push_back($2);
			$$.children.push_back($4);
		}
		| If Elseiflist Else END {
			$$ = Node("ifelse","");
			$$.children.push_back($1);
			$$.children.push_back($2);
			$$.children.push_back($3);
		}
		| FOR Name ASSIGN Exp COMMA Exp DO Block END {
			$$ = Node("for","2var");
			$$.children.push_back($2);
			$$.children.push_back($4);
			$$.children.push_back($6);
			$$.children.push_back($8);
		}
		| FOR Name ASSIGN Exp COMMA Exp COMMA Exp DO Block END {
			$$ = Node("for","3var");
			$$.children.push_back($2);
			$$.children.push_back($4);
			$$.children.push_back($6);
			$$.children.push_back($8);
			$$.children.push_back($10);
		}
		| FOR Namelist IN Explist DO Block END {
			$$ = Node("for","in");
			$$.children.push_back($2);
			$$.children.push_back($4);
			$$.children.push_back($6);
		}
	 	;

If		: IF Exp THEN Block {
			$$ = Node("if","");
			$$.children.push_back($2);
			$$.children.push_back($4);
		}
		;

Elseiflist: Elseif {
			$$ = Node("elseiflist","");
			$$.children.push_back($1);
		}
		| Elseiflist Elseif {
			$$ = $1;
			$$.children.push_back($2);
		}
		| /* empty */ {
			$$ = Node("elseiflist","empty");
		}
		;

Elseif	: ELSEIF Exp THEN Block {
			$$ = Node("elseif","");
			$$.children.push_back($2);
			$$.children.push_back($4);
		}
		;

Else	: ELSE Block {
	 		$$ = Node("else","");
			$$.children.push_back($2);
	 	}
		| /* empty */ {
			$$ = Node("else","empty");
		}
		;

Var		: Name {
	 		$$ = Node("var", "name");
			$$.children.push_back($1);
	 	}
		| Prefixexp LBRACKET Exp RBRACKET {
			$$ = Node("var","inbrackets");
			$$.children.push_back($1);
			$$.children.push_back($3);
		}
		| Prefixexp DOT Name {
			$$ = $1;
			$$.children.push_back($3);
		}
	 	;

Varlist	: Var {
			$$ = Node("varlist","");
			$$.children.push_back($1);
		}
		| Varlist COMMA Var {
			$$ = $1;
			$$.children.push_back($3);
		}
		;

Name	: NAME {
	 		$$ = Node("name", $1);
	 	}
		;

Funcname: FuncnameRep {
			$$ = $1;
		}
		| FuncnameRep COLON Name {
			$$ = $1;
			$$.children.push_back($3);
		}
		;

FuncnameRep: Name {
			$$ = Node("funcname",$1.value);
		}
		| FuncnameRep DOT Name {
			$$ = $1;
			$$.value = $$.value +"."+ $3.value;
		}
		;

Namelist: Name {
			$$ = Node("namelist","");
			$$.children.push_back($1);
		}
		| Namelist COMMA Name {
			$$ = $1;
			$$.children.push_back($3);
		}
		;

Exp		: NIL {
	 		$$ = Node("nil", $1);
	 	}
	 	| FALSE {
	 		$$ = Node("int", "0");
		}
		| TRUE {
	 		$$ = Node("int", "1");
		}
		| NUMBER {
			$$ = Node("int", $1);
		}
		| String {
			$$ = $1; 
		}
		| TRIDOT {
			$$ = Node("exp", $1);
		}
		| Function {
			$$ = Node("exp","function");
			$$.children.push_back($1);
		}
		| Prefixexp {
			$$ = $1;
		}
		| Tableconstructor {
			$$ = Node("exp","tableconstructor");
			$$.children.push_back($1);
		}
        | Operator {
            $$ = $1;
        }
		;

Explist	: Exp {
			$$ = Node("explist", "");
			$$.children.push_back($1);
		}
		| Explist COMMA Exp {
			$$ = $1;
			$$.children.push_back($3);
		}
		;

Prefixexp: Var {
			$$ = $1;
		}
		| Functioncall {
			$$ = $1;
		}
		| LPARANTHESES Exp RPARANTHESES {
			$$ = $2;
		}
		;

Function: FUNCTION Functionbody {
			$$ = Node("function","in-line");
			$$.children.push_back($2);
		}
		;

Functioncall: Prefixexp Arguments {
			$$ = Node("funccall","");
			$$.children.push_back($1);
			$$.children.push_back($2);
		}
		| Prefixexp COLON Name Arguments {
			$$ = Node("funccall","2");
			$$.children.push_back($1);
			$$.children.push_back($3);
			$$.children.push_back($4);
		}
		;

Functionbody: LPARANTHESES Parameterlist RPARANTHESES Block END {
			$$ = Node("funcbody","");
			$$.children.push_back($2);
			$$.children.push_back($4);
		}
		| LPARANTHESES RPARANTHESES block END {
			$$ = Node("funcbody","");
			$$.children.push_back(Node("parlist","empty"));
			$$.children.push_back($3);
		}
		;

Parameterlist	: Namelist {
			$$ = Node("parlist","namelist");
			$$.children.push_back($1);
		}
		| Namelist COMMA TRIDOT {
			$$ = $1;
			$$.children.push_back(Node("argover",""));
		}
		| TRIDOT {
			$$ = Node("parlist","TRIDOT");
		}
		;

Arguments	: LPARANTHESES RPARANTHESES {
	 		$$ = Node("explist","empty");
	 	}
		| LPARANTHESES Explist RPARANTHESES {
			$$ = $2;
		}
		| Tableconstructor {
			$$ = $1;
		}
		| String {
			$$ = $1;
		}
		;

Tableconstructor: LBRACES Fieldlist RBRACES {
			$$ = Node("tableconstructor","");
			$$.children.push_back($2);
		}
		| LBRACES RBRACES {
			$$ = Node("tableconstructor","empty");
		}
		;

Field	: LBRACES Exp RBRACES ASSIGN Exp {
	  		$$ = Node("field","bracketequals");
			$$.children.push_back($2);
			$$.children.push_back($5);
	  	}
		| Name ASSIGN Exp {
			$$ = Node("field","equals");
			$$.children.push_back($1);
			$$.children.push_back($3);
		}
		| Exp {
			$$ = Node("field", "exp");
			$$.children.push_back($1);
		}
	  	;

Fieldlist: FieldlistRep OptFieldsep {
		 	$$ = $1;
			$$.children.push_back($1);
		}
		;

FieldlistRep: Field {
			$$ = Node("fieldlist","");
			$$.children.push_back($1);
		}
		| FieldlistRep Fieldsep Field {
			$$ = $1;
			$$.children.push_back($3);
		}

OptFieldsep: Fieldsep { $$ = $1; }
		| /* empty */ {}
		;

Fieldsep: COMMA {
			$$ = Node("fieldsep",$1);
		}
		| SEMICOLON {
			$$ = Node("fieldsep",$1);
		}
		;

String	: STRING {
	   		$$ = Node("str", $1.substr(1,$1.length()-2));
	   	}
		;

Operator      : Operator_1 {
            $$ = $1;
        }
        ;

Operator_1    : Operator_1 OR Operator_2 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_2 {
            $$ = $1;
        }
        ;

Operator_2    : Operator_2 AND Operator_3 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_3 {
            $$ = $1;
        }
        ;

Operator_3    : Operator_3 LESS_THAN Operator_4 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_3 LEQUAL Operator_4 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_3 MORE_THAN Operator_4 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_3 MEQUAL Operator_4 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_3 TEQUAL Operator_4 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_3 EQUALS Operator_4 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_4 {
            $$ = $1;
        }
        ;

Operator_4    : Operator_4 APPEND Operator_5 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_5 {
            $$ = $1;
        }
        ;

Operator_5    : Operator_5 PLUS Operator_6 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_5 MINUS Operator_6 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_6 {
            $$ = $1;
        }
        ;

Operator_6    : Operator_6 TIMES Operator_7 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_6 DIVIDE Operator_7 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        } 
        | Operator_6 MODULO Operator_7 {
            $$ = Node("op", "binop");
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        } 
        | Operator_7 {
            $$ = $1;
        }
        ;

Operator_7    : NOT Operator_8 {
            $$ = Node("op", "unop");
            $$.children.push_back(Node("unop", $1));
            $$.children.push_back($2);
        } 
        | SQUARE Operator_8 {
            $$ = Node("op", "unop");
            $$.children.push_back(Node("unop", $1));
            $$.children.push_back($2);
        } 
        | MINUS Operator_8 {
            $$ = Node("op", "unop");
            $$.children.push_back(Node("unop", $1));
            $$.children.push_back($2);
        } 
        | Operator_8 {
            $$ = $1;
        }
        ;

Operator_8    : Operator_8 POWER Operator_9 {
            $$ = Node("binop", $2);
            $$.children.push_back($1);
            $$.children.push_back(Node("binop", $2));
            $$.children.push_back($3);
        }
        | Operator_9 {
            $$ = $1;
        }
        ;

Operator_9    : Exp {
            $$ = $1;
        }
        ;

