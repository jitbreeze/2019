%{
#include <stdio.h>
#include <string.h>
  
  int intcount=0; 
  int charcount=0; 
  int repeat=0; 
  int retrn=0; 
  int selection=0;    
  int pointer=0; 
  int function=0; 
  int expression=0; 
  int arraycount=0;
  int checkint=0; 
  int checkchar=0;
  
  void yyerror(const char *str)
 {
         fprintf(stderr,"error   : %s\n",str);
 }
 
  int yywrap() {return 1;}
  
 int main(void)
 {
         yyparse();
         printf("함수=  %d\n", function);
         printf("수식=  %d\n", expression);
         printf("int 변수 선언=  %d\n", intcount);
         printf("char 변수 선언=  %d\n", charcount);
         printf("pointer 변수 선언=  %d\n", pointer);
         printf("배열 변수 선언= %d\n", arraycount);
         printf("선택문= %d\n", selection);
         printf("반복문=  %d\n", repeat);
         printf("리턴문=  %d\n", retrn);
         return 0;
 }
  %}

  %token IDENTIFIER CONSTANT SIZEOF NUMBER VOLATILE CONST
  %token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
  %token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
  %token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
  %token XOR_ASSIGN OR_ASSIGN TYPE_NAME ENUM SIGNED UNSIGED
  %token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN
  %token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE  VOID
  %token STRUCT UNION ELLIPSIS STATIC TYPEDEF AUTO EXTERN REGISTER
  %token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN
 
%%

 start_state :
  |start_state start_statement
  ;

 start_statement:
  statement
  |type_specifier_list
  |pointer_definition
  |postfix_expression
  |variable_definition
  |function_definition
  |storage_class_specifier
  |struct_or_union
  ;
  
 primary_expression:
  NUMBER
  |IDENTIFIER
  |CONSTANT
  |'(' expression ')'
  ;

 postfix_expression:
  primary_expression
  |postfix_expression '[' expression ']'
  |postfix_expression '('')' {function++;}
  |postfix_expression '(' expression ')' {function++;}
  |postfix_expression '(' argument_expression_list ')' {function++;}
  |postfix_expression '.' IDENTIFIER
  |postfix_expression PTR_OP IDENTIFIER
  |postfix_expression INC_OP
  |postfix_expression DEC_OP
  ;

 argument_expression_list
  : assignment_expression
  | argument_expression_list ',' assignment_expression
  ;  
 unary_expression
  : postfix_expression
  | INC_OP unary_expression
  | DEC_OP unary_expression
  | unary_operator cast_expression
  | SIZEOF unary_expression  
  | SIZEOF '(' type_name ')' 
  ;

 pointer_definition:
 type_specifier pointer_list';'{pointer++;}
 |type_specifier pointer_list '=' direct_declarator {pointer++;}
 
 ;
 unary_operator:
  '&'
  |'*'
  |'+'
  |'-'
  |'!'
  ;
  
 cast_expression:
  unary_expression
  |'(' type_specifier ')' cast_expression
  ;

  multiplicative_expression:
  cast_expression
  |multiplicative_expression '*' cast_expression
  |multiplicative_expression '/' cast_expression
  |multiplicative_expression '%' cast_expression
  ;

  additive_expression
: multiplicative_expression
| additive_expression '+' multiplicative_expression
| additive_expression '-' multiplicative_expression  
 
 shift_expression
: additive_expression
| shift_expression LEFT_OP additive_expression
| shift_expression RIGHT_OP additive_expression
;
relational_expression
: shift_expression
| relational_expression '<' shift_expression
| relational_expression '>' shift_expression
| relational_expression LE_OP shift_expression
| relational_expression GE_OP shift_expression
;
equality_expression
: relational_expression
| equality_expression EQ_OP relational_expression
| equality_expression NE_OP relational_expression
;
and_expression
: equality_expression
| and_expression '&' equality_expression
;
exclusive_or_expression
: and_expression
| exclusive_or_expression '^' and_expression
;
inclusive_or_expression
: exclusive_or_expression
| inclusive_or_expression '|' exclusive_or_expression
;
logical_and_expression
: inclusive_or_expression
| logical_and_expression AND_OP inclusive_or_expression
;
logical_or_expression
: logical_and_expression
| logical_or_expression OR_OP logical_and_expression
;

conditional_expression
: logical_or_expression
| logical_or_expression '?' expression ':' conditional_expression 
;
assignment_expression
: conditional_expression
| unary_expression assignment_operator assignment_expression
;
assignment_operator
: '='
| MUL_ASSIGN
| DIV_ASSIGN
| MOD_ASSIGN
| ADD_ASSIGN
| SUB_ASSIGN
| LEFT_ASSIGN
| RIGHT_ASSIGN
| AND_ASSIGN
| XOR_ASSIGN
| OR_ASSIGN
;
expression
: assignment_expression 
| expression ',' assignment_expression
;
constant_expression
: conditional_expression
;
declaration
: declaration_specifiers ';'
| declaration_specifiers init_declarator_list ';'
;
 declaration_specifiers:
 storage_class_specifier
 |storage_class_specifier declaration_specifiers
 |type_specifier
 |type_specifier declaration_specifiers
 |type_qualifier
 |type_qualifier declaration_specifiers
 ; 

 init_declarator_list:
 init_declarator
 |init_declarator_list ';' init_declarator
 ;

 init_declarator:
 declarator
 |declarator '=' initializer
 ;

 storage_class_specifier:
 TYPEDEF
 |EXTERN
 |STATIC
 |AUTO
 |REGISTER
 ;

 
 type_specifier:
  VOID
  |CHAR   {checkchar=1;}
  |SHORT
  |INT    {checkint=1;}
  |FLOAT
  |LONG
  |DOUBLE
  |SIGNED
  |UNSIGNED;
  ;
  


 specifier_qualifier_list:
 type_specifier specifier_qualifier_list
 |type_specifier
 |type_qualifier specifier_qualifier_list
 |type_qualifier
 ;

  struct_or_union_specifier
  : struct_or_union IDENTIFIER '{' struct_declaration_list '}'
  | struct_or_union '{' struct_declaration_list '}'
  | struct_or_union IDENTIFIER
  ;
  
  struct_or_union
  : STRUCT
  | UNION 
  ;
 
 struct_declaration_list
  : struct_declaration
  | struct_declaration_list struct_declaration

  struct_declaration:
  specifier_qualifier_list struct_declarator_list';'
  ;

  struct_declaration_list:
  struct_declaration
  |struct_declaration_list struct_declaration
  ;

  struct_declarator_list:
  struct_declarator
  |struct_declarator_list ',' struct_declarator
  ;

  struct_declarator:
  declarator
  |':' constant_expression
  |declarator ':' constant_expression
  ;
  
  enum_specifier
 : ENUM '{' enumerator_list '}'
 | ENUM IDENTIFIER '{' enumerator_list '}'
 | ENUM IDENTIFIER
 ;
 
 enumerator_list
 : enumerator
 | enumerator_list ',' enumerator
 ;
 
 enumerator
 : IDENTIFIER
 | IDENTIFIER '=' constant_expression
 ;

 type_qualifier
 :CONST
 |VOLATILE
 ;

 declarator:
 pointer direct_declarator
 |direct_declarator
 ;

 direct_declarator:
 IDENTIFIER
 |'(' declarator ')'
 |direct_declarator '[' constant_expression ']'
 |direct_declarator '['']'
 |direct_declarator '(' parameter_type_list ')'
 |direct_declarator '(' identifier_list ')'
 |direct_declarator '('')'
 ;
 
 pointer:
  '*'
 |'*' type_qualifier_list
 |'*' pointer
 |'*' type_qualifier_list pointer
 ;

 pointer_list:
 pointer
 |pointer IDENTIFIER
 |pointer_list ';' pointer IDENTIFIER
 ;




  variable_definition:
   storage_class_specifier type_specifier_list';'
 {
 if(checkint==1){intcount++; checkint=0;}
 else if(checkchar==1){charcount++; checkchar=0;}
 }
 |type_specifier_list';'
  {
  if(checkint==1){intcount++; checkint=0;}
  else if(checkchar==1){charcount; checkchar=0;}
  }
  |storage_class_specifier type_specifier_list '=' expression ';'
  {
  if(checkint==1){intcount++; checkint=0;}
  else if(checkchar==1){charcount++; checkchar=0;}
  }
 |type_specifier_list '=' expression ';'
 {
 if(checkint==1) {intcount++; checkint=0;}
 else if(checkchar==1) {charcount++; checkchar=0;}
 }
 ;

 type_qualifier_list:
 |type_qualifier
 |type_qualifier_list type_qualifier
 ;

 parameter_type_list:
 parameter_list
 |parameter_list ';' ELLIPSIS
 ;
 
 parameter_declaration:
 declaration_specifiers declarator
 |declaration_specifiers abstract_declarator
 |declaration_specifiers
 ;
 
 parameter_list:
 parameter_declaration
 |parameter_list ';' parameter_declaration
 ;
 
 parameter_declaration
 : declaration_specifiers declarator 
 | declaration_specifiers abstract_declarator
 | declaration_specifiers
 ;

 identifier_list:
 IDENTIFIER
 |identifier_list ',' IDENTIFIER
 ;
 
 type_name
 : specifier_qualifier_list
 | specifier_qualifier_list abstract_declarator
 ;

 abstract_declarator
 : pointer
 | direct_abstract_declarator
 | pointer direct_abstract_declarator
 ;
 direct_abstract_declarator
 : '(' abstract_declarator ')'
 | '[' ']'
 | '[' constant_expression ']'
 | direct_abstract_declarator '[' ']'
 | direct_abstract_declarator '[' constant_expression ']'
 | '(' ')'
 | '(' parameter_type_list ')'
 | direct_abstract_declarator '(' ')'
 | direct_abstract_declarator '(' parameter_type_list ')'
 ;

 initializer:
 assignment_expression
 |'{' initializer_list '}'
 |'{' initializer_list ',''}'
 ;

 initializer_list:
 initializer
 |initializer_list ',' initializer
 ;

 statement:
 labled_statement
 |compound_statement
 |expression_statement
 |selection_statement
 |iteration_statement
 |jump_statement
 |function_definition
 ;

 statement_list:
 statement
 |statement statement_list
 ;

 labled_statement:
 IDENTIFIER ':' statement
 |CASE constant_expression ':' statement
 |DEFAULT ':' statement
 ;

 declaration_list:
 declaration
 |declaration_list declaration
 ;

 compound_statement:
 '{''}'
 |'{' statement_list '}'
 |'{' declaration_list '}'
 |'{' declaration_list statement_list '}'
 ;

 expression_statement:
 ';'
 |expression ';'
 |variable_definition
 |pointer_definition
 ;

 selection_statement:
 IF '(' expression ')' statement {selection++;}
 |IF '(' expression ')' statement ELSE statement {selection++;}
 |SWITCH '(' expression ')' statement {selection++;}
;

 iteration_statement:
 WHILE '(' expression ')' statement {repeat++;}
 |DO statement WHILE '(' expression ')'';' {repeat++;}
 |FOR '(' expression_statement expression_statement ')' statement {repeat++;}
 ;

 jump_statement:
 GOTO IDENTIFIER ';'
 |CONTINUE ';'
 |BREAK ';'
 |RETURN ';' {retrn++;}
 |RETURN expression ';' {retrn++;}
 ;
 
 type_specifier_list:
 type_specifier
 |type_specifier type_qualifier
 |type_specifier type_specifier_list
 |type_specifier IDENTIFIER
 |type_specifier_list ',' IDENTIFIER
 ;
 

 function_definition:
 type_specifier IDENTIFIER '(' parameter_type_list ')' statement { function++;}
 |type_specifier IDENTIFIER '('')'statement {function++;}
 |type_specifier IDENTIFIER '(' parameter_type_list')'';' {function++;}
 |type_specifier IDENTIFIER '('')'';' {function++;}
 ;

%%
