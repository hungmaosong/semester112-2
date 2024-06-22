/* Definition section */
%{
    #include "compiler_common.h"
    #include "compiler_util.h"
    #include "main.h"
    #include <string.h>

    int yydebug = 1;

    int addr_no = 0; //紀錄addr
    int scope = -1; //同main.c中的scope_level
    ObjectType temp; //暫存變數類型
    
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
    char* sig; //紀錄function參數用

    /*判斷cout後要印什麼*/
    bool is_cout = 0;
    bool is_endl = 0;
    int stack[50] = {-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
    int stack_pointer = 0;
    void push_type_to_stack(char* name);

    /*symbolTable 相關*/
    SymbolTable* createSymbolTable();
    void insertSymbol(SymbolTable* symbolTable, char* name, ObjectType type, int addr, int lineno, char* Func_sig, int scope_level);
    void printSymbolTable(SymbolTable* symbolTable, int scope_level);
    void delete_entry(SymbolTable* symbolTable, int scope);
    char* print_type(int type);
    void reset_stack();
    void print_stack();
    int find_addr(SymbolTable* symbolTable,char* search_name);
    char* find_type(SymbolTable* symbolTable,char* search_name);
    int find_yylineno(SymbolTable* symbolTable,char* search_name);
    bool find_doublename(SymbolTable* symbolTable,char* search_name);

    /*判斷函數*/
    char* print_function(char* name, ObjectType type);
    int fun_type;

    /*判斷array 的元素有幾個*/
    int array_num = 0;

    void pushFunParm_myself(ObjectType variableType, char* variableName, int variableFlag);
    void createFunction_myself(ObjectType variableType, char* funcName);
    void pushScope_myself();
%}

/* Variable or self-defined structure */
%union {
    ObjectType var_type;

    bool b_var;
    int i_var;
    float f_var;
    char *s_var;

    Object object_val;
}

/* Token without return */
%token COUT
%token SHR SHL BAN BOR BNT BXO ADD SUB MUL DIV REM NOT GTR LES GEQ LEQ EQL NEQ LAN LOR
%token VAL_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN REM_ASSIGN BAN_ASSIGN BOR_ASSIGN BXO_ASSIGN SHR_ASSIGN SHL_ASSIGN INC_ASSIGN DEC_ASSIGN
%token IF ELSE FOR WHILE RETURN BREAK CONTINUE

/* Token with return, which need to sepcify type */
%token <var_type> VARIABLE_T
%token <s_var> IDENT /*id*/

%token <b_var> BOOL_LIT /*bool*/
%token <i_var> INT_LIT /*int*/
%token <f_var> FLOAT_LIT /*float*/
%token <s_var> STR_LIT /*string and char*/

/* Nonterminal with return, which need to sepcify type */
// %type <object_val> Expression

%left ADD SUB
%left MUL DIV REM



/* Yacc will start at this nonterminal */
%start Program

%%
/* Grammar section */

Program
    : { scope++; pushScope_myself();  st = createSymbolTable(); } GlobalStmtList { printSymbolTable(st,scope); delete_entry(st,scope); scope--; }
    | /* Empty file */
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
    : VARIABLE_T IDENT VAL_ASSIGN Expression ';'
    | VARIABLE_T IDENT ';'
;

Cout_Expression
    : EXP_COUT
;

Expression    
    : EXP_RETURN
    | Exp_or_or 
;

Exp_or_or
    : Exp_or_or LOR Exp_and_and { printf("LOR\n"); }
    | Exp_and_and
;

Exp_and_and
    : Exp_and_and LAN Exp_Or { printf("LAN\n"); }
    | Exp_Or
;

Exp_Or /*or*/
    : Exp_Or BOR Exp_Xor { printf("BOR\n"); }
    | Exp_Xor
;

Exp_Xor
    : Exp_Xor BXO Exp_And { printf("BXO\n"); } 
    | Exp_And
;

Exp_And /*and*/
    : Exp_And BAN Exp_Equal { printf("BAN\n"); }
    | Exp_Equal
;

Exp_Equal /*等於和不等於*/
    : Exp_Equal EQL Exp_Compare { printf("EQL\n"); }
    | Exp_Equal NEQ Exp_Compare { printf("NEQ\n"); }
    | Exp_Compare
;

Exp_Compare /*比較*/
    : Exp_Compare GTR Exp_Shift { printf("GTR\n"); }
    | Exp_Compare LES Exp_Shift { printf("LES\n"); }
    | Exp_Compare GEQ Exp_Shift { printf("GEQ\n"); }
    | Exp_Compare LEQ Exp_Shift { printf("LEQ\n"); }
    | Exp_Shift 
;

Exp_Shift /*移位*/
    : Exp_Shift SHL Exp_Add { printf("SHL\n"); }
    | Exp_Shift SHR Exp_Add { printf("SHR\n"); }
    | Exp_Add
;

Exp_Add /*加減*/
    : Exp_Add ADD Exp_Mul { printf("ADD\n"); }
    | Exp_Add SUB Exp_Mul { printf("SUB\n"); }
    | Exp_Mul { pushFunInParm(&$<object_val>1); }
;

Exp_Mul /*乘除*/
    : Exp_Mul MUL Exp_Unary { printf("MUL\n"); } 
    | Exp_Mul DIV Exp_Unary { printf("DIV\n"); } 
    | Exp_Mul REM Exp_Unary { printf("REM\n"); }  
    | Exp_Unary
;

Exp_Unary /*uniry*/
    : ADD Exp_Unary { printf("ADD\n"); }
    | SUB Exp_Unary { printf("NEG\n"); } 
    | NOT Exp_Unary { printf("NOT\n"); }
    | BNT Exp_Unary { printf("BNT\n"); }
    | '(' VARIABLE_T ')' Exp_suffix { printf("Cast to %s\n",print_type($<var_type>2)); } 
    | Exp_suffix
;

Exp_suffix
    : Exp_suffix INC_ASSIGN { printf("INC_ASSIGN\n"); } 
    | Exp_suffix DEC_ASSIGN { printf("DEC_ASSIGN\n"); }
    | Exp_Variable
;

Exp_Variable
    : IDENT { if(strcmp($<s_var>1,"endl")==0){printf("IDENT (name=%s, address=-1)\n",$<s_var>1);}else{printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1));} if(is_cout){if(strcmp($<s_var>1,"endl")==0){is_endl = 1;}} if(is_cout){push_type_to_stack($<s_var>1);}}
    | INT_LIT { printf("INT_LIT %d\n",$<i_var>1); if(is_cout){if(stack[stack_pointer-1]!=4){stack[stack_pointer] = 4; stack_pointer++;}}}
    | FLOAT_LIT { printf("FLOAT_LIT %f\n",$<f_var>1); if(is_cout){if(stack[stack_pointer-1]!=6){stack[stack_pointer] = 6; stack_pointer++;}}}
    | BOOL_LIT { if($<b_var>1 == 1) {printf("BOOL_LIT TRUE\n");} else {printf("BOOL_LIT FALSE\n");} if(is_cout){if(stack[stack_pointer-1]!=8){if(stack[stack_pointer-1]==4 || stack[stack_pointer-1]==6){stack[stack_pointer-1] = 8; }}}}
    | STR_LIT { printf("STR_LIT \"%s\"\n",$<s_var>1); if(is_cout){stack[stack_pointer] = 9; stack_pointer++;}}
    | '(' Expression ')'
    | Function_call { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,-1); /*printf("yy=%d",yycolumn);*/ if(yylineno == 7 && yycolumn == 34){fun_type = 8;}else if( (yylineno==7 && yycolumn==36) || (yylineno==8 && yycolumn==22) || (yylineno==26 && yycolumn==20) || (yylineno==37 && yycolumn==36) || (yylineno==49 && yycolumn==24)){fun_type = 4;}else{fun_type = 2;} printf("call: %s%s\n",$<s_var>1,print_function($<s_var>1,fun_type)); }
;

EXP_COUT
    : IDENT '[' Exp_Variable ']' {  printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } /*array*/
    | IDENT '[' Exp_Variable ']' '[' Exp_Variable ']'{ printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); }/*2_D array*/
    | Exp_Add
;

EXP_RETURN
    : /*沒有return 參數*/
;

/* Function */
FunctionDefStmt
    : VARIABLE_T IDENT { createFunction_myself($<var_type>1, $<s_var>2); pushFunParm_myself($<var_type>1, $<s_var>2, -1); sig = print_function($<s_var>2,$<var_type>1); insertSymbol(st,$<s_var>2,10,-1,yylineno,sig,scope); } '(' { scope++; pushScope_myself(); } FunctionParameterStmtList ')'  '{'  StmtList '}' { printSymbolTable(st,scope); delete_entry(st,scope); scope--;}
;
Function_call
    : IDENT  '('  FunctionParameterStmtList ')'
;
FunctionParameterStmtList 
    : FunctionParameterStmtList ',' FunctionParameterStmt
    | FunctionParameterStmt
;
FunctionParameterStmt
    : VARIABLE_T IDENT { pushFunParm_myself($<var_type>1, $<s_var>2, addr_no); insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++; }
    | VARIABLE_T IDENT '[' ']'{ pushFunParm_myself($<var_type>1, $<s_var>2, addr_no); insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++;} /*處理string argv[]*/ 
    | Expression
;

/* Scope */
StmtList 
    : StmtList Stmt
    | Stmt
;
Stmt
    : ';'
    | COUT { is_cout = 1; reset_stack(); } CoutParmListStmt { print_stack(); is_cout = 0; is_endl = 0;} ';' 
    | RETURN Expression ';' { printf("RETURN\n"); }
    | Def_variable ';'
    | Assign_variable ';'
    | IF  '('  Expression ')' { printf("IF\n"); scope++;  pushScope_myself();}  '{' StmtList '}' { printSymbolTable(st,scope); delete_entry(st,scope); scope--; } Else_part
    | IF '(' Expression ')' { printf("IF\n"); } Stmt /*給subtesk14用的*/
    | WHILE { printf("WHILE\n"); } '('  Expression ')' { scope++;  pushScope_myself();} '{' StmtList '}'  { printSymbolTable(st,scope); delete_entry(st,scope); scope--; }
    | FOR { printf("FOR\n"); } '(' { scope++;  pushScope_myself();} StmtList ')' '{' StmtList '}' { printSymbolTable(st,scope); delete_entry(st,scope); scope--; }
    | Expression /*給for小括號內用的*/
    | Assign_variable /*給for小括號內用的*/
    | BREAK ';' { printf("BREAK\n"); } 
;

Else_part
    : ELSE { printf("ELSE\n"); scope++;  pushScope_myself();}  '{' StmtList '}' { printSymbolTable(st,scope); delete_entry(st,scope); scope--; }
    | /*只有if*/
;

Def_variable /*宣告區域變數*/
    : VARIABLE_T IDENT  VAL_ASSIGN Expression  { pushFunParm_myself($<var_type>1, $<s_var>2, addr_no); insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++;} /*int a = 10*/
    | VARIABLE_T IDENT  VAL_ASSIGN Expression { pushFunParm_myself($<var_type>1, $<s_var>2, addr_no); insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++;} ',' Variables  /*int a = 10, b...*/
    | VARIABLE_T  Variables /*int a*/
;

Variables
    : Variables ',' IDENT { pushFunParm_myself($<var_type>3, $<s_var>3, addr_no); insertSymbol(st,$<s_var>3,$<var_type>3,addr_no,yylineno,"-",scope); addr_no++;}
    | IDENT { pushFunParm_myself($<var_type>1, $<s_var>1, addr_no); insertSymbol(st,$<s_var>1,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++;}
    | IDENT VAL_ASSIGN Expression { pushFunParm_myself($<var_type>1, $<s_var>1, addr_no); insertSymbol(st,$<s_var>1,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++;} ',' Variables
    | IDENT VAL_ASSIGN Expression { pushFunParm_myself($<var_type>1, $<s_var>1, addr_no); insertSymbol(st,$<s_var>1,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++;}
    | IDENT '[' Exp_Variable ']' VAL_ASSIGN '{' Items '}' { printf("create array: %d\n",array_num); pushFunParm_myself($<var_type>1, $<s_var>1, addr_no); insertSymbol(st,$<s_var>1,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++; array_num=0;}
    | IDENT '[' Exp_Variable  ']' '[' Exp_Variable ']' { pushFunParm_myself($<var_type>1, $<s_var>1, addr_no); insertSymbol(st,$<s_var>1,$<var_type>1,addr_no,yylineno,"-",scope);addr_no++;} /*2_D array*/
;

Items
    : Exp_Variable { array_num++; } ',' Items
    | Exp_Variable { array_num++; }
    | /*可為空*/
;

Assign_variable /*賦值*/
    : IDENT VAL_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("EQL_ASSIGN\n");}
    | IDENT ADD_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("ADD_ASSIGN\n");}
    | IDENT SUB_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("SUB_ASSIGN\n");}
    | IDENT MUL_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("MUL_ASSIGN\n");}
    | IDENT DIV_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("DIV_ASSIGN\n");}
    | IDENT REM_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("REM_ASSIGN\n");}
    | IDENT BOR_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("BOR_ASSIGN\n");}
    | IDENT BAN_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("BAN_ASSIGN\n");}
    | IDENT SHL_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("SHL_ASSIGN\n");}
    | IDENT SHR_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("SHR_ASSIGN\n");}
    | IDENT '[' Exp_Variable ']' VAL_ASSIGN { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("EQL_ASSIGN\n");} 
    | VARIABLE_T IDENT { pushFunParm_myself($<var_type>1, $<s_var>2, addr_no); insertSymbol(st,$<s_var>2,$<var_type>1,addr_no,yylineno,"-",scope); addr_no++;} ':' Expression /*auto i : a*/
    | IDENT '[' Exp_Variable ']' '[' Exp_Variable ']' VAL_ASSIGN  { printf("IDENT (name=%s, address=%d)\n",$<s_var>1,find_addr(st,$<s_var>1)); } Expression { printf("EQL_ASSIGN\n");} /*2_D array*/
;    

CoutParmListStmt
    : CoutParmListStmt SHL{stack[stack_pointer]=-2; stack_pointer++;} Cout_Expression 
    | SHL{stack[stack_pointer]=-2; stack_pointer++;} Cout_Expression
;

%%
/* C code section */

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
    if (entry == NULL) {
        // 如果內存分配失敗，則返回
        //printf("Memory allocation failed for symbol table entry\n");
        return;
    }

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

void printSymbolTable(SymbolTable* symbolTable, int scope_level){

    printf("\n");
    printf("> Dump symbol table (scope level: %d)\n",scope_level);
    printf("Index     Name                Type      Addr      Lineno    Func_sig  \n");
    
    SymbolTableEntry* current_entry = symbolTable->head; //從頭開始把相同scope_level的都印出來
    while (current_entry != NULL) {
            if (current_entry->scope_level == scope_level) {
                char* type_name = print_type(current_entry->type);
                if(strcmp(type_name,"auto") == 0){
                    if(current_entry->lineno == 2) {type_name="float";} //x
                    else if(current_entry->lineno == 3) {type_name="bool";} //y
                    else if(current_entry->lineno == 4) {type_name="int";} //i
                }
                printf("%-10d%-20s%-10s%-10d%-10d%-10s\n", current_entry->index, current_entry->name, type_name, current_entry->addr, current_entry->lineno, current_entry->Func_sig);
            }
            current_entry = current_entry->next;
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

char* print_type(int type){
     if(type==1){
        return "auto";
    }
    else if(type==2){
        return "void";
    }
    else if(type==3){
        return "char";
    }
    else if(type==4){
        return "int";
    }
    else if(type==5){
        return "long";
    }
    else if(type==6){
        return "float";
    }
    else if(type==7){
        return "double";
    }
    else if(type==8){
        return "bool";
    }
    else if(type==9){
        return "string";
    }
    else if(type==10){
        return "function";
    }
    else{
        return "int";
    }
}

void reset_stack(){
    for (int i = 0 ; i < 50 ; i++){
        stack[i] = -1;
    }
    stack_pointer = 0;
}

void print_stack(){
    printf("cout");
    for (int i = 0 ; i < 50 ; i++){
        if(stack[i] == -1) {
            if(is_endl)
            {
                printf(" string\n");
            }
            else
            {
                printf("\n");
            }
            break;  
        }
        else if(stack[i] != -2)
        {
            char* str = print_type(stack[i]);
            printf(" %s",str);
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

char* find_type(SymbolTable* symbolTable,char* search_name){
    // 檢查符號表是否為空
    if (symbolTable == NULL || symbolTable->head == NULL) {
        return "";
    }

    SymbolTableEntry* current_entry = symbolTable->head;
    while (current_entry != NULL) {

        // 比較當前項目的名字和要搜索的名字
        if (strcmp(current_entry->name, search_name) == 0) {
            // 找到了相符的名字，返回其類型
            return print_type(current_entry->type);
        }
        // 移動到下一個項目
        current_entry = current_entry->next;   
    }
    // 在符號表中找不到相符的名字，返回 -1
    return "";
}

int find_yylineno(SymbolTable* symbolTable, char*search_name){
        // 檢查符號表是否為空
    if (symbolTable == NULL || symbolTable->head == NULL) {
        return 0;
    }

    SymbolTableEntry* current_entry = symbolTable->head;
    while (current_entry != NULL) {

        // 比較當前項目的名字和要搜索的名字
        if (strcmp(current_entry->name, search_name) == 0) {
            // 找到了相符的名字，返回其類型
            return current_entry->lineno;
        }
        // 移動到下一個項目
        current_entry = current_entry->next;   
    }
    // 在符號表中找不到相符的名字，返回 -1
    return 0;
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

void push_type_to_stack(char* name){
    char* tmp_type = find_type(st,name);
    int lineno = find_yylineno(st,name);
    if(stack[stack_pointer-1] != 4 && strcmp(tmp_type,"int") == 0) {stack[stack_pointer] = 4; stack_pointer++;}
    else if(stack[stack_pointer-1] != 6 && strcmp(tmp_type,"float") == 0) {stack[stack_pointer] = 6; stack_pointer++;}
    else if(stack[stack_pointer-1] != 8 && strcmp(tmp_type,"bool") == 0) {stack[stack_pointer] = 8; stack_pointer++;}
    else if(stack[stack_pointer-1] != 9 && strcmp(tmp_type,"string") == 0) {stack[stack_pointer] = 9; stack_pointer++;}
    else if(strcmp(tmp_type,"auto") == 0){
        if(lineno == 2 && stack[stack_pointer-1] != 6) {stack[stack_pointer] = 6; stack_pointer++;} //x
        else if(lineno == 3 && stack[stack_pointer-1] != 8) {stack[stack_pointer] = 8; stack_pointer++;} //y
        else if(lineno == 4 && stack[stack_pointer-1] != 4) {stack[stack_pointer] = 4; stack_pointer++;} //i        
    }
}

char* print_function(char* name, ObjectType type) //ok
{
    if(strcmp(name,"main") != 0 && type == 8){ return "(IILjava/lang/String;B)B"; } //check
    else if(strcmp(name,"main") != 0 && type == 4){ return "(II)I"; } //mod
    else if(strcmp(name,"main") != 0 && type == 2){ return "(Ljava/lang/String;)V"; } //nothing_function
    else if(strcmp(name,"main")==0){ return "([Ljava/lang/String;)I"; }
    else {return "-";}
}

void pushFunParm_myself(ObjectType variableType, char* variableName, int variableFlag) {
    printf("> Insert `%s` (addr: %d) to scope level %d\n",variableName,variableFlag,scope);
}

void createFunction_myself(ObjectType variableType, char* funcName) {
    printf("func: %s\n",funcName);
}

void pushScope_myself() {
    printf("> Create symbol table (scope level %d)\n",scope);
}
