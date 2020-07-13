

%{
    const TIPO = require('./api_cast').TIPO;
    const TIPO_OPERACION = require('./api_cast').TIPO_OPERACION;
    const INSTRUCCIONES_CONST = require('./api_cast').TIPO_INSTRUCCION;
    const API = require('./api_cast').API;
    let erroresLexicos = [];
    let erroresSintacticos = [];
    let erroresLexicosYSintacticos = [];
    let tokens = [];

    exports.tks = function(){
        return tokens;
    }

    exports.errL = function(){
        return erroresLexicos;
    }

    exports.errS = function(){
        return erroresSintacticos;
    }

    exports.LimpiarV = function(){
        erroresLexicos = [];
        erroresSintacticos = [];
        erroresLexicosYSintacticos = [];
        tokens=[];
    }

    exports.errLS = function(){
        return erroresLexicosYSintacticos;
    } 
%}

%lex
%options flex case-sensitive
%options yylineno
%locations
%%
\s+                   /* salta espacios en blanco */
"//".*               {/* comentario simple*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] {/*comentario multilinea*/}
/*  cadenaS  */
//yytext = yytext.substr(1,yyleng-2);
[\"][^\\\"]*([\\][\\\"ntr][^\\\"]*)*[\"]           {yytext = yytext.substr(1,yyleng-2); return 'cadena'; }

\'[^\']*\'          {yytext = yytext.substr(1,yyleng-2); return 'cadenahtml'; }

/*  char    */
//yytext = yytext.substr(1,yyleng-2);
//yytext = yytext.substr(1,yyleng-2);
[\'][\\][\"\'nrt\\][\']       {yytext = yytext.substr(1,yyleng-2); return 'char_especial';}
[\'][^\'\\\"][\']             {yytext = yytext.substr(1,yyleng-2); return 'char';}



"int"       {return 'Rint';}
"double"    {return 'Rdouble';}
"boolean"   {return 'Rboolean';}
"char"      {return 'Rchar';}
"String"    {return 'Rstring';}
"string"    {return 'Rstring';}


"import"    {return 'Rimport';}
"void"      {return 'Rvoid';}
"class"     {return 'Rclass';}
"main"      {return 'Rmain';}
"if"        {return 'Rif';}
"else"      {return 'Relse';}
"switch"    {return 'Rswitch';}
"for"       {return 'Rfor';}
"while"     {return 'Rwhile';}
"do"        {return 'Rdo';}
"break"     {return 'Rbreak';}
"continue"  {return 'Rcontinue';}
"return"    {return 'Rreturn';}
"public"    {return 'Rpublic';}
"protected" {return 'Rprotected';}
"private"   {return 'Rprivate';}
"Console"    {return 'Rconsole';}
"out"       {return 'Rout';}
"WriteLine"   {return 'RwriteLine';}
"Write"     {return 'Rwrite';}
"true"      {return 'Rtrue';}
"false"     {return 'Rfalse';}
"case"      {return 'Rcase';}
"default"   {return 'def';}
":"			{return 'Sdospuntos';}
";"			{return 'Spuntoycoma';}
"{"			{return 'Sllavea';}
"}"			{return 'Sllavec';}
"("			{return 'Sparentesisa';}
")"			{return 'Sparentesisc';}
"."         {return 'Spunto';}
"\'"        {return 'Scomilla';}
","         {return 'Scoma';}
"\""        {return 'Scomilladoble';}

"++"        {return 'Oincremento';}
"--"        {return 'Odecremento';}
"+"         {return 'Omas';}
"-"         {return 'Omenos';}
"*"         {return 'Opor';}
"/"         {return 'Obarra';}
"^"         {return 'Oexponente';}
"%"         {return 'Oporciento';}
"<="	    {return 'Rmenoroigual';}
">="		{return 'Rmayoroigual';}
"=="		{return 'Rdobleigual';}
"="         {return 'Rigual';}
"!="		{return 'Rdiferente';}
"<"			{return 'Rmenor';}
">"			{return 'Rmayor';}

"!"			{return 'RNegacion';}
"&&"		{return 'Ry';}
"||"		{return 'Ro';}

[0-9]+("."[0-9]+)\b    {return 'double';}
[0-9]+\b                {return 'entero';}
([a-zA-Z_])[a-zA-Z0-9_]* {return 'id';}
<<EOF>>               {return 'EOF';}



//error {console.error("Error Sintactico: " + yytext +  ' Fila: ' + this._$.first_line + ' Columna: ' + this._$.first_column);}
.                   {erroresLexicos.push({Tipo_Error: 'Error_Lexico',Error : yytext , Fila  : yylloc.first_line , Columna  :  yylloc.first_column });erroresLexicosYSintacticos.push({ Tipo_Error  : ' Error_Lexico ', Error  : yytext , Fila  : yylloc.first_line , Columna  :  yylloc.first_column });}
//console.error('error lexico: '  + yytext +  ' Fila: ' + yylloc.first_line + ' en la columna: ' + yylloc.first_column)
/lex
//PRECEDENCIA DE OPERADORES
//prescedencia operadores logicos
%left 'Ry' 'Ro'
//prescedencia operadores relcionales
%left 'Rdobleigual' 'Rdiferente' 'Rmayoroigual' 'Rmayor' 'Rmenoroigual' 'Rmenor'
//prescedencia operadores aritmeticos
%left 'Omas' 'Omenos'
%left 'Opor' 'Obarra' 
%left 'Oexponente' 'Oporciento'
%left UMINUS PRUEBA
//GRAMATICA
%start INICIO
%%
INICIO
    : CUERPO EOF
        { return $1;}//console.log(JSON.stringify($1, null, 2));
;

CUERPO
    : CUERPOP
    | { $$ = [{text:'undefined',icon:'./img/hoja.png'}]; }
    ;

CUERPOP 
    : SINTAXIS {if($1!=''){$$ = [$1];}else{$$ = [];}}
    | CUERPOP SINTAXIS {if($2!=''){$1.push($2)}; $$ = $1;}
    ;

SINTAXIS
    : IMPORT
    | CLASS
    | error {$$ ='';erroresSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });erroresLexicosYSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });}
;

IMPORT
    : Rimport LISTIMPORT Spuntoycoma {$$ = API.n_Import($2); tokens.push({Tipo: 'Reservada import',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column});}
;

LISTIMPORT
    : LISTIMPORT SPunto DEFINIR { $1.push($3); $$ =$1; tokens.push({Tipo: 'Punto',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | DEFINIR                         {$$ = [$1];}
;

DEFINIR
    : id {$$ = API.n_Ident($1); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});} 
;


CLASS 
    : Rclass id Sllavea  PN Sllavec {$$ = API.n_Clase($2,$4); tokens.push({Tipo: 'Reservada class',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Identificador',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Llave a',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Llave c',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column});} //{$$ = $1+ $2 + $3 + $4 + $5;}{console.log(JSON.stringify($1, null, 2));
;

PN
    :LISTACLASS
    | { $$ = [{text:'undefined',icon:'./img/hoja.png'}]; }
;

LISTACLASS
    : LISTACLASS CUERPOCLASS {if($2!=''){$1.push($2)}; $$ = $1;}
    | CUERPOCLASS             {if($1==''){$$ = [];}else{$$ = [$1];}}
;

CUERPOCLASS
    : TIPO id Sparentesisa PAR Sparentesisc Sllavea INSTRUCCIONES Sllavec {$$ =API.n_Metodo_Funcion($1,$2,$4,$7); tokens.push({Tipo: 'Identificador',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Llave a',Lexema:$6, Fila:this._$.first_line, Columna: this._$.first_column});  tokens.push({Tipo: 'Llave c',Lexema:$8, Fila:this._$.first_line, Columna: this._$.first_column});}//$1 + $2 + $3 +$4 + $5 + $6 + $7 + $8
    | VAR {$$=1;}
    | Rvoid VOID {$$ =$2; tokens.push({Tipo: 'Reservada void',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | METODOCLASE {$$=1;}
    |  error {$$ ='';erroresSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });erroresLexicosYSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });} 
    
;

VOID
    : Rmain Sparentesisa Sparentesisc Sllavea INSTRUCCIONES Sllavec {$$ = API.n_Metodo_Principal($5); tokens.push({Tipo: 'Reservada main',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Llave a',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column});  tokens.push({Tipo: 'Llave c',Lexema:$6, Fila:this._$.first_line, Columna: this._$.first_column});}
    | id Sparentesisa PAR Sparentesisc Sllavea INSTRUCCIONES Sllavec {$$ = API.n_Metodo($1,$3,$6); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Llave a',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column});  tokens.push({Tipo: 'Llave c',Lexema:$7, Fila:this._$.first_line, Columna: this._$.first_column});}
;


VAR
    : TIPO LISTAVAR Spuntoycoma          {$$ = API.n_Declaracion($1 , $2); tokens.push({Tipo: 'Punto y coma',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column});}
;

LISTAVAR
    : LISTAVAR Scoma CUERPOVAR                 {$1.push($3); $$ = $1; tokens.push({Tipo: 'Coma',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | CUERPOVAR                                            {$$ = [$1];}
;

CUERPOVAR
    //aqui tengo que agregar la asignacion de VARs
    :id Rigual EXPRESION                              {$$ = API.n_Variable($1,$3); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Igual',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});} 
    |id                                                  {$$ = API.n_Variable($1,'undefined'); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
;

TIPO
    : Rint             {$$ = TIPO.INT; tokens.push({Tipo: 'Reservada int',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rstring          {$$ = TIPO.STRING; tokens.push({Tipo: 'Reservada string',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rboolean         {$$ = TIPO.BOOLEAN; tokens.push({Tipo: 'Reservada boolean',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rchar            {$$ = TIPO.CHAR; tokens.push({Tipo: 'Reservada char',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rdouble          {$$ = TIPO.DOUBLE; tokens.push({Tipo: 'Reservada double',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
;

ACCESO 
    : Rprotected {$$ = $1; tokens.push({Tipo: 'Reservada protected',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rpublic {$$ = $1; tokens.push({Tipo: 'Reservada public',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rprivate {$$ = $1; tokens.push({Tipo: 'Reservada private',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | { $$ = 'undefined'; }
;



EXPRESION 
    : EXPRESION Ry EXPRESION                                                     { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.AND); tokens.push({Tipo: 'Comparador y',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}//$1 + $2 + $3
    | EXPRESION Ro EXPRESION                                                             { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.OR); tokens.push({Tipo: 'Comparador o',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Rdobleigual EXPRESION                                                     { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.IGUAL_IGUAL); tokens.push({Tipo: 'Doble igual',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Rmayoroigual EXPRESION                                                  { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MAYOR_IGUAL_QUE); tokens.push({Tipo: 'Mayor o igual',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Rmayor EXPRESION                                                       { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MAYOR_QUE); tokens.push({Tipo: 'Mayor',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Rmenoroigual EXPRESION                                                  { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MENOR_IGUAL_QUE); tokens.push({Tipo: 'Menor o igual',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Rmenor EXPRESION                                                       { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MENOR_QUE); tokens.push({Tipo: 'menor',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Rdiferente EXPRESION                                                       { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.DISTINTO); tokens.push({Tipo: 'distinto',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Omas EXPRESION                                                             { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.SUMA); tokens.push({Tipo: 'Mas',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Omenos EXPRESION                                                           { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.RESTA); tokens.push({Tipo: 'menos',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Opor EXPRESION                                                  { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MULTIPLICACION); tokens.push({Tipo: 'por',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Obarra EXPRESION                                                        { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.DIVISION); tokens.push({Tipo: 'division',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Oexponente EXPRESION                                                        { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.POTENCIA); tokens.push({Tipo: 'potencia',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION Oporciento EXPRESION                                                          { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MODULO); tokens.push({Tipo: 'por ciento',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | CONTENIDOEXPRESION Odecremento %prec PRUEBA                                             { $$ = API.operacion_Unaria($1,TIPO_OPERACION.MODULO); tokens.push({Tipo: 'incremento',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | CONTENIDOEXPRESION Oincremento %prec PRUEBA                                             { $$ = API.operacion_Unaria($1,TIPO_OPERACION.DECREMENTO); tokens.push({Tipo: 'decremento',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Omenos  EXPRESION     %prec UMINUS                                             { $$ = API.operacion_Unaria($2,TIPO_OPERACION.NEGATIVO); tokens.push({Tipo: 'menor',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | RNegacion   EXPRESION     %prec UMINUS                                             { $$ = API.operacion_Unaria($2,TIPO_OPERACION.NOT); tokens.push({Tipo: 'distinto',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | CONTENIDOEXPRESION                                                                        { $$ = $1; }  
;

 CONTENIDOEXPRESION
    : entero                                                                                     {$$ = API.n_Dato($1,TIPO.INT); tokens.push({Tipo: 'Entero',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | double                                                                                    {$$ = API.n_Dato($1,TIPO.DOUBLE); tokens.push({Tipo: 'Double',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); }
    | id Sparentesisa Sparentesisc                                          {$$ = API.n_Funcion($1,'undefined'); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column});}
    | id Sparentesisa OPCIONAL Sparentesisc                                 {$$ = API.n_Funcion($1,$3); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rtrue                                                                                     {$$ = API.n_Dato($1,TIPO.BOOLEAN); tokens.push({Tipo: 'reservada true',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rfalse                                                                                    {$$ = API.n_Dato($1,TIPO.BOOLEAN); tokens.push({Tipo: 'reservada false',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Sparentesisa EXPRESION Sparentesisc                                            {$$ = $2;  tokens.push({Tipo: 'Parentesis a',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column});}
    | id                                                                              {$$ = API.n_Dato($1,TIPO.IDENTIFICADOR); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | cadena                                                                                     {$$ = API.n_Dato($1,TIPO.STRING); tokens.push({Tipo: 'String',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | cadenahtml                                                                                 {$$ = API.n_Dato($1,TIPO.STRING_e); tokens.push({Tipo: 'html',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | char                                                                                       {$$ = API.n_Dato($1,TIPO.CHAR); tokens.push({Tipo: 'Char',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | char_especial                                                                              {$$ = API.n_Dato($1,TIPO.CHAR); tokens.push({Tipo: 'Char',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
;

OPCIONAL 
    : EXPRESION                                                                                {$$ = [$1];}
    | OPCIONAL Scoma EXPRESION                                                                {$1.push($2); $$ = $1; tokens.push({Tipo: 'Punto y coma',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}  
;


FUNCION
    :EXPRESION                    {$$ = $1;}
    |                               { $$ = [{text:'undefined',icon:'./img/hoja.png'}]; }
;


PAR
    : DEFPAR LISTAPAR {
        var obj_if = []; 
        if(Array.isArray($2) && !Array.isArray($1)){
            $2.unshift($1); 
            $$ = $2;
        }else if(Array.isArray($1) && !Array.isArray($2)){
            $1.push($2); 
            $$ = $1;
        } else{
                obj_if.push($2);
                obj_if.unshift($1);
                $$ = obj_if;
        } 
    }// $$ = $1 + $2 +$3;
    | DEFPAR {$$ = [$1];}
    | { $$ = [{text:'undefined',icon:'./img/hoja.png'}]; }
;
LISTAPAR
    : LISTAPAR Scoma DEFPAR {$1.push($3); $$ = $1; tokens.push({Tipo: 'Coma',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Scoma DEFPAR {$$ =[$2]; tokens.push({Tipo: 'Coma',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
;

DEFPAR
    : TIPO id {$$ = API.n_ParametroM($1,$2); tokens.push({Tipo: 'Identificador',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
;


METODO
    : id Rigual EXPRESION Spuntoycoma                                             {$$ = API.n_Asignacion($1,$3); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Igual',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column});}
    | id Sparentesisa FUNCIONPAR Sparentesisc Spuntoycoma             {$$ = API.n_Funcion($1,$3); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column});}
;
/*
REDUCCION
    :  Rigual EXPRESION Spuntoycoma {$$ = $1 +$2+$3; tokens.push({Tipo: 'Igual',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Sparentesisa FUNCIONPAR Sparentesisc Spuntoycoma {$$ = $1 + $2+$3+ $4; tokens.push({Tipo: 'Parentesis a',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column});}
;
*/
FUNCIONPAR
    : FUNCIONPAR Scoma EXPRESION { $1.push($3);  $$ = $1; tokens.push({Tipo: 'Coma',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION                        {$$ = [$1];}
    | { $$ = [{text:'undefined',icon:'./img/hoja.png'}]; }
;


METODOCLASE
    : id Sparentesisa FUNCIONPAR Sparentesisc Spuntoycoma {$$ = API.n_Funcion($1,API.n_Parametro($3)); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column});}// $1 + $2 + $3 + $4 + $5
;


INSTRUCCIONES
    : LISTAINST                     {$$ = $1;}
    | { $$ = [{text:'undefined',icon:'./img/hoja.png'}]; }
;

LISTAINST
    : LISTAINST LISTAINSTTRUCCIONES {if($2!=''){$1.push($2)}; $$ = $1;}
    | LISTAINSTTRUCCIONES           {
        if(Array.isArray($1)){
            if($1!=''){
                $$ = $1;
            }else{
                $$ = [];
            }
            }else{
                if($1!=''){
                  $$ = [$1];
                }else{
                    $$=[];
                }
            }
        }
;

LISTAINSTTRUCCIONES
    : METODO //ya esta
    | VAR  //ya esta
    | IMPRIMIR  //ya esta
    | IFANI   //ya esta
    | WHILE    //ya esta
    | DOWHILE //ya esta
    | FOR  //ya esta
    | SWITCH // ya esta
    | TRANS //ya esta
    |  error {$$ =''; erroresSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });erroresLexicosYSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });}
;

IMPRIMIR 
    : Rconsole Spunto TIPOIMPRIMIR Sparentesisa EXPRESION Sparentesisc Spuntoycoma {$$ = API.n_Impresion($3,$5); tokens.push({Tipo: 'Reservada Console',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$6, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$7, Fila:this._$.first_line, Columna: this._$.first_column});}/*$1 + $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9*/
;

TIPOIMPRIMIR
    : Rwrite       {$$ = INSTRUCCIONES_CONST.IMPRIMIR; tokens.push({Tipo: 'reservada write',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}
    | RwriteLine    {$$ = INSTRUCCIONES_CONST.IMPRIMIR_LN; tokens.push({Tipo: 'reservada writeline',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column});}//IMPRIMIR
;

TRANS
    : Rbreak Spuntoycoma { $$ = API.n_Break(); tokens.push({Tipo: 'reservada break',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rcontinue Spuntoycoma { $$ = API.n_Continue(); tokens.push({Tipo: 'reservada continue',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | Rreturn FUNCION Spuntoycoma { $$ = API.n_Return($2); tokens.push({Tipo: 'reservada return',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column});}
;

IFANI
//: IF IFCONT  { $1.push($2); $$ = $1; }//$1+ $2 +$3
//$2.unshift($1);$$ = $2;    
    : IF IFCONT  { 
        var obj_if = []; 
        if($2 !=null){
            if(Array.isArray($1) && !Array.isArray($2)){
                $1.push($2); 
                $$ = $1;
            }else if(Array.isArray($2) && !Array.isArray($1)){
                $2.unshift($1); 
                $$ = $2;
            } else{
                obj_if.push($2);
                obj_if.unshift($1);
                $$ = obj_if;
            }
        }else{
            $$ = $1;
        }
    }
;

IF
    : Rif Sparentesisa EXPRESION Sparentesisc Sllavea INSTRUCCIONES Sllavec {$$ = API.n_If($3,$6); tokens.push({Tipo: 'Reservada if',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave a',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave c',Lexema:$7, Fila:this._$.first_line, Columna: this._$.first_column});}
;

IFCONT
    : ELSIANI ELSE { 
        var obj_if = []; 
        if(Array.isArray($1) && !Array.isArray($2)){
            $1.push($2); 
            $$ = $1;
        }else if(Array.isArray($2) && !Array.isArray($1)){
            $2.unshift($1); 
            $$ = $2;
        } else{
            obj_if.push($2);
            obj_if.unshift($1);
            $$ = obj_if;
        }
    }
    | ELSIANI           {  
        var obj_if = []; 
        if(Array.isArray($1)){ 
            $$ =$1;
        } else{ 
            obj_if.push($1);
            $$ = obj_if;
        }
    }
    | ELSE              { 
        var obj_if = []; 
        if(Array.isArray($1)){ 
            $$ =$1;
        } else{ 
            obj_if.push($1);
            $$ = obj_if;
        } 
    }
    |
;

ELSIANI
    : ELSIANI ELSEIF      { $1.push($2); $$ = $1;  }
    | ELSEIF                   { $$ = [$1];  }
;

ELSE
    : Relse Sllavea INSTRUCCIONES Sllavec { $$ = API.n_Else($3);  tokens.push({Tipo: 'Reservada else',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Llave a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Llave c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column});}
;

ELSEIF
    : Relse Rif Sparentesisa EXPRESION Sparentesisc Sllavea INSTRUCCIONES Sllavec { $$ = API.n_ElseIf($4,$7); tokens.push({Tipo: 'reservda else',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'reservada if',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis a',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis c',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave a',Lexema:$6, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave c',Lexema:$8, Fila:this._$.first_line, Columna: this._$.first_column});}
;



SWITCH
    : Rswitch Sparentesisa EXPRESION Sparentesisc Sllavea LISTA_CASE Sllavec {$$ = API.n_Switch($3,$6); tokens.push({Tipo: 'reservda switch',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave a',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave c',Lexema:$7, Fila:this._$.first_line, Columna: this._$.first_column});}
;

LISTA_CASE
    : CASE RSWITCH{ 
        var obj_if = []; 
        if(Array.isArray($1) && !Array.isArray($2)){
            $1.push($2); 
            $$ = $1;
        }else if(Array.isArray($2) && !Array.isArray($1)){
            $2.unshift($1); 
            $$ = $2;
        } else{
            obj_if.push($2);
            obj_if.unshift($1);
            $$ = obj_if;
        }
    }
    | CASE{  
        var obj_if = []; 
        if(Array.isArray($1)){ 
            $$ =$1;
        } else{ 
            obj_if.push($1);
            $$ = obj_if;
        }
    }
    | RSWITCH{ 
        var obj_if = []; 
        if(Array.isArray($1)){ 
            $$ =$1;
        } else{ 
            obj_if.push($1);
            $$ = obj_if;
        } 
    }
    |{ $$ = [{text:'undefined',icon:'./img/hoja.png'}]; }
;


CASE
    : CASE DEFAULT { $1.push($2); $$ = $1;  }
    | DEFAULT         { $$ = [$1];  }
;

DEFAULT
    : Rcase EXPRESION Sdospuntos INSTRUCCIONES {$$ = API.n_Case($2,$4); tokens.push({Tipo: 'reservada case',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Dos puntos',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column});}
;

RSWITCH
    : def Sdospuntos INSTRUCCIONES     {$$ = API.n_Default($3); tokens.push({Tipo: 'reservada default',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'dos puntos',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
;



  WHILE
    : Rwhile Sparentesisa EXPRESION Sparentesisc Sllavea INSTRUCCIONES Sllavec   {$$ = API.n_While($3,$6); tokens.push({Tipo: 'Reservada while',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave a',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave c',Lexema:$7, Fila:this._$.first_line, Columna: this._$.first_column});} /*$1+ $2 +$3 + $4 + $5 + $6 + $7;*/
;


  DOWHILE
    : Rdo Sllavea INSTRUCCIONES Sllavec Rwhile Sparentesisa EXPRESION Sparentesisc Spuntoycoma { $$ = API.n_DoWhile($3,$7); tokens.push({Tipo: 'reservda do',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave c',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'reservada while',Lexema:$5, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis a',Lexema:$6, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis c',Lexema:$8, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Punto y coma',Lexema:$9, Fila:this._$.first_line, Columna: this._$.first_column});}
;


FOR
    : Rfor Sparentesisa FORCONTE Spuntoycoma EXPRESION Spuntoycoma FORFIN Sparentesisc Sllavea INSTRUCCIONES Sllavec { $$ = API.n_For( $3 , $5 , $7 , $10);tokens.push({Tipo: 'reservada for',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis a',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'punto y coma',Lexema:$4, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'punto y coma',Lexema:$6, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'parentesis c',Lexema:$8, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave a',Lexema:$9, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'llave c',Lexema:$11, Fila:this._$.first_line, Columna: this._$.first_column});} 
;
                                                                                                                                            //inicio, condicion, fin, instrucciones
FORCONTE
    : TIPO id Rigual EXPRESION        {$$ = API.n_Declaracion($1 , API.n_Variable($2,$4)); tokens.push({Tipo: 'Identificador',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Igual',Lexema:$3, Fila:this._$.first_line, Columna: this._$.first_column});}
    | id Rigual EXPRESION                  {$$ = API.n_Asignacion($1,$3); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Igual',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
;

FORFIN
    : id Rigual EXPRESION                  {$$ = API.n_Asignacion($1,$3); tokens.push({Tipo: 'Identificador',Lexema:$1, Fila:this._$.first_line, Columna: this._$.first_column}); tokens.push({Tipo: 'Igual',Lexema:$2, Fila:this._$.first_line, Columna: this._$.first_column});}
    | EXPRESION                                                                      
    ;