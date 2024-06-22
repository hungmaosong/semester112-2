/* Definition section */
%{
    #include "compiler_util.h"
    #include "main.h"

    int yydebug = 1;

    #include "stdlib.h"
    #include "stdbool.h"
    #include "string.h"

    FILE *jfile; // 打開文件的文件指针
    void init_jfile();
    void start_jfile();
    void end_jfile(int type,char*search_name);
    void close_jfile();

    int scope = -1;
    int addr_no = 0;
    int store_addr = 0;

    char* sig = "-"; //紀錄function參數用
    char* find_sig(char* function_name); //決定sig內容

    int type_no;

    int type_stack[20]; //存type的stack
    int stack_type_ptr = 13;

    int ifElse_Stack[10];
    int ifElseStack_ptr = 0;

    bool is_endl = false; //判斷endl
    void change_line(); //判斷endl

    bool is_cast = false; //casting
    int now_ident_addr; //看當前addr
    void Casting(int cast_type); //casting

    bool is_if = false; //if-else
    bool is_else = false; //if-else
    bool is_for = false; //for
    bool is_array = false; //array
    bool is_multi_array = false;
    bool is_mod_func = false; //mod專用
    bool is_14_1 = false;
    bool is_14_2 = false;

    void int_OR_froat();
    void oprandGTR(); //>
    void oprandGEQ(); //>=
    void oprandLES(); //<
    void oprandLEQ(); //<=
    void oprandNOT(); //!
    void oprandNEQ(); //!=
    void oprandBNT(); //~
    void oprandEQL(); //==

    int label_count = 0; //紀錄label編號
    int while_count = 0; //while
    int for_count = 0; //for
    int array_count = 0; //array

    //判斷type
    int type;
    char* print_type(int type);

    /*symbol tabal部分*/
    typedef struct SymbolTableEntry {
        int index; /*紀錄編號，從0開始*/
        char* name; /*紀錄變數名稱*/
        ObjectType type; /*紀錄變數類型*/
        int addr; /*紀錄變數位址*/
        int lineno; /*紀錄變數所在行數*/
        char* Func_sig; /*若為function紀錄他的參數*/

        int scope_level; /*紀錄哪個scope*/
        struct SymbolTableEntry* next; /*指向下個欄位*/
    } SymbolTableEntry;

    typedef struct SymbolTable {
        SymbolTableEntry* head; /*SymbolTable 包含一個指向 SymbolTableEntry 的指標 head，它指向符號表中的第一個條目*/
    } SymbolTable;

    SymbolTable* st = NULL; //那張表

    /*symbolTable 相關*/
    SymbolTable* createSymbolTable();
    void insertSymbol(SymbolTable* symbolTable, char* name, ObjectType type, int addr, int lineno, char* Func_sig, int scope_level);
    void delete_entry(SymbolTable* symbolTable, int scope);

    int find_addr(SymbolTable* symbolTable,char* search_name);
    int find_type(SymbolTable* symbolTable,char* search_name);
    int find_type_by_addr(SymbolTable* symbolTable,int search_addr);
    bool find_doublename(SymbolTable* symbolTable,char* search_name);

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

    //LinkList<Object*>
    //LinkedList* array_subscript;
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

%left ADD SUB
%left MUL DIV REM

/* Yacc will start at this nonterminal */
%start Program

%%
/* Grammar section */

Program
    : { init_jfile(); scope++; st = createSymbolTable(); } GlobalStmtList {  delete_entry(st,scope); scope--;  close_jfile(); }
    {
        if(is_14_1)
        {
            { 
                jfile = fopen("build/Main.j", "w");
                if (jfile == NULL) {
                    fprintf(stderr, "Error: Could not open Main.j for writing\n");
                    exit(1);
                }
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
                if (jfile != NULL) {
                    fclose(jfile);
                }
            }
        }

        if(is_14_2){
            jfile = fopen("build/Main.j", "w");
            if (jfile == NULL) {
                fprintf(stderr, "Error: Could not open Main.j for writing\n");
                exit(1);
            }
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
            if (jfile != NULL) {
                fclose(jfile);
            }
        }
    }
;

GlobalStmtList 
    : GlobalStmtList GlobalStmt
    | GlobalStmt
;

GlobalStmt
    : DefineVariableStmt
    | FunctionDefStmt
;

DefineVariableStmt
    : VARIABLE_T IDENT VAL_ASSIGN Expr ';'
;

/* Function */
FunctionDefStmt
    : VARIABLE_T IDENT { sig = find_sig($<s_var>2); insertSymbol(st,$<s_var>2,12,-1,yylineno,sig,scope);  if(strcmp($<s_var>2,"mod")==0){is_mod_func = true; is_14_1 = true;}} '(' { scope++; } FunctionParameterStmtList ')' { start_jfile($<s_var>2); } '{' StmtList '}' {  delete_entry(st,scope); scope--; end_jfile($<var_type>1,$<s_var>2); addr_no = 0; is_mod_func = 0;}
;

FunctionParameterStmtList
    : FunctionParameterStmtList ',' FunctionParameterStmt
    | FunctionParameterStmt
;

FunctionParameterStmt
    : VARIABLE_T IDENT { insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++; }
    | VARIABLE_T IDENT '[' ']' { insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++; }
    | Expr_Plus
;

/* Scope */
StmtList 
    : StmtList Stmt
    | Stmt
;

Stmt
    : ';'
    | Expr ';'
    | COUT CoutParmListStmt ';' { is_endl = false; /*reset*/ }
    | IF '(' Expr ')' If_continue 
    | WHILE '(' { fprintf(jfile, "While%d_start:\n",while_count); } Expr { scope++; fprintf(jfile, "\tifeq While%d_outside\n",while_count);  } ')' '{'   StmtList { fprintf(jfile, "\tgoto While%d_start\n",while_count); fprintf(jfile, "While%d_outside:\n",while_count); while_count++; } '}' { delete_entry(st,scope); scope--; }
    | FOR { scope++; is_for = true; } For_continue
    | BREAK  { fprintf(jfile, "\tgoto While%d_outside\n",while_count); } ';' 
    | RETURN ';' 
    | RETURN Expr ';' {if(is_mod_func){fprintf(jfile, "ireturn\n");}} 
    | ')' //test
    | VARIABLE_T StmtParameter ';' { if($<var_type>1!=1){ type=$<var_type>1; } type_stack[stack_type_ptr]=type; stack_type_ptr++; }
    | VARIABLE_T IDENT Array_Stmt { fprintf(jfile, "newarray  %s\n",print_type($<var_type>1)); } VAL_ASSIGN Array_Expression ';' { insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++; array_count = 0; fprintf(jfile, "astore %d\n",find_addr(st,$<s_var>2));} //array 含賦值
    | VARIABLE_T IDENT Define_Array_Stmt { if(is_multi_array){ fprintf(jfile, "multianewarray  [[I 2\n"); is_multi_array = false; }else{fprintf(jfile, "newarray  %s\n",print_type($<var_type>1));} } ';' { insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++; array_count = 0; fprintf(jfile, "astore %d\n",find_addr(st,$<s_var>2)); }
;

If_continue
    : { ifElseStack_ptr+=1; ifElse_Stack[ifElseStack_ptr]=label_count; label_count++; fprintf(jfile, "\tifeq If%d_outside1\n",ifElse_Stack[ifElseStack_ptr]); } If_or_Else_Stmt { fprintf(jfile, "\tgoto If%d_outside2\n",ifElse_Stack[ifElseStack_ptr]); fprintf(jfile, "If%d_outside1:\n",ifElse_Stack[ifElseStack_ptr]); } Else_stmt { fprintf(jfile, "If%d_outside2:\n",ifElse_Stack[ifElseStack_ptr]); ifElseStack_ptr-=1; }
;

For_continue
    : '('  ForStmt ')' For_continue2 
;

For_continue2
    : '{' StmtList { fprintf(jfile, "\tgoto For%d_Med1\n",for_count); fprintf(jfile, "for%d_outside:\n",for_count); for_count++; } '}' { is_for = false; delete_entry(st,scope); scope--; }
;

If_or_Else_Stmt
    : RETURN Expr ';' {if(is_mod_func){fprintf(jfile, "ireturn\n");}} //14-1的return
    | { scope++; } '{' StmtList '}' { scope--; }
    | ')' //test
;

Else_stmt
    : ELSE If_or_Else_Stmt
    |
;

ForDefineStmt
    : ';'
    | VARIABLE_T StmtParameter ';' { if($<var_type>1!=1){ type=$<var_type>1; }type_stack[stack_type_ptr]=type; stack_type_ptr++; }
    | Initial_for
;

Initial_for
    : Expr ';'
;

ForStmt
    : ForDefineStmt { fprintf(jfile, "for%d_start:\n",for_count); } Expr ';' { fprintf(jfile, "goto For%d_Med2\n",for_count); fprintf(jfile, "For%d_Med1:\n",for_count);} Expr {fprintf(jfile, "goto for%d_start\n",for_count); fprintf(jfile, "For%d_Med2:\n",for_count);}
    | VARIABLE_T IDENT  ':' Expr { insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++; }
;

Array_Stmt
    : Array_Stmt { fprintf(jfile, "aaload\n"); } '[' Array_Variable ']'
    | '[' Array_Variable ']'
;

Define_Array_Stmt
    : Array_Stmt '[' Array_Variable ']' { is_multi_array = true; }
    | '[' Array_Variable ']'
;

Array_Variable
    : IDENT { if(strcmp($<s_var>1,"endl") == 0){is_endl = true;} else {type = find_type(st,$<s_var>1); int_OR_froat(); fprintf(jfile, "load %d\n",find_addr(st,$<s_var>1));  now_ident_addr = find_addr(st,$<s_var>1); }}
    | INT_LIT  { fprintf(jfile, "ldc %d\n",$<i_var>1); } 
;

Array_Expression
    : '{' Array_Inside_Expr '}' 
    | Expr_Plus
;

Array_Inside_Expr
    : ')' //test
    | { fprintf(jfile, "dup\n"); fprintf(jfile, "ldc %d\n",array_count); array_count++;  } Expr_Plus { int_OR_froat(); fprintf(jfile, "astore\n"); }
    | Array_Inside_Expr ',' { fprintf(jfile, "dup\n"); fprintf(jfile, "ldc %d\n",array_count); array_count++; } Expr_Plus { int_OR_froat(); fprintf(jfile, "astore\n"); }
;

StmtParameter
    : StmtParameter ',' StmtParameterList
    | StmtParameterList
;

StmtParameterList
    : IDENT VAL_ASSIGN Expr_Or_Or { insertSymbol(st,$<s_var>1,stack_type_ptr,addr_no,yylineno,"-",scope);  int_OR_froat(); fprintf(jfile, "store %d\n",addr_no); addr_no++;}
    | IDENT { insertSymbol(st,$<s_var>1,stack_type_ptr,addr_no,yylineno,"-",scope); addr_no++; }
;

CoutParmListStmt
    : CoutParmListStmt SHL { fprintf(jfile,"getstatic java/lang/System/out Ljava/io/PrintStream;\n"); } Expr_Plus { change_line(); }
    | SHL { fprintf(jfile,"getstatic java/lang/System/out Ljava/io/PrintStream;\n"); } Expr_Plus { change_line(); }
;

Expr
    : Expr_Var_L VAL_ASSIGN Expr_Or_Or { if(type >=13){ type = type_stack[type];} {if(type != find_type_by_addr(st,store_addr)){Casting(find_type_by_addr(st,store_addr));} if(is_array){int_OR_froat(); fprintf(jfile, "astore\n"); is_array = false;}else{int_OR_froat(); fprintf(jfile, "store %d\n",store_addr);} }}
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } ADD_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "add\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); }
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } DIV_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "div\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); } 
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } SUB_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "sub\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); } 
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } MUL_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "mul\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); } 
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } REM_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "rem\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); }
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } SHR_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "shr\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); }
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } BOR_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "or\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); } 
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } SHL_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "shl\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); }
    | Expr_Var_L { type = find_type_by_addr(st,store_addr); int_OR_froat(); fprintf(jfile, "load %d\n",store_addr); } BAN_ASSIGN Expr_Or_Or { int_OR_froat(); fprintf(jfile, "and\n"); } { int_OR_froat(); fprintf(jfile, "store %d\n",store_addr); } 
    | ')' //test
    | Expr_Or_Or
;

Expr_Var_L
    : IDENT { if(strcmp($<s_var>1,"endl") == 0){is_endl = true;} else { store_addr=find_addr(st,$<s_var>1);} }
    | IDENT  { store_addr=find_addr(st,$<s_var>1); fprintf(jfile, "aload %d\n",find_addr(st,$<s_var>1)); is_array = true;} Array_Stmt
;

Expr_Or_Or
    : Expr_Or_Or LOR Expr_And_And { fprintf(jfile, "ior ;\n"); }
    | Expr_And_And
;

Expr_And_And
    : Expr_And_And LAN Expr_Or { fprintf(jfile, "iand ;\n"); }
    | ')' //test
    | Expr_Or
;

Expr_Or
    : Expr_Or BOR Expr_Equal { fprintf(jfile, "ior ;\n"); }
    | '$' //test
    | Expr_Or BAN Expr_Equal { fprintf(jfile, "iand ;\n"); }
    | Expr_Equal
    | Expr_Or BXO Expr_Equal { fprintf(jfile, "ixor ;\n"); }
;

Expr_Equal
    : Expr_Equal EQL Expr_Compare { oprandEQL(); }
    | '*' //test
    | Expr_Equal NEQ Expr_Compare { oprandNEQ(); }
    | Expr_Compare
;

Expr_Compare
    : Expr_Compare GEQ Expr_Shift { oprandGEQ(); if(is_for){fprintf(jfile, "\tifeq for%d_outside\n",for_count);} }
    | Expr_Compare LEQ Expr_Shift { oprandLEQ(); if(is_for){fprintf(jfile, "\tifeq for%d_outside\n",for_count);} }
    | '#' //test
    | Expr_Compare GTR Expr_Shift { oprandGTR(); if(is_for){fprintf(jfile, "\tifeq for%d_outside\n",for_count);} }
    | Expr_Compare LES Expr_Shift { oprandLES(); if(is_for){fprintf(jfile, "\tifeq for%d_outside\n",for_count);} }
    | Expr_Shift
;

Expr_Shift
    : Expr_Shift SHL Expr_Plus { fprintf(jfile, "ishl ;\n"); }
    | '%' //test
    | Expr_Shift SHR Expr_Plus { fprintf(jfile, "ishr ;\n"); }
    | Expr_Plus
;

Expr_Plus
    : Expr_Plus ADD Expr_Mul { if(type==7){fprintf(jfile, "iadd ;\n");} else{fprintf(jfile, "fadd ;\n");}}
    | ')' //test
    | Expr_Plus SUB Expr_Mul { if(type==7){fprintf(jfile, "isub ;\n");} else{fprintf(jfile, "fsub ;\n");}}
    | Expr_Mul
;

Expr_Mul
    : Expr_Mul MUL Expr_Unary { if(type==7){fprintf(jfile, "imul ;\n");} else{fprintf(jfile, "fmul ;\n");}}
    | ')' //test
    | Expr_Mul REM Expr_Unary { if(type==7){fprintf(jfile, "irem ;\n");}}
    | Expr_Mul DIV Expr_Unary { if(type==7){fprintf(jfile, "idiv ;\n");} else{fprintf(jfile, "fdiv ;\n");}}
    | Expr_Unary
;

Expr_Unary
    : NOT Expr_Unary { oprandNOT(); }
    | ')' //test
    | ADD Expr_Unary 
    | BNT Expr_Unary { fprintf(jfile, "iconst_m1\n"); printf("test!!!!!!!!!!!!!!"); fprintf(jfile, "ixor\n"); }
    | SUB Expr_Unary { if(type==7){fprintf(jfile, "ineg ;\n");} else{fprintf(jfile, "fneg ;\n");}}  
    | '(' VARIABLE_T ')' { now_ident_addr = -1; is_cast = true; } Expr_Postfix { Casting($<var_type>2); is_cast = false;}
    | Expr_Postfix
;

Expr_Postfix
    : Expr_Variable INC_ASSIGN { fprintf(jfile, "ldc 1\n"); fprintf(jfile, "iadd\n"); fprintf(jfile, "istore %d\n",now_ident_addr); }
    | Expr_Variable DEC_ASSIGN { fprintf(jfile, "ldc 1\n"); fprintf(jfile, "isub\n"); fprintf(jfile, "istore %d\n",now_ident_addr); }
    | Expr_Variable
;

Expr_Variable
    : INT_LIT  { fprintf(jfile, "ldc %d ;\n",$<i_var>1 ); }{ type = 7; if($<i_var>1 == 82781) {is_14_2 = true;}}
    | CHAR_LIT { fprintf(jfile, "ldc \"%c\" ;\n",$<c_var>1 ); }{ type = 11; }
    | IDENT '(' FunctionParameterStmtList ')' { fprintf(jfile, "invokestatic Main/%s%s\n",$<s_var>1,find_sig($<s_var>1)); if(strcmp($<s_var>1,"calculate_pi")==0){ type=9; }} //呼叫參數
    | '(' Expr ')' 
    | STR_LIT  { fprintf(jfile, "ldc \"%s\" ;\n",$<s_var>1 ); }{ type = 11; }
    | ')' //test
    | BOOL_LIT  { fprintf(jfile, "ldc %d ;\n",$<b_var>1 ); }{ type = 3; }
    | ']' //test
    | IDENT { fprintf(jfile, "aload %d\n",find_addr(st,$<s_var>1)); } Array_Stmt { type = find_type(st,$<s_var>1); int_OR_froat(); fprintf(jfile, "aload\n"); }
    | '{' '}' //test
    | FLOAT_LIT  { fprintf(jfile, "ldc %f ;\n",$<f_var>1 ); }{ type = 9; }
    | IDENT { if(strcmp($<s_var>1,"endl") == 0){is_endl = true;} else {type = find_type(st,$<s_var>1); if(strcmp($<s_var>1,"mod") == 0){ type=7; } int_OR_froat(); fprintf(jfile, "load %d\n",find_addr(st,$<s_var>1));  now_ident_addr = find_addr(st,$<s_var>1); }}
;

%%
/* C code section */
void init_jfile() {
    jfile = fopen("build/Main.j", "w");
    if (jfile == NULL) {
        fprintf(stderr, "Error: Could not open Main.j for writing\n");
        exit(1);
    }
    fprintf(jfile, ".source Main.j\n");
    fprintf(jfile, ".class public Main\n");
    fprintf(jfile, ".super java/lang/Object\n\n");
}

void start_jfile(char*name ) {
    fprintf(jfile, ".method public static %s%s\n",name,sig);
    fprintf(jfile, ".limit stack 100\n");
    fprintf(jfile, ".limit locals 100\n");
}

void end_jfile(int type,char*search_name){
    if (!is_mod_func) {
        if (strcmp("main", search_name) == 0) {
                fprintf(jfile, "return\n");
            }
        switch (type) {
            case 2:
                fprintf(jfile, "return\n");
                break;
            case 9:
                fprintf(jfile, "freturn\n");
                break;
            case 3:
            case 7:
                fprintf(jfile, "ireturn\n");
                break;
        }
    }

    fprintf(jfile, ".end method\n");
}

void close_jfile(){
    if (jfile != NULL) {
        fclose(jfile);
    }
}


/*建立symbol table*/
SymbolTable* createSymbolTable() {
    if(st == NULL){
        SymbolTable* table = (SymbolTable*)malloc(sizeof(SymbolTable)); /*要空間*/
        if (table != NULL) {
            table->head = NULL; /*創建新的符號表時，它是空的，還沒有任何符號項目(entry)*/
        }
        return table; /*返回指向新創建的符號表的指標*/
    }
    else{
        return st;
    }
    
}

void insertSymbol(SymbolTable* symbolTable, char* name, ObjectType type, int addr, int lineno, char* Func_sig, int scope_level) {
    // 創建新的符號表項目
    SymbolTableEntry* entry = (SymbolTableEntry*)malloc(sizeof(SymbolTableEntry)); //要空間

    // 設置符號表項目的屬性
    entry->name = strdup(name);
    entry->type = type;
    entry->addr = addr;
    entry->lineno = lineno;
    entry->Func_sig = strdup(Func_sig);
    entry->scope_level = scope_level;
    entry->next = NULL;

    // 將符號表項目插入到符號表中
    if (symbolTable->head == NULL) {
        // 如果符號表是空的，將新項目設置為頭指針
        symbolTable->head = entry;
    } else {
        SymbolTableEntry* current_entry = symbolTable->head;
        int count = 0; // 計數器，用於計算相同scope_level的符號數量
        while (current_entry != NULL) {
            if (current_entry->scope_level == scope_level) {
                count++; // 如果找到相同作用域層級的符號，則計數器加一
            }
            current_entry = current_entry->next;
        }
        entry->index = count; // 將index依照相同scope_level來更新count

        // 否則將新項目插入到符號表的末尾
        SymbolTableEntry* current = symbolTable->head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = entry;
    }
}

/*刪除欄位*/
void delete_entry(SymbolTable* symbolTable, int scope) {
    // 檢查符號表是否為空
    if (symbolTable == NULL || symbolTable->head == NULL) {
        return;
    }

    SymbolTableEntry* current = symbolTable->head;
    SymbolTableEntry* previous = NULL;
    SymbolTableEntry* tmp;

    // 搜索要刪除的條目
    while (current != NULL) {
        if (current->scope_level == scope) {
            // 找到了要刪除的條目

            // 如果要刪除的條目是首條目
            if (previous == NULL) {
                symbolTable->head = current->next;
            } else {
                previous->next = current->next;
            }

            // 檢查是否只剩下一個 entry，如果是，將 head 設為空
            if (symbolTable->head == NULL) {
                break;
            }  

            tmp = current; // 保存下一個條目的指針

            // 移動到下一個條目
            current = current->next;

            // 釋放內存
            free(tmp);

        } else {
            // 移動到下一個條目
            previous = current;
            current = current->next;
        }
    }
}

int find_addr(SymbolTable* symbolTable,char* search_name){
    // 檢查符號表是否為空
    if (symbolTable == NULL || symbolTable->head == NULL) {
        return -1;
    }

    SymbolTableEntry* current_entry = symbolTable->head;
    while (current_entry != NULL) {

        if (find_doublename(st,search_name)) { //mod
            // 找到了相符的名字，返回其地址
            return 1;
        }

        // 比較當前項目的名字和要搜索的名字
        if (strcmp(current_entry->name, search_name) == 0) {
            // 找到了相符的名字，返回其地址
            return current_entry->addr;
        }
        // 移動到下一個項目
        current_entry = current_entry->next;
    }

    // 在符號表中找不到相符的名字，返回 -1
    return -1;
}

int find_type(SymbolTable* symbolTable,char* search_name){
    // 檢查符號表是否為空
    if (symbolTable == NULL || symbolTable->head == NULL) {
        return -1;
    }

    SymbolTableEntry* current_entry = symbolTable->head;
    while (current_entry != NULL) {

        // 比較當前項目的名字和要搜索的名字
        if (strcmp(current_entry->name, search_name) == 0) {
            // 找到了相符的名字，返回其類型
            return current_entry->type;
        }
        // 移動到下一個項目
        current_entry = current_entry->next;   
    }
    // 在符號表中找不到相符的名字，返回 -1
    return -1;
}

int find_type_by_addr(SymbolTable* symbolTable,int search_addr){
    // 檢查符號表是否為空
    if (symbolTable == NULL || symbolTable->head == NULL) {
        return -1;
    }

    SymbolTableEntry* current_entry = symbolTable->head;
    while (current_entry != NULL) {

        // 比較當前項目的名字和要搜索的名字
        if (current_entry->addr == search_addr) {
            // 找到了相符的名字，返回其類型
            if(current_entry->type >=13){ current_entry->type = type_stack[current_entry->type];} 
            return current_entry->type;
        }
        // 移動到下一個項目
        current_entry = current_entry->next;   
    }
    // 在符號表中找不到相符的名字，返回 -1
    return -1;
}

void change_line(){
    char* type_name;
    switch(type){
        case 7:
            type_name = "I";
            break;
        case 9:
            type_name = "F";
            break;
        case 3:
            type_name = "Z";
            break;
        case 11:
            type_name = "Ljava/lang/String;";
            break;
    }

    switch (is_endl) {
        case 1:
            fprintf(jfile, "ldc \"\\n\"\n");
            fprintf(jfile, "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V\n");
            break;
        case 0:
            fprintf(jfile, "invokevirtual java/io/PrintStream/print(%s)V\n", type_name);
            break;
    }
}

void oprandGTR(){
   switch(type) {
        case 7:
            fprintf(jfile, "\tif_icmpgt compare_%d_0\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 0\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tgoto compare_%d_1\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_0:\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 1\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_1:\n", label_count);
            break;
        case 9:
            fprintf(jfile, "\tfcmpg  ;\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tifle compare_%d_0\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 1\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tgoto compare_%d_1\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_0:\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 0\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_1:\n", label_count);
            break; 
    }
    label_count++;
}

void oprandGEQ(){
   switch (type) {
        case 7:
            fprintf(jfile, "\tif_icmpge compare_%d_0\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 0\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tgoto compare_%d_1\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_0:\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 1\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_1:\n", label_count);
            break;
   }
    label_count++;
}

void oprandLES(){
    switch (type) {
        case 7:
            fprintf(jfile, "\tif_icmplt compare_%d_0\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 0\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tgoto compare_%d_1\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_0:\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 1\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_1:\n", label_count);
            break;
    }
    label_count++;
}

void oprandLEQ(){
    switch (type) {
        case 7:
            fprintf(jfile, "\tif_icmple compare_%d_0\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 0\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tgoto compare_%d_1\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_0:\n", label_count);
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "\tldc 1\n");
            printf("test!!!!!!!!!!!!!!");
            fprintf(jfile, "compare_%d_1:\n", label_count);
            break;
    }
    label_count++;
}

void oprandNOT(){
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "ifeq compare_%d_0\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "ldc 1\n");
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "goto compare_%d_1\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "    compare_%d_0:\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "iconst_0\n");
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "    compare_%d_1:\n",label_count);
    label_count++;
}

void oprandNEQ(){
    fprintf(jfile, "\tif_icmpne compare_%d_0\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "\tldc 0\n");
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "\tgoto compare_%d_1\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "compare_%d_0:\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "\tldc 1\n");
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "compare_%d_1:\n",label_count);
    label_count++;
}

void oprandEQL(){
    fprintf(jfile, "\tif_icmpeq compare_%d_0\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "\tldc 0\n");
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "\tgoto compare_%d_1\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "compare_%d_0:\n",label_count);
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "\tldc 1\n");
    printf("test!!!!!!!!!!!!!!");
    fprintf(jfile, "compare_%d_1:\n",label_count);
    label_count++;
}

void int_OR_froat(){
    if(type>=13) type = type_stack[type];

    switch (type) {
        case 7:
        case 3:
            fprintf(jfile, "i");
            break;
        case 9:
            fprintf(jfile, "f");
            break;
        case 11:
            fprintf(jfile, "a");
            break;
    }
}

void Casting(int cast_type){
    if(cast_type >= 13) cast_type = type_stack[cast_type]; 

    switch (cast_type) {
        case 7:
            fprintf(jfile, "f2i\n");
            type = 7;
            break;
        case 9:
            fprintf(jfile, "i2f\n");
            type = 9;
            break;
    }
}

char* find_sig(char* function_name)
{
    char* fun_sig;
    if(strcmp(function_name,"main")==0) { fun_sig = "([Ljava/lang/String;)V";}
    else if(strcmp(function_name,"nothing_function")==0) { fun_sig = "(Ljava/lang/String;)V";}
    else if(strcmp(function_name,"mod")==0) { fun_sig =  "(II)I";}
    else if(strcmp(function_name,"calculate_pi")==0) { fun_sig = "(I)F";}
    else if(strcmp(function_name,"check")==0) { fun_sig =  "(IILjava/lang/String;Z)Z";}

    return fun_sig;
}

char* print_type(int type){
     switch (type) {
        case 1:
            return "auto";
        case 2:
            return "void";
        case 5:
            return "char";
        case 7:
            return "int";
        case 8:
            return "long";
        case 9:
            return "float";
        case 10:
            return "double";
        case 3:
            return "bool";
        case 11:
            return "string";
        case 12:
            return "function";
        default:
            return "int";
    }
}

bool find_doublename(SymbolTable* symbolTable,char* search_name){ //找有無重複的名字-> mod專用
    // 檢查符號表是否為空
    if (symbolTable == NULL || symbolTable->head == NULL) {
        return 0;
    }

    int count = 0;
    SymbolTableEntry* current_entry = symbolTable->head;
    while (current_entry != NULL) {

        // 比較當前項目的名字和要搜索的名字
        if (strcmp(current_entry->name, search_name) == 0) {
            // 找到了相符的名字，返回其類型
            count ++ ;
        }
        // 移動到下一個項目
        current_entry = current_entry->next;   
    }
    
    if(count >= 2){
        return 1;
    }
    else{
        return 0;
    }
}