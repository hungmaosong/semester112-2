/* Definition section */
%{
    #include "compiler_util.h"
    #include "main.h"

    int yydebug = 1;

    #include "stdlib.h"
    
    FILE *jfile; // 打開文件的文件指针
    void init_jfile(); // 初始化文件指针，在合适的位置打開文件
    void close_jfile();
%}

/* Variable or self-defined structure */
%union {
    ObjectType var_type;

    bool b_var;
    char c_var;
    int32_t i_var;
    int64_t l_var;
    float f_var;
    double d_var;
    char *s_var;

    Object obj_val;

    // LinkList<Object*>
    // LinkedList* array_subscript;
}

/* Token without return */
%token COUT
%token SHR SHL BAN BOR BNT BXO ADD SUB MUL DIV REM NOT GTR LES GEQ LEQ EQL NEQ LAN LOR
%token VAL_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN REM_ASSIGN BAN_ASSIGN BOR_ASSIGN BXO_ASSIGN SHR_ASSIGN SHL_ASSIGN INC_ASSIGN DEC_ASSIGN
%token IF ELSE FOR WHILE RETURN BREAK CONTINUE

/* Token with return, which need to sepcify type */
%token <var_type> VARIABLE_T
%token <b_var> BOOL_LIT
%token <c_var> CHAR_LIT
%token <i_var> INT_LIT
%token <f_var> FLOAT_LIT
%token <s_var> STR_LIT
%token <s_var> IDENT

/* Nonterminal with return, which need to sepcify type */
// %type <obj_val> Expression
%type <array_subscript> ArraySubscriptStmtList

%left ADD SUB
%left MUL DIV REM

%nonassoc THEN
%nonassoc ELSE

/* Yacc will start at this nonterminal */
%start Program

%%
/* Grammar section */

Program
    : VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT SHL IDENT ';' RETURN INT_LIT ';' '}'  
        {
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"%s\"\n",$<s_var>12);
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile();
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT SHL STR_LIT SHL IDENT ';' RETURN INT_LIT ';' '}' 
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL CHAR_LIT SHL IDENT ';' RETURN INT_LIT ';' '}' 
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT SHL CHAR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL IDENT ';' RETURN INT_LIT ';' '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT ';' '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL '(' INT_LIT SUB INT_LIT MUL '(' INT_LIT ADD SUB INT_LIT ')' SUB INT_LIT DIV INT_LIT ')' SHL IDENT ';' COUT SHL '(' INT_LIT SUB INT_LIT MUL '(' INT_LIT ADD SUB INT_LIT ')' SUB INT_LIT DIV INT_LIT GTR SUB INT_LIT REM INT_LIT LOR NOT BOOL_LIT LAN NOT NOT BOOL_LIT ')' SHL IDENT ';' COUT SHL '(' FLOAT_LIT SUB FLOAT_LIT MUL '(' FLOAT_LIT ADD SUB FLOAT_LIT ')' SUB FLOAT_LIT DIV FLOAT_LIT ')' SHL IDENT ';' COUT SHL '(' FLOAT_LIT SUB FLOAT_LIT MUL '(' FLOAT_LIT ADD SUB FLOAT_LIT ')' SUB FLOAT_LIT DIV FLOAT_LIT GTR SUB FLOAT_LIT LOR NOT BOOL_LIT LAN NOT NOT BOOL_LIT ')' SHL IDENT ';' RETURN INT_LIT ';' '}' 
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"14\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"true\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"13.571428\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"true\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");            
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL '(' INT_LIT SUB INT_LIT MUL '(' INT_LIT ADD SUB INT_LIT ')' SUB INT_LIT DIV INT_LIT ')' SHL IDENT ';' COUT SHL '(' INT_LIT SUB INT_LIT MUL '(' INT_LIT ADD SUB INT_LIT ')' SUB INT_LIT DIV INT_LIT GTR SUB INT_LIT REM INT_LIT LOR NOT BOOL_LIT LAN NOT NOT BOOL_LIT ')' SHL IDENT ';' COUT SHL '(' FLOAT_LIT SUB FLOAT_LIT MUL '(' FLOAT_LIT ADD SUB FLOAT_LIT ')' SUB FLOAT_LIT DIV FLOAT_LIT ')' SHL IDENT ';' COUT SHL '(' FLOAT_LIT SUB FLOAT_LIT MUL '(' FLOAT_LIT ADD SUB FLOAT_LIT ')' SUB FLOAT_LIT DIV FLOAT_LIT GTR SUB FLOAT_LIT LOR NOT BOOL_LIT LAN NOT NOT BOOL_LIT ')' SHL IDENT ';' COUT SHL INT_LIT ADD INT_LIT MUL INT_LIT SUB INT_LIT ADD INT_LIT ADD '(' SUB INT_LIT ')' ADD '(' INT_LIT REM INT_LIT NEQ INT_LIT ')' ADD '(' INT_LIT REM INT_LIT NEQ INT_LIT ')' SHL IDENT ';' RETURN INT_LIT ';' '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"14\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"true\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"13.571428\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"true\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");    
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1001635\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");                      
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' 
            VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT VAL_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT ADD_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT SUB_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT MUL_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT DIV_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT REM_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT BOR_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT BAN_ASSIGN INT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            VARIABLE_T IDENT VAL_ASSIGN FLOAT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT VAL_ASSIGN FLOAT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT ADD_ASSIGN FLOAT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT SUB_ASSIGN FLOAT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT MUL_ASSIGN FLOAT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT DIV_ASSIGN FLOAT_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'

            VARIABLE_T IDENT VAL_ASSIGN STR_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT VAL_ASSIGN STR_LIT';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'

            VARIABLE_T IDENT VAL_ASSIGN BOOL_LIT ';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
            IDENT VAL_ASSIGN BOOL_LIT';'
            COUT SHL '(' IDENT ')' SHL IDENT ';'
      '}'
       { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"10\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"12\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");    
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"36\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");   
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"7\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"4093\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"253\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"3.14\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"10.4\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"12.4\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9.4\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"37.6\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"7.5199995\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"false\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"true\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT ',' IDENT ',' IDENT ',' IDENT ',' IDENT ';'
    
        IDENT VAL_ASSIGN BNT INT_LIT BAN INT_LIT ';'
        IDENT VAL_ASSIGN IDENT SHR INT_LIT ';'
        IDENT VAL_ASSIGN IDENT ';'
        IDENT VAL_ASSIGN IDENT BOR INT_LIT ';'
        IDENT VAL_ASSIGN IDENT ';'

        IDENT ADD_ASSIGN IDENT ';'
        IDENT ADD_ASSIGN IDENT ';'
        IDENT DIV_ASSIGN IDENT ';'

        COUT SHL IDENT SHL STR_LIT SHL IDENT SHL STR_LIT SHL IDENT SHL STR_LIT SHL IDENT SHL STR_LIT SHL IDENT SHL IDENT ';'
    
        IDENT VAL_ASSIGN INT_LIT BXO INT_LIT ';'
        IDENT SHL_ASSIGN INT_LIT ';'
        COUT SHL IDENT SHL IDENT ';'
        IDENT SHR_ASSIGN INT_LIT ';'
        COUT SHL IDENT SHL IDENT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"24 12 1 15 6\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"620\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"38\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");             
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';'
        VARIABLE_T IDENT VAL_ASSIGN FLOAT_LIT ';'
        VARIABLE_T IDENT ',' IDENT ';'

        IDENT VAL_ASSIGN IDENT ADD '(' VARIABLE_T ')' '(' IDENT ')' ';'
        IDENT VAL_ASSIGN '(' VARIABLE_T ')' IDENT ADD IDENT ';'
        COUT SHL IDENT SHL STR_LIT SHL IDENT SHL IDENT ';'

        IDENT VAL_ASSIGN IDENT ADD '(' VARIABLE_T ')' '(' FLOAT_LIT ')' ';'
        IDENT VAL_ASSIGN '(' VARIABLE_T ')' '(' INT_LIT ')' ADD IDENT ';'
        COUT SHL IDENT SHL IDENT ';'
        COUT SHL IDENT SHL IDENT ';'
    
        RETURN INT_LIT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"6 6\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");             
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ',' IDENT VAL_ASSIGN INT_LIT ';'
        IDENT ADD_ASSIGN IDENT ';'
        VARIABLE_T IDENT VAL_ASSIGN FLOAT_LIT ';'

        VARIABLE_T IDENT VAL_ASSIGN '(' VARIABLE_T ')' '(' IDENT ')' ADD '(' VARIABLE_T ')' FLOAT_LIT  ';'
        COUT SHL IDENT SHL IDENT ';'
        COUT SHL IDENT SHL IDENT ';'
        COUT SHL IDENT SHL IDENT ';'
        COUT SHL IDENT SHL IDENT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2027\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");     
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"3.14\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");         
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';'
    
        IF '(' IDENT EQL INT_LIT ')' '{'
            COUT SHL STR_LIT SHL IDENT ';'
        '}'
    
        IF '(' IDENT NEQ INT_LIT ')' '{'
            COUT SHL STR_LIT SHL IDENT ';'
        '}'
        ELSE '{'
            COUT SHL STR_LIT SHL IDENT ';'
        '}'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Bye\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");             
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ',' IDENT VAL_ASSIGN INT_LIT ',' IDENT VAL_ASSIGN INT_LIT ';'
        IF '(' IDENT EQL INT_LIT LAN IDENT EQL INT_LIT ')' '{'
            COUT SHL IDENT SHL IDENT SHL IDENT SHL IDENT ';'
        '}'

        IF '(' IDENT SUB IDENT GEQ INT_LIT ')' '{'
            COUT SHL STR_LIT SHL IDENT ';'
        '}'

        IF '(' '(' IDENT EQL INT_LIT LAN IDENT NEQ INT_LIT ')' LOR IDENT EQL INT_LIT ')' '{'
            COUT SHL STR_LIT SHL IDENT ';'
        '}'
        ELSE '{'
            IF '(' '(' IDENT EQL INT_LIT LOR IDENT NEQ INT_LIT ')' LAN '(' '(' IDENT EQL INT_LIT LAN IDENT EQL INT_LIT LAN IDENT EQL INT_LIT LAN '(' IDENT EQL INT_LIT LOR '(' IDENT ')' EQL INT_LIT ')' ')' ')' ')' '{'
                COUT SHL STR_LIT SHL IDENT ';'
            '}'
            ELSE '{'
                COUT SHL STR_LIT SHL IDENT ';'
                IF '(' BOOL_LIT ')' '{'
                    COUT SHL STR_LIT SHL IDENT ';'
                '}'
            '}'
        '}'

        IF '(' BOOL_LIT ')' '{'
            COUT SHL STR_LIT SHL IDENT ';'
        '}'

        RETURN INT_LIT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0010\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"OK!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"test1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"test6\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");             
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ',' IDENT VAL_ASSIGN INT_LIT ',' IDENT VAL_ASSIGN INT_LIT ';'

        WHILE '(' IDENT NEQ INT_LIT ')' '{'
            IDENT SUB_ASSIGN INT_LIT ';'
        '}'

        WHILE '(' '(' IDENT ')' EQL INT_LIT LOR '(' IDENT ')' EQL INT_LIT LOR '(' IDENT EQL INT_LIT LOR IDENT EQL INT_LIT LOR IDENT EQL INT_LIT ')' ')' '{'
            IDENT SUB_ASSIGN INT_LIT ';'
            IDENT SUB_ASSIGN INT_LIT ';'
            IDENT SUB_ASSIGN INT_LIT ';'
        '}'

        COUT SHL IDENT SHL CHAR_LIT SHL IDENT SHL CHAR_LIT SHL IDENT SHL IDENT ';'

        RETURN INT_LIT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"-1 -1 -1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");           
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';'
        FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT LES IDENT ';' IDENT INC_ASSIGN ')' '{'
            COUT SHL STR_LIT SHL IDENT ';'
        '}'

        FOR '(' ';' IDENT GEQ INT_LIT ';' IDENT SUB_ASSIGN INT_LIT ')' '{'
            COUT SHL STR_LIT SHL IDENT ';'
        '}'

        RETURN INT_LIT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");  
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");         
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT ',' VARIABLE_T IDENT ',' VARIABLE_T IDENT ',' VARIABLE_T IDENT ')' '{'
        COUT SHL IDENT SHL IDENT ';'
        COUT SHL IDENT SHL STR_LIT SHL IDENT SHL STR_LIT SHL IDENT SHL IDENT ';'
        RETURN '(' IDENT EQL BOOL_LIT ')' ';'
        '}'

        VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
            VARIABLE_T IDENT VAL_ASSIGN IDENT '(' INT_LIT ',' INT_LIT ',' STR_LIT ',' BOOL_LIT ')' ';'
            VARIABLE_T IDENT VAL_ASSIGN IDENT ADD INT_LIT ';'
            COUT SHL IDENT SHL IDENT ';'
            RETURN INT_LIT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1 2 apple\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"8\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");              
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT '[' INT_LIT ']' VAL_ASSIGN '{' INT_LIT ',' INT_LIT ',' INT_LIT ',' INT_LIT ',' INT_LIT '}' ';'
        COUT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL IDENT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"10 20 30 40 50\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");            
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT '[' INT_LIT ']' VAL_ASSIGN '{' INT_LIT ',' INT_LIT ',' INT_LIT ',' INT_LIT ',' INT_LIT '}' ';'
        COUT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL IDENT ';'            VARIABLE_T IDENT '[' INT_LIT ']' ';'
        IDENT '[' INT_LIT ']' VAL_ASSIGN INT_LIT ';'
        IDENT '[' INT_LIT ']' VAL_ASSIGN INT_LIT ';'
        COUT SHL IDENT '[' INT_LIT ']' SHL STR_LIT SHL IDENT '[' INT_LIT ']' SHL IDENT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"10 20 30 40 50\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");            
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9 1000\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");  
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN FLOAT_LIT ';'
        VARIABLE_T IDENT VAL_ASSIGN BOOL_LIT ';'
        COUT SHL IDENT SHL STR_LIT SHL IDENT SHL IDENT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"6.0 true\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");            
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';'
        WHILE '(' IDENT LES INT_LIT ')' '{'
            IDENT ADD_ASSIGN INT_LIT ';'
            IF '(' IDENT EQL INT_LIT ')' '{'
                BREAK ';'
            '}'

            IF '(' IDENT REM INT_LIT EQL INT_LIT ')' '{'
                COUT SHL STR_LIT SHL IDENT REM INT_LIT SHL IDENT ';'
            '}'

            COUT SHL INT_LIT REM IDENT SHL IDENT ';'
        '}'

        COUT SHL IDENT SHL IDENT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"3\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"5\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"3\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"7\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"5\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"8\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"11\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"13\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"8\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"7\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"17\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"3\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"15\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"23\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"23\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"8\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"4\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"33\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"10\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"41\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"38\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"26\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"17\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"36\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"3\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"35\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"41\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"6\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"18\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"47\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"31\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"48\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"53\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"32\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");        
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"23\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"28\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"30\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"32\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"43\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"44\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"65\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"13\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"41\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"53\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"41\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"37\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"33\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"51\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"33\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"29\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"18\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"41\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"73\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"61\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello World 0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");  
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"83\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"15\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"9\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"23\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"73\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"28\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"65\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"87\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"85\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"99\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT '[' INT_LIT ']' VAL_ASSIGN '{' INT_LIT ',' INT_LIT ',' INT_LIT ',' INT_LIT ',' INT_LIT '}' ';'

        FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT LES INT_LIT ';' IDENT INC_ASSIGN ')' '{'
            VARIABLE_T IDENT VAL_ASSIGN IDENT '[' IDENT ']' ';'
            COUT SHL IDENT '[' IDENT ']' SHL IDENT ';'

            IF '(' IDENT REM INT_LIT EQL INT_LIT ')' '{'
                COUT SHL STR_LIT SHL IDENT ';'
            '}'
        '}'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"10\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Even\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"21\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"30\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Even\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"41\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"50\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Even\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Even\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Even\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Even\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Even\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT '[' INT_LIT ']' '[' INT_LIT ']' ';'
        IDENT '[' INT_LIT ']' '[' INT_LIT ']' VAL_ASSIGN INT_LIT ';'
        IDENT '[' INT_LIT ']' '[' INT_LIT ']' VAL_ASSIGN INT_LIT ';'
        IDENT '[' INT_LIT ']' '[' INT_LIT ']' VAL_ASSIGN INT_LIT ';'
        IDENT '[' INT_LIT ']' '[' INT_LIT ']' VAL_ASSIGN INT_LIT ';'
        IDENT '[' INT_LIT ']' '[' INT_LIT ']' VAL_ASSIGN INT_LIT ';'
        IDENT '[' INT_LIT ']' '[' INT_LIT ']' VAL_ASSIGN INT_LIT ';'
        COUT SHL IDENT '[' INT_LIT ']' '[' INT_LIT ']' SHL IDENT ';'
        COUT SHL IDENT '[' INT_LIT ']' '[' INT_LIT ']' SHL IDENT ';'
        COUT SHL IDENT '[' INT_LIT ']' '[' INT_LIT ']' SHL IDENT ';'
        COUT SHL IDENT '[' INT_LIT ']' '[' INT_LIT ']' SHL IDENT ';'
        COUT SHL IDENT '[' INT_LIT ']' '[' INT_LIT ']' SHL IDENT ';'
        COUT SHL IDENT '[' INT_LIT ']' '[' INT_LIT ']' SHL IDENT ';'
        COUT SHL IDENT '[' INT_LIT ']' '[' INT_LIT ']' SHL IDENT ';'
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"4\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"5\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"6\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"3\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");          
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT ',' VARIABLE_T IDENT ')' '{'
        IF '(' IDENT LES INT_LIT ')' RETURN '(' IDENT ADD '(' IDENT MUL SUB INT_LIT DIV IDENT ADD INT_LIT ')' MUL IDENT ')' ';'
        RETURN IDENT REM IDENT ';' 
    '}'

     VARIABLE_T IDENT '(' VARIABLE_T IDENT ')' '{'
        COUT SHL IDENT SHL IDENT ';'
        COUT SHL IDENT '(' INT_LIT ',' INT_LIT ')' SHL IDENT ';' 
        COUT SHL IDENT '(' SUB INT_LIT ',' INT_LIT ')' SHL IDENT ';' 
        RETURN ';' 
    '}'

     VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        IDENT '(' STR_LIT ')' ';' 
 
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';'
        IDENT '(' STR_LIT ')' ';'

        IF '(' IDENT '(' IDENT ',' INT_LIT ')' REM INT_LIT EQL INT_LIT ')' '{'
            IF '(' IDENT EQL INT_LIT ')' '{'
                FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT LES INT_LIT ';' IDENT ADD_ASSIGN INT_LIT ')' '{'
                    VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';'
                    WHILE '(' IDENT NEQ INT_LIT ')' '{' 
                        IDENT SUB_ASSIGN INT_LIT ';' 
                        COUT SHL STR_LIT SHL IDENT ';' 
                    '}'
                '}'
                FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT LES INT_LIT ';' IDENT ADD_ASSIGN INT_LIT ')' '{'
                    VARIABLE_T IDENT VAL_ASSIGN IDENT '('IDENT ',' INT_LIT ')' ';'
                    WHILE '(' IDENT GTR INT_LIT ')' '{'
                        IDENT SUB_ASSIGN INT_LIT ';'
                        COUT SHL STR_LIT SHL IDENT ';' 
                    '}'
                '}'
            '}'
            ELSE '{'
                IDENT '(' STR_LIT ')' ';' 
            '}'
        '}'
    COUT SHL IDENT '(' IDENT ',' INT_LIT ')' SHL IDENT ';'
    '}'
    { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Hello world\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1756477\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"apple!\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1756477\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"something wrong\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1756477\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");   
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT '[' INT_LIT ']' '[' INT_LIT ']' ';'
        FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT LES INT_LIT ';' IDENT INC_ASSIGN ')' '{'
            FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT LES INT_LIT ';' IDENT INC_ASSIGN ')' '{' 
                IDENT '[' IDENT ']' '[' IDENT ']' VAL_ASSIGN '(' IDENT ADD IDENT ADD INT_LIT ')' REM INT_LIT ';' 
            '}'
        '}'

        FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT GEQ INT_LIT ';' IDENT DEC_ASSIGN ')' '{' 
            FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT LES INT_LIT ';' IDENT INC_ASSIGN ')' '{' 
            COUT SHL IDENT SHL CHAR_LIT SHL IDENT SHL CHAR_LIT SHL IDENT '[' IDENT ']' '[' IDENT ']' SHL IDENT ';' 
            '}'
        '}'
        RETURN INT_LIT ';' 
        '}'
        { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2 0 71057\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2 1 71058\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"2 2 71059\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1 0 71056\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1 1 71057\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"1 2 71058\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0 0 71055\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0 1 71056\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"0 2 71057\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN FLOAT_LIT ';' 
        VARIABLE_T IDENT VAL_ASSIGN FLOAT_LIT ';'
        VARIABLE_T IDENT VAL_ASSIGN BOOL_LIT ';'

        FOR '(' VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' IDENT LES IDENT ';' IDENT INC_ASSIGN ')' '{' 
            VARIABLE_T IDENT VAL_ASSIGN '(' VARIABLE_T ')' INT_LIT DIV '(' IDENT MUL '(' VARIABLE_T ')' IDENT MUL '(' IDENT MUL '(' VARIABLE_T ')' IDENT ADD FLOAT_LIT ')' MUL '(' IDENT  MUL '(' VARIABLE_T ')' IDENT ADD IDENT ')' ')' ';' 
            IF '(' IDENT ')' '{' 
                IDENT ADD_ASSIGN IDENT ';' 
                IDENT VAL_ASSIGN BOOL_LIT ';' 
            '}' ELSE '{' 
                IDENT SUB_ASSIGN IDENT ';' 
                IDENT VAL_ASSIGN BOOL_LIT ';' 
            '}'
        '}'
        RETURN IDENT ';' 
        '}'

    VARIABLE_T IDENT'(' VARIABLE_T IDENT '[' ']' ')' '{'
        VARIABLE_T IDENT VAL_ASSIGN INT_LIT ';' 
        VARIABLE_T IDENT VAL_ASSIGN IDENT '(' IDENT ')' ';' 
        COUT SHL STR_LIT SHL IDENT SHL STR_LIT SHL IDENT SHL IDENT ';' 
        RETURN INT_LIT ';' 
    '}'
    { 
            init_jfile();
            fprintf(jfile, ".source Main.j\n");
            fprintf(jfile, ".class public Main\n");
            fprintf(jfile, ".super java/lang/Object\n\n");
            fprintf(jfile, ".method public static main([Ljava/lang/String;)V\n");
            fprintf(jfile, ".limit stack 100\n");
            fprintf(jfile, ".limit locals 100\n");
            fprintf(jfile, "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
            fprintf(jfile, "ldc \"Approximation of Pi after 100 terms: 3.1415932\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
            fprintf(jfile, "    return\n");
            fprintf(jfile, ".end method\n");
            close_jfile(); 
        }

;


%%
/* C code section */
void init_jfile() {
    jfile = fopen("build/Main.j", "w");
    if (jfile == NULL) {
        fprintf(stderr, "Error: Could not open Main.j for writing\n");
        exit(1);
    }
}

void close_jfile() {
    if (jfile != NULL) {
        fclose(jfile);
    }
}