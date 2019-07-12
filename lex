%{
#include <stdio.h>
#include "y.tab.h"
%}


D [0-9] 

L [a-zA-Z_] 

%%

"int"           {return INT;} 

"float"         {return FLOAT;} 

"char"          {return CHAR;} 

"short"         {return SHORT;}

"long"          {return LONG;} 

"void"          {return VOID;} 

"double"        {return DOUBLE;} 

"for"           {return FOR;} 

"while"         {return WHILE;} 

"do"            {return DO;} 

"break"         {return BREAK;} 

"return"        {return RETURN;}

"if"            {return IF;} 

"switch"        {return SWITCH;}

"case"          {return CASE;} 

"else"          {return ELSE;} 

"struct"        {return STRUCT;} 

"register"      {return REGISTER;} 

"auto"          {return AUTO;}

"enum"          {return ENUM;}

"const"         {return CONST;} 

"static"        {return STATIC;} 

"default"       {return DEFAULT;} 

"continue"      {return CONTINUE;} 

"extern"        {return EXTERN;}

"goto"          {return GOTO;} 

"union"         {return UNION;} 

"unsigned"      {return UNSIGNED;} 

"signed"        {return SIGNED;} 

"volatile"      {return VOLATILE;}

"sizeof"        {return SIZEOF;} 

"typedef"       {return TYPEDEF;} 

"..."           {return ELLIPSIS; } 

">>="           {return RIGHT_ASSIGN; } 

"<<="           { return LEFT_ASSIGN; }

"+="            { return ADD_ASSIGN; } 

"-="            { return SUB_ASSIGN; } 

"*="            { return MUL_ASSIGN; } 

"/="            { return DIV_ASSIGN; }

"%="            { return MOD_ASSIGN; }

"&="            { return AND_ASSIGN; } 

"^="            { return XOR_ASSIGN; }

"|="            { return OR_ASSIGN; } 

">>"            { return RIGHT_OP; } 

"<<"            { return LEFT_OP; }

"++"            { return INC_OP; }

"--"            { return DEC_OP; }

"->"            { return PTR_OP; }

"&&"            { return AND_OP; }

"||"            { return OR_OP;  }

"<="            { return LE_OP; } 

">="            { return GE_OP; } 

"=="            { return EQ_OP; } 

"!="            {return NE_OP; } 

{L}({L}|{D})*   {return IDENTIFIER;} 

{D}+            {return NUMBER;}

"&"             {return '&';} 

"+"             {return '+';} 

"-"             {return '-';} 

"~"             {return '~';} 

"!"             {return '!';} 

"="             {return '=';} 

"("             {return '(';} 

")"             {return ')';} 

"["             {return '[';} 

"]"             {return ']';} 

";"             {return ';';} 

","             {return ',';} 

":"             {return ':';} 

"/"             {return '/';} 

"*"             {return '*';} 

"%"             {return '%';} 

"<"             {return '<';} 

">"             {return '>';} 

"^"             {return '^';} 

"|"             {return '|';} 

"?"             {return '?';} 

"#"				{return '#';}

.       {;} 


"\n"    {;} 

[\t]+  {;}  
%%
