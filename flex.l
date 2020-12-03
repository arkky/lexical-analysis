%option noyywrap yylineno
%{
#include <stdio.h>
#include <string.h>
#define SIZE 4
char* filename;
char* keywords[SIZE] = {"and", "or", "xor", "not"};
%}
const [TF]
panth [()]
letter [a-zA-Z]
digit [0-9]
delim [;]
ws [ \t\n]
%%
{const} {
printf("%s:%d CONSTANT %s\n", filename, yylineno, yytext);
}
{panth} {
printf("%s:%d PANTHESIS %s\n", filename, yylineno, yytext);
}
({letter}|"_")({letter}|{digit}|"_")* {
if(resWord(yytext))
{
printf("%s:%d KEYWORD %s\n", filename, yylineno, yytext);
}else{
printf("%s:%d IDENTIFIER %s\n", filename, yylineno,
yytext);
}
}
{digit}+ {
printf("%s:%d NUMBER %s\n", filename, yylineno, yytext);
}
":=" {
printf("%s:%d ASSIGN %s\n", filename, yylineno, yytext);
}
{delim} {
printf("%s:%d DELIMITER %s\n", filename, yylineno,
yytext);
}
{ws}+ ;
. {
printf("%s:%d Unknown character '%s'\nLine an error row: %d\n", filename,
yylineno, yytext, yylineno);
}
%%
int resWord(char* id)
{
int i;
for(i = 0; i < SIZE; i++)
{
if(strcmp(id, keywords[i]) == 0)
{
return 1;
}
}
return 0;
}
int main(int argc, char** argv)
{
yyin = fopen("text.txt", "r");
if(yyin == NULL)
{
perror(argv[1]);
return 1;
}
filename = strdup(argv[1]);
yylineno = 1;
yylex();
return 0;
}