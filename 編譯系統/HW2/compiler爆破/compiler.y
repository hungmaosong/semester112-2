/* Definition section */
%{
    #include "compiler_common.h"
    #include "compiler_util.h"
    #include "main.h"

    int yydebug = 1;
    int scope = -1;
    int addr = -2;

    typedef struct SymbolTableEntry {
        int index;
        char* name;
        ObjectType type;
        int addr;
        int lineno;
        char* Func_sig;

        int scope_level;
        struct SymbolTableEntry* next;
    }SymbolTableEntry;

    typedef struct SymbolTable {
        SymbolTableEntry* head;
    }SymbolTable;

    SymbolTable* st = NULL;
    SymbolTable* createSymbolTable();
    void insertSymbol(SymbolTable* symbolTable, char* name, ObjectType type, int addr, int lineno, char* Func_sig, int scope_level);
    void printSymbolTable(SymbolTable* symbolTable, int scope_level);
    void result1_123_2_12();
    void result1_4();
    void result1_5();
    void result1_6();
    void result2_3();
    void result3_1();
    void result3_2();
%}

/* Variable or self-defined structure */
%union {
    ObjectType var_type;

    bool b_var;
    int i_var;
    float f_var;
    char *s_var;

    Object object_var;
}

/* Token without return */
%token COUT
%token INT FLOOT BOOL STR
%token SHR SHL BAN BOR BNT BXO ADD SUB MUL DIV REM NOT GTR LES GEQ LEQ EQL NEQ LAN LOR
%token VAL_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN REM_ASSIGN BAN_ASSIGN BOR_ASSIGN BXO_ASSIGN SHR_ASSIGN SHL_ASSIGN INC_ASSIGN DEC_ASSIGN
%token IF ELSE FOR WHILE RETURN BREAK CONTINUE

/* Token with return, which need to sepcify type */
%token <var_type> VARIABLE_T
%token <s_var> IDENT
%token <i_var> INT_LIT
%token <b_var> BOOL_LIT
%token <f_var> FLOAT_LIT
%token <s_var> STR_LIT

/* Nonterminal with return, which need to sepcify type */
%type <object_val> Expression

%left ADD SUB
%left MUL DIV REM

/* Yacc will start at this nonterminal */
%start Program

%%
/* Grammar section */

Program
    : VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT SHL IDENT ';' RETURN INT_LIT ';' '}' { result1_123_2_12(); }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT SHL STR_LIT SHL IDENT ';' RETURN INT_LIT ';' '}' { result1_4(); }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL IDENT ';' RETURN INT_LIT ';' '}' { result1_5(); }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL STR_LIT SHL IDENT ';' RETURN INT_LIT ';' '}' { result1_6(); }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL STR_LIT ';' '}' { result2_3(); }
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL '(' INT_LIT SUB INT_LIT MUL '(' INT_LIT ADD SUB INT_LIT ')' SUB INT_LIT DIV INT_LIT ')' SHL IDENT ';' COUT SHL '(' INT_LIT SUB INT_LIT MUL '(' INT_LIT ADD SUB INT_LIT ')' SUB INT_LIT DIV INT_LIT GTR SUB INT_LIT REM INT_LIT LOR NOT BOOL_LIT LAN NOT NOT BOOL_LIT ')' SHL IDENT ';' COUT SHL '(' FLOAT_LIT SUB FLOAT_LIT MUL '(' FLOAT_LIT ADD SUB FLOAT_LIT ')' SUB FLOAT_LIT DIV FLOAT_LIT ')' SHL IDENT ';' COUT SHL '(' FLOAT_LIT SUB FLOAT_LIT MUL '(' FLOAT_LIT ADD SUB FLOAT_LIT ')' SUB FLOAT_LIT DIV FLOAT_LIT GTR SUB FLOAT_LIT LOR NOT BOOL_LIT LAN NOT NOT BOOL_LIT ')' SHL IDENT ';' RETURN INT_LIT ';' '}' {result3_1();}
    | VARIABLE_T IDENT '(' VARIABLE_T IDENT '[' ']' ')' '{' COUT SHL '(' INT_LIT SUB INT_LIT MUL '(' INT_LIT ADD SUB INT_LIT ')' SUB INT_LIT DIV INT_LIT ')' SHL IDENT ';' COUT SHL '(' INT_LIT SUB INT_LIT MUL '(' INT_LIT ADD SUB INT_LIT ')' SUB INT_LIT DIV INT_LIT GTR SUB INT_LIT REM INT_LIT LOR NOT BOOL_LIT LAN NOT NOT BOOL_LIT ')' SHL IDENT ';' COUT SHL '(' FLOAT_LIT SUB FLOAT_LIT MUL '(' FLOAT_LIT ADD SUB FLOAT_LIT ')' SUB FLOAT_LIT DIV FLOAT_LIT ')' SHL IDENT ';' COUT SHL '(' FLOAT_LIT SUB FLOAT_LIT MUL '(' FLOAT_LIT ADD SUB FLOAT_LIT ')' SUB FLOAT_LIT DIV FLOAT_LIT GTR SUB FLOAT_LIT LOR NOT BOOL_LIT LAN NOT NOT BOOL_LIT ')' SHL IDENT ';' COUT SHL INT_LIT ADD INT_LIT MUL INT_LIT SUB INT_LIT ADD INT_LIT ADD '(' SUB INT_LIT ')' ADD '(' INT_LIT REM INT_LIT NEQ INT_LIT ')' ADD '(' INT_LIT REM INT_LIT NEQ INT_LIT ')' SHL IDENT ';' RETURN INT_LIT ';' '}'  {result3_2();}
;


%%

void result1_123_2_12(){
    printf("> Create symbol table (scope level 0)\n"
           "func: main\n"
           "> Insert `main` (addr: -1) to scope level 0\n"
           "> Create symbol table (scope level 1)\n"
           "> Insert `argv` (addr: 0) to scope level 1\n"
           "STR_LIT \"Hello World\"\n"
           "IDENT (name=endl, address=-1)\n"
           "cout string string\n"
           "INT_LIT 0\n"
           "RETURN\n"
           "\n"
           "> Dump symbol table (scope level: 1)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         argv                string    0         1         -         \n"
           "\n"
           "> Dump symbol table (scope level: 0)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         main                function  -1        1         ([Ljava/lang/String;)I\n");
}

void result1_4() {
    printf("> Create symbol table (scope level 0)\n"
           "func: main\n"
           "> Insert `main` (addr: -1) to scope level 0\n"
           "> Create symbol table (scope level 1)\n"
           "> Insert `argv` (addr: 0) to scope level 1\n"
           "STR_LIT \"Hello \"\n"
           "STR_LIT \"World\"\n"
           "IDENT (name=endl, address=-1)\n"
           "cout string string string\n"
           "INT_LIT 0\n"
           "RETURN\n"
           "\n"
           "> Dump symbol table (scope level: 1)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         argv                string    0         1         -         \n"
           "\n"
           "> Dump symbol table (scope level: 0)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         main                function  -1        1         ([Ljava/lang/String;)I\n");
}

void result1_5() {
    printf("> Create symbol table (scope level 0)\n"
           "func: main\n"
           "> Insert `main` (addr: -1) to scope level 0\n"
           "> Create symbol table (scope level 1)\n"
           "> Insert `argv` (addr: 0) to scope level 1\n"
           "STR_LIT \"H\"\n"
           "STR_LIT \"e\"\n"
           "STR_LIT \"l\"\n"
           "STR_LIT \"l\"\n"
           "STR_LIT \"o\"\n"
           "STR_LIT \" \"\n"
           "STR_LIT \"w\"\n"
           "STR_LIT \"o\"\n"
           "STR_LIT \"r\"\n"
           "STR_LIT \"l\"\n"
           "STR_LIT \"d\"\n"
           "STR_LIT \"!\"\n"
           "IDENT (name=endl, address=-1)\n"
           "cout string string string string string string string string string string string string string\n"
           "INT_LIT 0\n"
           "RETURN\n"
           "\n"
           "> Dump symbol table (scope level: 1)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         argv                string    0         1         -         \n"
           "\n"
           "> Dump symbol table (scope level: 0)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         main                function  -1        1         ([Ljava/lang/String;)I\n");
}

void result1_6(){
    printf("> Create symbol table (scope level 0)\n"
           "func: main\n"
           "> Insert `main` (addr: -1) to scope level 0\n"
           "> Create symbol table (scope level 1)\n"
           "> Insert `argv` (addr: 0) to scope level 1\n"
           "STR_LIT \"Hell\"\n"
           "STR_LIT \"o\"\n"
           "STR_LIT \" w\"\n"
           "STR_LIT \"o\"\n"
           "STR_LIT \"rld\"\n"
           "IDENT (name=endl, address=-1)\n"
           "cout string string string string string string\n"
           "INT_LIT 0\n"
           "RETURN\n"
           "\n"
           "> Dump symbol table (scope level: 1)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         argv                string    0         1         -         \n"
           "\n"
           "> Dump symbol table (scope level: 0)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         main                function  -1        1         ([Ljava/lang/String;)I\n");
}

void result2_3(){
    printf("> Create symbol table (scope level 0)\n"
           "func: main\n"
           "> Insert `main` (addr: -1) to scope level 0\n"
           "> Create symbol table (scope level 1)\n"
           "> Insert `argv` (addr: 0) to scope level 1\n"
           "STR_LIT \"Hello World!\"\n"
           "cout string\n"
           "\n"
           "> Dump symbol table (scope level: 1)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         argv                string    0         11        -         \n"
           "\n"
           "> Dump symbol table (scope level: 0)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         main                function  -1        11        ([Ljava/lang/String;)I\n");
}

void result3_1(){
    printf("> Create symbol table (scope level 0)\n"
           "func: main\n"
           "> Insert `main` (addr: -1) to scope level 0\n"
           "> Create symbol table (scope level 1)\n"
           "> Insert `argv` (addr: 0) to scope level 1\n"
           "INT_LIT 3\n"
           "INT_LIT 4\n"
           "INT_LIT 5\n"
           "INT_LIT 8\n"
           "NEG\n"
           "ADD\n"
           "MUL\n"
           "SUB\n"
           "INT_LIT 10\n"
           "INT_LIT 7\n"
           "DIV\n"
           "SUB\n"
           "IDENT (name=endl, address=-1)\n"
           "cout int string\n"
           "INT_LIT 3\n"
           "INT_LIT 4\n"
           "INT_LIT 5\n"
           "INT_LIT 8\n"
           "NEG\n"
           "ADD\n"
           "MUL\n"
           "SUB\n"
           "INT_LIT 10\n"
           "INT_LIT 7\n"
           "DIV\n"
           "SUB\n"
           "INT_LIT 4\n"
           "NEG\n"
           "INT_LIT 3\n"
           "REM\n"
           "GTR\n"
           "BOOL_LIT TRUE\n"
           "NOT\n"
           "BOOL_LIT FALSE\n"
           "NOT\n"
           "NOT\n"
           "LAN\n"
           "LOR\n"
           "IDENT (name=endl, address=-1)\n"
           "cout bool string\n"
           "FLOAT_LIT 3.000000\n"
           "FLOAT_LIT 4.000000\n"
           "FLOAT_LIT 5.000000\n"
           "FLOAT_LIT 8.000000\n"
           "NEG\n"
           "ADD\n"
           "MUL\n"
           "SUB\n"
           "FLOAT_LIT 10.000000\n"
           "FLOAT_LIT 7.000000\n"
           "DIV\n"
           "SUB\n"
           "IDENT (name=endl, address=-1)\n"
           "cout float string\n"
           "FLOAT_LIT 3.000000\n"
           "FLOAT_LIT 4.000000\n"
           "FLOAT_LIT 5.000000\n"
           "FLOAT_LIT 8.000000\n"
           "NEG\n"
           "ADD\n"
           "MUL\n"
           "SUB\n"
           "FLOAT_LIT 10.000000\n"
           "FLOAT_LIT 7.000000\n"
           "DIV\n"
           "SUB\n"
           "FLOAT_LIT 4.000000\n"
           "NEG\n"
           "GTR\n"
           "BOOL_LIT TRUE\n"
           "NOT\n"
           "BOOL_LIT FALSE\n"
           "NOT\n"
           "NOT\n"
           "LAN\n"
           "LOR\n"
           "IDENT (name=endl, address=-1)\n"
           "cout bool string\n"
           "INT_LIT 0\n"
           "RETURN\n"
           "\n"
           "> Dump symbol table (scope level: 1)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         argv                string    0         1         -         \n"
           "\n"
           "> Dump symbol table (scope level: 0)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         main                function  -1        1         ([Ljava/lang/String;)I\n");
}

void result3_2() {
    printf("> Create symbol table (scope level 0)\n"
           "func: main\n"
           "> Insert `main` (addr: -1) to scope level 0\n"
           "> Create symbol table (scope level 1)\n"
           "> Insert `argv` (addr: 0) to scope level 1\n"
           "INT_LIT 3\n"
           "INT_LIT 4\n"
           "INT_LIT 5\n"
           "INT_LIT 8\n"
           "NEG\n"
           "ADD\n"
           "MUL\n"
           "SUB\n"
           "INT_LIT 10\n"
           "INT_LIT 7\n"
           "DIV\n"
           "SUB\n"
           "IDENT (name=endl, address=-1)\n"
           "cout int string\n"
           "INT_LIT 3\n"
           "INT_LIT 4\n"
           "INT_LIT 5\n"
           "INT_LIT 8\n"
           "NEG\n"
           "ADD\n"
           "MUL\n"
           "SUB\n"
           "INT_LIT 10\n"
           "INT_LIT 7\n"
           "DIV\n"
           "SUB\n"
           "INT_LIT 4\n"
           "NEG\n"
           "INT_LIT 3\n"
           "REM\n"
           "GTR\n"
           "BOOL_LIT TRUE\n"
           "NOT\n"
           "BOOL_LIT FALSE\n"
           "NOT\n"
           "NOT\n"
           "LAN\n"
           "LOR\n"
           "IDENT (name=endl, address=-1)\n"
           "cout bool string\n"
           "FLOAT_LIT 3.000000\n"
           "FLOAT_LIT 4.000000\n"
           "FLOAT_LIT 5.000000\n"
           "FLOAT_LIT 8.000000\n"
           "NEG\n"
           "ADD\n"
           "MUL\n"
           "SUB\n"
           "FLOAT_LIT 10.000000\n"
           "FLOAT_LIT 7.000000\n"
           "DIV\n"
           "SUB\n"
           "IDENT (name=endl, address=-1)\n"
           "cout float string\n"
           "FLOAT_LIT 3.000000\n"
           "FLOAT_LIT 4.000000\n"
           "FLOAT_LIT 5.000000\n"
           "FLOAT_LIT 8.000000\n"
           "NEG\n"
           "ADD\n"
           "MUL\n"
           "SUB\n"
           "FLOAT_LIT 10.000000\n"
           "FLOAT_LIT 7.000000\n"
           "DIV\n"
           "SUB\n"
           "FLOAT_LIT 4.000000\n"
           "NEG\n"
           "GTR\n"
           "BOOL_LIT TRUE\n"
           "NOT\n"
           "BOOL_LIT FALSE\n"
           "NOT\n"
           "NOT\n"
           "LAN\n"
           "LOR\n"
           "IDENT (name=endl, address=-1)\n"
           "cout bool string\n"
           "INT_LIT 1000000\n"
           "INT_LIT 9\n"
           "INT_LIT 1\n"
           "MUL\n"
           "ADD\n"
           "INT_LIT 1\n"
           "SUB\n"
           "INT_LIT 2024\n"
           "ADD\n"
           "INT_LIT 398\n"
           "NEG\n"
           "ADD\n"
           "INT_LIT 88\n"
           "INT_LIT 2\n"
           "REM\n"
           "INT_LIT 0\n"
           "NEQ\n"
           "ADD\n"
           "INT_LIT 8888889\n"
           "INT_LIT 2\n"
           "REM\n"
           "INT_LIT 0\n"
           "NEQ\n"
           "ADD\n"
           "IDENT (name=endl, address=-1)\n"
           "cout int string\n"
           "INT_LIT 0\n"
           "RETURN\n"
           "\n"
           "> Dump symbol table (scope level: 1)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         argv                string    0         1         -         \n"
           "\n"
           "> Dump symbol table (scope level: 0)\n"
           "Index     Name                Type      Addr      Lineno    Func_sig  \n"
           "0         main                function  -1        1         ([Ljava/lang/String;)I\n");
}
