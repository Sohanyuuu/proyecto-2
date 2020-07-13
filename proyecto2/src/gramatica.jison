%{
    const TIPO = require('./apiJson').TIPO;
    const TIPO_OPERACION = require('./apiJson').TIPO_OPERACION;
    const INSTRUCCIONES_CONST = require('./apiJson').TIPO_INSTRUCCION;
    const API = require('./apiJson').API;
    let erroresLexicos = [];
    let erroresSintacticos = [];
    let erroresLexicosYSintacticos = [];

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
    }

    exports.errLS = function(){
        return erroresLexicosYSintacticos;
    } 
%}

/* Analizador Lexico */

%lex
%options case-sensitive
%options yylineno
%locations
%%

\s+                   /* salta espacios en blanco */
"//".*               {/* comentario simple*/}
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] {/*comentario multilinea*/}
/*  CADENAS  */
//yytext = yytext.substr(1,yyleng-2);
[\"][^\\\"]*([\\][\\\"ntr][^\\\"]*)*[\"]           {yytext = yytext.substr(1,yyleng-2); return 'cadena'; }

//yytext = yytext.substr(1,yyleng-2);
//yytext = yytext.substr(1,yyleng-2);
[\'][\\][\"\'nrt\\][\']       {yytext = yytext.substr(1,yyleng-2); return 'char_especial';}
[\'][^\'\\\"][\']             {yytext = yytext.substr(1,yyleng-2); return 'char';}

// Palabras Reservadas
"import"                { return 'Rimport'; }
"class"                 { return 'Rclass'; }
"public"                { return 'Rpublic'; }
"protected"             { return 'Rprotected';}
"private"             { return 'Rprivate';}

"void"                  { return 'Rvoid'; }
"main"                  { return 'Rmain'; }

"int"                   { return 'Rint'; }
"double"                { return 'Rdouble'; }
"bool"                  { return 'Rbool'; }
"char"                  { return 'Rchar'; }
"String"                { return 'Rstring'; }
"true"                  { return 'Rtrue'; }
"false"                 { return 'Rfalse'; }

"Console"                { return 'Rconsole'; }
"Write"                   { return 'Rwrite'; }
"Writeline"              { return 'Rwriteline'; }

"break"                 { return 'Rbreak'; }
"continue"              { return 'Rcontinue'; }
"return"                { return 'Rreturn'; }

"if"                    { return 'Rif'; }
"else"                  { return 'Relse'; }

"switch"                { return 'Rswitch'; }
"case"                  { return 'Rcase'; }
"default"               { return 'Rdefault'; }

"for"                   { return 'Rfor'; }
"while"                 { return 'Rwhile'; }
"do"                    { return 'Rdo'; }

"++"                    { return 'Sincremento'; }
"+"                     { return 'Smas'; }
"--"                    { return 'Sdecremento'; }
"-"                     { return 'Smenos'; } 
"*"                     { return 'Spor'; } 
"/"                     { return 'Sbarra'; } 
"^"                     { return 'Sexponente'; } 
"%"                     { return 'Sporciento'; }

"'"                     { return 'Scomillas'; }
"\""                    { return 'Scomillad'; }

"\\"                    { return 'Sbarrai'; }
"&&"                    { return 'Sy'; }
"||"                    { return 'So'; }
"!="                    { return 'Sdiferente'; }
"!"                     { return 'Sintc'; }
"=="                    { return 'Sdobleigual'; }
"="                     { return 'Sigual'; }
">="                    { return 'Smayoroigual'; }
">"                     { return 'Smayor'; }
"<="                    { return 'Smenoroigual'; }
"<"                     { return 'Smenor'; }

","                     { return 'Scoma'; }
"."                     { return 'Spunto'; }
";"                     { return 'Spuntoycoma'; }
":"                     { return 'Sdospuntos'; }

"("                     { return 'Sparentesisa'; }
")"                     { return 'Sparentesisc'; }
"{"                     { return 'Sllavea'; }
"}"                     { return 'Sllavec'; }

([a-zA-Z_])[a-zA-Z0-9_]* {return 'Vid';}    // identificadores

[0-9]+("."[0-9]+)\b  	                    { return 'Vdouble'; }     // decimal
[0-9]+\b				                    { return 'Vint'; }     // numero

<<EOF>>				    return 'EOF';       // fin del archivo

/*  ERRORES LEXICOS */
//error {console.error("Error Sintactico: " + yytext +  ' Fila: ' + this._$.first_line + ' Columna: ' + this._$.first_column);}
.                   {erroresLexicos.push({Tipo_Error: 'Error_Lexico',Error : yytext , Fila  : yylloc.first_line , Columna  :  yylloc.first_column });erroresLexicosYSintacticos.push({ Tipo_Error  : ' Error_Lexico ', Error  : yytext , Fila  : yylloc.first_line , Columna  :  yylloc.first_column });}
//console.error('error lexico: '  + yytext +  ' Fila: ' + yylloc.first_line + ' en la columna: ' + yylloc.first_column)
/lex
//PRECEDENCIA DE OPERADORES
//prescedencia operadores logicos
%left 'Sy' 'So'
//prescedencia operadores relcionales
%left 'Sdobleigual' 'Sdiferente' 'Smayoroigual' 'Smayor' 'Smenoroigual' 'Smenor'
//prescedencia operadores aritmeticos
%left 'Smas' 'Smenos'
%left 'Spor' 'Sbarra' 
%left 'Sexponente' 'Sporciento'
%left UMINUS PRUEBA

//GRAMATICA
%start INICIO
%%

INICIO
    : CONTENIDO EOF
        {console.log(JSON.stringify($1, null, 2)); return $1;}
; 

CONTENIDO
    : CONTENIDO CLASES {$1.push($2); $$ = $1;}
    | CLASES {$$ = [$1];}
    |  error {$$ ='';erroresSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });erroresLexicosYSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });}
;
CLASES 
    : Rclass Vid Sllavea  LISTA_CLASES Sllavec {ArchivoJson.push({Tipo:'Clase', Nombre: $2 , Contenido: metodosT });metodosT = [];$$ = API.n_Clase($2,$4); } //{$$ = $1+ $2 + $3 + $4 + $5;}{console.log(JSON.stringify($1, null, 2));
;

LISTA_CLASES
    : LISTA_CLASES CONTENIDO_CLASE {$1.push($2); $$ = $1;}
    | CONTENIDO_CLASE              {$$ = [$1];}
;

CONTENIDO_CLASE
    : TIPO_DATO Vid Sparentesisa PARAMETROS Sparentesisc Sllavea INSTRUCCIONES Sllavec {metodosT.push({Tipo : 'Funcion',Tipo_Retorno : $1,Nombre : $2, Parametros : parametroT,Contenido : varA});parametroT = [];varA=[];$$ =API.n_Metodo_Funcion($1,$2,$4,$7);}//$1 + $2 + $3 +$4 + $5 + $6 + $7 + $8
    | VARIABLE {varA = [];$$=$1;}
    | Rvoid METODO_VOID {$$ =$2;}
    | LLAMAR_METODOF_CLASE 
    |  error {$$ ='';erroresSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });erroresLexicosYSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });} 
    
;

METODO_VOID
    : Rmain Sparentesisa Sparentesisc Sllavea INSTRUCCIONES Sllavec {metodosT.push({Tipo : 'Main', Contenido : varA}); varA = [];$$ = API.n_Metodo_Principal($5);}
    | Vid Sparentesisa PARAMETROS Sparentesisc Sllavea INSTRUCCIONES Sllavec {metodosT.push({Tipo : 'Metodo',Nombre : $1, Parametros : parametroT,Contenido : varA});parametroT = []; varA = [];$$ = API.n_Metodo($1,$3,$6);}
;

VARIABLE
    : TIPO_DATO LISTADO_ID_VARIABLE Spuntoycoma                      {
        $2.forEach(element =>{
            varA.push({Tipo : $1, Nombre : element.Identificador});
        });
        $$ = API.n_Declaracion($1 , $2);}
;

LISTADO_ID_VARIABLE
    : LISTADO_ID_VARIABLE Scoma CONTENIDO_VARIABLE                 {$1.push($3); $$ = $1}
    | CONTENIDO_VARIABLE                                            {$$ = [$1]}
;

CONTENIDO_VARIABLE
    :Vid Sigual EXPRESION_G                              {$$ = API.n_Variable($1,$3)}
    |Vid                                                 {$$ = API.n_Variable($1,'undefined')}
;

TIPO_DATO
    : RInt             {$$ = TIPO.INT; }
    | Rstring          {$$ = TIPO.STRING; }
    | Rbool        {$$ = TIPO.BOOLEAN; }
    | Rchar            {$$ = TIPO.CHAR; }
    | Rdouble          {$$ = TIPO.DOUBLE; }
    | Rstring         {$$ = TIPO.string;}
;

MODIFICADORES_ACCESO 
    : Rprotected {$$ = $1;}
    | Rpublic {$$ = $1;}
    | Rprivate {$$ = $1;}
    | { $$ = 'undefined'; }
;

EXPRESION_G 
    : EXPRESION_G Sy EXPRESION_G                                                     { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.AND); }//$1 + $2 + $3
    | EXPRESION_G So EXPRESION_G                                                             { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.OR); }
    | EXPRESION_G Sdobleigual EXPRESION_G                                                     { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.IGUAL_IGUAL); }
    | EXPRESION_G Smayoroigual EXPRESION_G                                                  { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MAYOR_IGUAL_QUE); }
    | EXPRESION_G Smayor EXPRESION_G                                                       { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MAYOR_QUE); }
    | EXPRESION_G Smenoroigual EXPRESION_G                                                  { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MENOR_IGUAL_QUE); }
    | EXPRESION_G Smenor EXPRESION_G                                                       { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MENOR_QUE); }
    | EXPRESION_G Sdiferente EXPRESION_G                                                       { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.DISTINTO); }
    | EXPRESION_G Smas EXPRESION_G                                                             { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.SUMA); }
    | EXPRESION_G Smenos EXPRESION_G                                                           { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.RESTA); }
    | EXPRESION_G Spor EXPRESION_G                                                  { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MULTIPLICACION); }
    | EXPRESION_G Sbarra EXPRESION_G                                                        { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.DIVISION); }
    | EXPRESION_G Sexponente EXPRESION_G                                                        { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.POTENCIA); }
    | EXPRESION_G Sporciento EXPRESION_G                                                          { $$ = API.operacion_Binaria($1,$3,TIPO_OPERACION.MODULO); }
    | CONTENIDO_EXPRESION Sdecremento %prec PRUEBA                                             { $$ = API.operacion_Unaria($1,TIPO_OPERACION.MODULO); }
    | CONTENIDO_EXPRESION Sincremento %prec PRUEBA                                             { $$ = API.operacion_Unaria($1,TIPO_OPERACION.DECREMENTO); }
    | Smenos  EXPRESION_G     %prec UMINUS                                             { $$ = API.operacion_Unaria($2,TIPO_OPERACION.NEGATIVO); }
    | Sdiferente   EXPRESION_G     %prec UMINUS                                             { $$ = API.operacion_Unaria($2,TIPO_OPERACION.NOT); }
    | CONTENIDO_EXPRESION                                                                        { $$ = $1; }  
;

CONTENIDO_EXPRESION
    : Vint                                                                                {$$ = API.n_Dato($1,TIPO.INT); }
    | Vdouble                                                                                    {$$ = API.n_Dato($1,TIPO.DOUBLE); }
    | id Sparentesisa Sparentesisc                                          {$$ = API.n_Funcion($1,'undefined');}
    | id Sparentesisa OPCIONAL Sparentesisc                                 {$$ = API.n_Funcion($1,API.n_Parametro($3));}
    | Rtrue                                                                                  {$$ = API.n_Dato($1,TIPO.BOOLEAN); }
    | Rfalse                                                                                  {$$ = API.n_Dato($1,TIPO.BOOLEAN); }
    | Sparentesisa EXPRESION_G Sparentesisc                                            {$$ = $2;}
    | id                                                                              {$$ = API.n_Dato($1,TIPO.IDENTIFICADOR); }
    | cadena                                                                                  {$$ = API.n_Dato($1,TIPO.STRING); }
    | char                                                                                       {$$ = API.n_Dato($1,TIPO.CHAR); }
    | char_especial                                                                              {$$ = API.n_Dato($1,TIPO.CHAR); }
;

OPCIONAL 
    : EXPRESION_G                                                                                {$$ = [$1];}
    | OPCIONAL Scoma EXPRESION_G                                                                {$1.push($2); $$ = $1;}  
;

FUNC
    :EXPRESION_G                    {$$ = $1;}
    |                               {$$='undefined';}
;

PARAMETROS
    : DEFINIR_PARAMETRO LISTA_PARAMETROS {
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
    } // $$ = $1 + $2 +$3;
    | DEFINIR_PARAMETRO {$$ = [$1];}
    | {$$='';}
;

LISTA_PARAMETROS
    : LISTA_PARAMETROS Scoma DEFINIR_PARAMETRO {$1.push($3); $$ = $1;}
    | Scoma DEFINIR_PARAMETRO {$$ =[$2];}
;

DEFINIR_PARAMETRO
    : TIPO_DATO id {parametroT.push({Tipo : $1,Nombre: $2});$$ = API.n_ParametroM($1,$2);}
;

METODOS_LL
    : id Sigual EXPRESION_G Spuntoycoma                                            {$$ = API.n_Asignacion($1,$3);}
    | id Sparentesisa PARAMETROS_FUNC Sparentesisc Spuntoycoma             {$$ = API.n_Funcion($1,API.n_Parametro($3));}
;
/*
REDUCCION
    :  Sigual EXPRESION_G Spuntoycoma {$$ = $1 +$2+$3;}
    | Sparentesisa PARAMETROS_FUNC Sparentesisc Spuntoycoma {$$ = $1 + $2+$3+ $4;}
;
*/
PARAMETROS_FUNC
    : PARAMETROS_FUNC Scoma EXPRESION_G { $1.push($3);  $$ = $1;}
    | EXPRESION_G                        {$$ = [$1];}
    | {$$='';}
;

LLAMAR_METODOF_CLASE
    : id Sparentesisa PARAMETROS_FUNC Sparentesisc Spuntoycoma {$$ = $1 + $2 + $3 + $4 + $5;}
;

INSTRUCCIONES
    : LISTA_INS                     {$$ = $1;}
    | {$$='';}
;

LISTA_INS
    : LISTA_INS LISTA_INSTRUCCIONES {$1.push($2); $$ = $1;}
    | LISTA_INSTRUCCIONES           {if(Array.isArray($1)){$$ = $1; }else{$$ = [$1];}}
;

LISTA_INSTRUCCIONES
    : METODOS_LL 
    | VARIABLE  
    | IMPRIMIR  
    | SENT_IF   
    | LOOP_WHILE
    | LOOP_DO_WHILE
    | LOOP_FOR  
    | SENT_SWITCH
    | S_TRANSFERENCIA
    |  error {$$ ='';erroresSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });erroresLexicosYSintacticos.push({ Tipo_Error  : ' Error_Sintactico ', Error  : yytext , Fila  : this._$.first_line , Columna  :  this._$.first_column });}
;

IMPRIMIR 
    : Rconsole Spunto TIPO_IMPRESION Sparentesisa EXPRESION_G Sparentesisc Spuntoycoma {$$ = API.n_Impresion($5,$7);}/*$1 + $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9*/
;

TIPO_IMPRESION
    : Rwrite 
    | RwriteLine 
;

S_TRANSFERENCIA
    : Rbreak Spuntoycoma { $$ = API.n_Break(); }
    | Rcontinue Spuntoycoma { $$ = API.n_Continue(); }
    | Rreturn FUNC Spuntoycoma { $$ = API.n_Return($2); }
;

SENT_IF
//: IF_FIJO DEF_IF  { $1.push($2); $$ = $1; }//$1+ $2 +$3
//$2.unshift($1);$$ = $2;    
    : IF_FIJO DEF_IF  { 
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

IF_FIJO
    : Rif Sparentesisa EXPRESION_G Sparentesisc Sllavea INSTRUCCIONES Sllavec {$$ = API.n_If($3,$6);}
;

DEF_IF
    : LISTADO_ELSI ELSE_FIJO { 
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
    | LISTADO_ELSI           {  
        var obj_if = []; 
        if(Array.isArray($1)){ 
            $$ =$1;
        } else{ 
            obj_if.push($1);
            $$ = obj_if;
        }
    }
    | ELSE_FIJO              { 
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

LISTADO_ELSI
    : LISTADO_ELSI ELSE_IF      { $1.push($2); $$ = $1;  }
    | ELSE_IF                   { $$ = [$1];  }
;

ELSE_FIJO
    : Relse Sllavea INSTRUCCIONES Sllavec { $$ = API.n_Else($3);  }
;

ELSE_IF
    : Relse Rif Sparentesisa EXPRESION_G Sparentesisc Sllavea INSTRUCCIONES Sllavec { $$ = API.n_ElseIf($4,$7); }
;


SENT_SWITCH
    : Rswitch Sparentesisa EXPRESION_G Sparentesisc Sllavea LISTA_CASE Sllavec {$$ = API.n_Switch($3,$6); }
;

LISTA_CASE
    : LS_CASE RED_SWITCH{ 
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
    | LS_CASE{  
        var obj_if = []; 
        if(Array.isArray($1)){ 
            $$ =$1;
        } else{ 
            obj_if.push($1);
            $$ = obj_if;
        }
    }
    | RED_SWITCH{ 
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


LS_CASE
    : LS_CASE DEF_CASE { $1.push($2); $$ = $1;  }
    | DEF_CASE         { $$ = [$1];  }
;

DEF_CASE
    : Rcase EXPRESION_G Sdospuntos INSTRUCCIONES {$$ = API.n_Case($2,$4);}
;

RED_SWITCH
    : Rdefault Sdospuntos INSTRUCCIONES     {$$ = API.n_Default($3);}
;


LOOP_WHILE
    : Rwhile Sparentesisa EXPRESION_G Sparentesisc Sllavea INSTRUCCIONES Sllavec   {$$ = API.n_While($3,$6);}/*$1+ $2 +$3 + $4 + $5 + $6 + $7;*/
;


LOOP_DO_WHILE
    : Rdo Sllavea INSTRUCCIONES Sllavec Rwhile Sparentesisa EXPRESION_G Sparentesisc Spuntoycoma { $$ = API.n_DoWhile($3,$7); }
;


LOOP_FOR
    : Rfor Sparentesisa CONT_FOR Spuntoycoma EXPRESION_G Spuntoycoma FIN_FOR Sparentesisa Sllavea INSTRUCCIONES Sllavec { $$ = API.n_For( $3 , $5 , $7 , $10); } /*$1 + $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10*/
;
                                                                                                                                            //inicio, condicion, fin, instrucciones
CONT_FOR
    : TIPO_DATO id Sigual EXPRESION_G        {$$ = API.n_Declaracion($1 , API.n_Variable($2,$4));}
    | id Sigual EXPRESION_G                  {$$ = API.n_Asignacion($1,$3);}
;

FIN_FOR
    : id Sigual EXPRESION_G                  {$$ = API.n_Asignacion($1,$3);}
    | EXPRESION_G                                                                      
    ;