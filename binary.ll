%top{
    #include "binary.tab.hh"
    #define YY_DECL yy::parser::symbol_type yylex()
}

%option noyywrap nounput batch noinput
%%

do										{ return yy::parser::make_DO(yytext); }
while									{ return yy::parser::make_WHILE(yytext); }
for										{ return yy::parser::make_FOR(yytext); }
until									{ return yy::parser::make_UNTIL(yytext); }
repeat									{ return yy::parser::make_REPEAT(yytext); }
end										{ return yy::parser::make_END(yytext); }
in										{ return yy::parser::make_IN(yytext); }
if										{ return yy::parser::make_IF(yytext); }
then									{ return yy::parser::make_THEN(yytext); }
elseif									{ return yy::parser::make_ELSEIF(yytext); }
else									{ return yy::parser::make_ELSE(yytext); }
and                                     { return yy::parser::make_AND(yytext); }
or                                      { return yy::parser::make_OR(yytext); }
[#]                                     { return yy::parser::make_SQUARE(yytext); }
not                                     { return yy::parser::make_NOT(yytext); }
local									{ return yy::parser::make_LOCAL(yytext); }
function								{ return yy::parser::make_FUNCTION(yytext); }
return									{ return yy::parser::make_RETURN(yytext); }
break									{ return yy::parser::make_BREAK(yytext); }
nil										{ return yy::parser::make_NIL(yytext);}
false									{ return yy::parser::make_FALSE(yytext); }
true									{ return yy::parser::make_TRUE(yytext);}

[+]                                     { return yy::parser::make_PLUS(yytext); }
[-]                                     { return yy::parser::make_MINUS(yytext); }
[*]                                     { return yy::parser::make_MULTIPLY(yytext); }
[/]                                     { return yy::parser::make_DIVIDE(yytext); }
[\^]                                    { return yy::parser::make_POWER(yytext); }
[%]                                     { return yy::parser::make_MODULO(yytext); }
[=][=]                                  { return yy::parser::make_EQUALS(yytext); }
[<]                                     { return yy::parser::make_LESS_THAN(yytext); }
[<][=]                                  { return yy::parser::make_LEQUAL(yytext); }
[>]                                     { return yy::parser::make_MORE_THAN(yytext); }
[>][=]                                  { return yy::parser::make_MEQUAL(yytext); }
[~][=]                                  { return yy::parser::make_TEQUAL(yytext); }
[.][.]                                  { return yy::parser::make_APPEND(yytext); }

[0-9]+									{ return yy::parser::make_NUMBER(yytext);}
\"[^\"]*\"								{ return yy::parser::make_STRING(yytext);}
\.\.\.									{ return yy::parser::make_TRIDOT(yytext);}
[A-Za-z_][A-Za-z0-9_]*					{ return yy::parser::make_NAME(yytext); }
=										{ return yy::parser::make_ASSIGN(yytext); }
\.										{ return yy::parser::make_DOT(yytext); }
:										{ return yy::parser::make_COLON(yytext); }
,										{ return yy::parser::make_COMMA(yytext); }
;										{ return yy::parser::make_SEMICOLON(yytext); }
\(										{ return yy::parser::make_LPARANTHESES(yytext); }
\)										{ return yy::parser::make_RPARANTHESES(yytext); }
\{										{ return yy::parser::make_LBRACES(yytext); }
\}										{ return yy::parser::make_RBRACES(yytext); }
[\[]									{ return yy::parser::make_LBRACKET(yytext); }
[\]]									{ return yy::parser::make_RBRACKET(yytext); }
[ \t]									{ /* tab space */ }
[\n]									{ /* newline */ }
<<EOF>>                 				{ return yy::parser::make_EXIT(); }

%%