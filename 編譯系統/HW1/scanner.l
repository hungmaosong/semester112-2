/* Definition section */
%{
    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #define printToken(token, value) (value ? printf("%-8s \t %s\n", token, (char*)value) : printf("%s\n", token))
    FILE* fout;
    int in_comment = 0; //用來判斷是否進到多行comment狀態
%}

/*讓yylineno計算行數能更新*/
%option yylineno 

/*設置一個新的狀態*/
%x MultiComment

/* Define regular expression label */
letter [a-zA-Z_]
digit [0-9]

/* Rules section */
%%
">>"        { printToken("SHR", NULL); }
"<<"        { printToken("SHL", NULL); }
"&"         { printToken("BAN", NULL); }
"|"         { printToken("BOR", NULL); }
"~"         { printToken("BNT", NULL); }
"^"         { printToken("BXO", NULL); }
"+"         { printToken("ADD", NULL); }
"-"         { printToken("SUB", NULL); }
"*"         { printToken("MUL", NULL); }
"/"         { printToken("DIV", NULL); }
"%"         { printToken("MOD", NULL); }
"!"         { printToken("NOT", NULL); }
">"         { printToken("GTR", NULL); }
"<"         { printToken("LES", NULL); }
">="        { printToken("GEQ", NULL); }
"<="        { printToken("LEQ", NULL); }
"=="        { printToken("EQL", NULL); }
"!="        { printToken("NEQ", NULL); }
"&&"        { printToken("LAN", NULL); }
"||"        { printToken("LOR", NULL); }
"="         { printToken("VAL_ASSIGN", NULL); }
"+="        { printToken("ADD_ASSIGN", NULL); }
"-="        { printToken("SUB_ASSIGN", NULL); }
"*="        { printToken("MUL_ASSIGN", NULL); }
"/="        { printToken("DIV_ASSIGN", NULL); }
"%="        { printToken("REM_ASSIGN", NULL); }
">>="       { printToken("SHR_ASSIGN", NULL); }
"<<="       { printToken("SHL_ASSIGN", NULL); }
"&="        { printToken("BAN_ASSIGN", NULL); }
"|="        { printToken("BOR_ASSIGN", NULL); }
"++"        { printToken("INC_ASSIGN", NULL); }
"--"        { printToken("DEC_ASSIGN", NULL); }
"("         { printToken("'('", NULL); }
")"         { printToken("')'", NULL); }
"["         { printToken("'['", NULL); }
"]"         { printToken("']'", NULL); }
"{"         { printToken("'{'", NULL); }
"}"         { printToken("'}'", NULL); }
":"         { printToken("':'", NULL); }
";"         { printToken("';'", NULL); }
","         { printToken("','", NULL); }

"cout"      { printToken("COUT", NULL); }
"auto"      { printToken("AUTO_T", NULL); }
"void"      { printToken("VOID_T", NULL); }
"char"      { printToken("CHAR_T", NULL); }
"int"      { printToken("INT_T", NULL); }
"long"      { printToken("LONG_T", NULL); }
"float"      { printToken("FLOAT_T", NULL); }
"double"      { printToken("DOUBLE_T", NULL); }
"bool"      { printToken("BOOL_T", NULL); }
"string"      { printToken("STR_T", NULL); }
"if"      { printToken("IF", NULL); }
"else"      { printToken("ELSE", NULL); }
"for"      { printToken("FOR", NULL); }
"while"      { printToken("WHILE", NULL); }
"return"      { printToken("RETURN", NULL); }
"break"      { printToken("BREAK", NULL); }
"true"      { printToken("BOOL_LIT", "true"); }
"false"      { printToken("BOOL_LIT", "false"); }

{digit}+    { printToken("INT_LIT", yytext); }
{digit}+"."{digit}+    { printToken("FLOAT_LIT", yytext); }
{letter}({letter}|{digit})*   { printToken("IDENT", yytext); }
\"(\\.|[^\\"])*\" { printToken("STRING_LIT", yytext); }
'.'         { printToken("CHAR_LIT", yytext); }
"//".*      { printToken("COMMENT", yytext); }

[[:space:]]+ { /* 忽略空白 */ }
<<EOF>>     { static int once = 0; if (once++) {yyterminate();} }

"/*"        { BEGIN(MultiComment ); in_comment = 1; yymore();}  // 遇到 "/*" 進入註釋狀態，並將 "/*" 存入buffer
<MultiComment>"*/"   { BEGIN(INITIAL ); in_comment = 0;  printToken("MULTI_COMMENT", yytext);} // 在註釋狀態中遇到 "*/" 離開註釋狀態，回到初始狀態，
<MultiComment>.  {yymore();}  // 在註釋狀態中遇到除了換行的任意字符,則將其存入buffer
<MultiComment>\n          { if (in_comment) yymore();}  // 如果在註釋狀態中遇到換行，則將 "\n" 存入buffer

%%




/*  C Code section */
int yywrap(void) {
    return 1;
}

int main(int argc, char* argv[]) {
    char *inputFileName = NULL;
    if (argc == 2) {
        yyin = fopen(inputFileName = argv[1], "r");
    } else {
        yyin = stdin;
    }
    if (!yyin) {
        printf("file `%s` doesn't exists or cannot be opened\n", inputFileName);
        exit(1);
    }

    yylex();
    printf("\nTotal line: %d\n", yylineno);

    fclose(yyin);
    return 0;
}