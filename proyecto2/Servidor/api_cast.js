const TIPO = {
  INT:                'Entero',
  DOUBLE:             'Decimal',
  CHAR:               'Caracter',
  BOOLEAN:            'Logico',
  STRING:             'Cadena',
  STRING_e:           'Cadena_HTML',
  IDENTIFICADOR:      'Identificador',
  FUNCION:            'Funcion'
}

const TIPO_OPERACION = {
// OPERACIONES ARITMETICAS    
  SUMA:               'Operacion_Suma',
  RESTA:              'Operacion_Resta',
  MULTIPLICACION:     'Operacion_Multiplicacion',
  DIVISION:           'Operacion_Division',
  POTENCIA:           'Operacion_Potencia',
  MODULO:             'Operacion_Modulo',
  NEGATIVO:           'Operacion_Negativo',
  INCREMENTO:         'Operacion_Incremento',
  DECREMENTO:         'Operacion_Decremento',
// OPERACIONES RELACIONALES
  MAYOR_IGUAL_QUE:   'Operacion_MayorIgualQue',
  MENOR_IGUAL_QUE:   'Operacion_MenorIgualQue',
  IGUAL_IGUAL:       'Operacion_IgualIgual',
  DISTINTO:          'Operacion_Distinto',
  MENOR_QUE:         'Operacion_MenorQue',
  MAYOR_QUE:         'Operacion_MayorQue',
// OPERADORES RELACIONALES
  NOT:               'Operacion_Not',
  AND:               'Operacion_And',
  OR:                'Operacion_Or'
}

const TIPO_INSTRUCCION = {
  IMPRIMIR:       'Instruccion_Imprimir',
  IMPRIMIR_LN:    'Instruccion_ImprimirLN', 
  IF:             'Instruccion_If',
  ELSE_IF:        'Instruccion_ElseIf',
  ELSE:           'Instruccion_Else',
  SWITCH:         'Instruccion_Switch',
  DO_WHILE:       'Instruccion_Do',
  WHILE:          'Instruccion_While',
  FOR:            'Instruccion_For',
  DECLARACION:    'Instruccion_Declaracion',
  ASIGNACION:     'Instruccion_Asignacion',
  IMPORT:         'Instruccion_Import',
  CLASE:          'Instruccion_clase',
  DEFAULT:        'Instruccion_Default',
  CASE:           'Instruccion_Case',
  BREAK:          'Instruccion_Break', 
  CONTINUE:       'Instruccion_Continue',
  RETURN:         'Instruccion_Return',
  MAIN:           'Instruccion_Main',
  METODO:         'Instruccion_Metodo',
  METODO_FUNCION: 'Instruccion_Metodo_Funcion',
  CONTIF:         'IF'
}

//creando operacion
function generarOperacion(operador_Izquierdo, operador_Derecho, tipo_Operacion) {
return {
  Operador_Izquierdo: operador_Izquierdo,
  Operador_Derecho: operador_Derecho,
  Tipo_Operacion: tipo_Operacion
}
}

const API ={
  //operaciones rel,aritmeticas y logicas
  operacion_Binaria: function(operador_Izquierdo, operador_Derecho, tipo_Operacion) {
  return generarOperacion(operador_Izquierdo, operador_Derecho, tipo_Operacion);
  },
  
  operacion_Unaria: function(operador, tipo_Operacion) {
  return generarOperacion(operador, undefined, tipo_Operacion);
  },

  // guarda los valores cadena,entero,booleano,identificadores,numeros y decimales
  n_Dato: function(dato, tipo_Dato) {
  return {
    Tipo_Dato: tipo_Dato,
    Dato: dato
  }
  },
  
  // impresion en consola
  n_Impresion: function(tipo_Imprimir,expresion_Cad) {
  return {
    Tipo_Operacion: tipo_Imprimir,
    Expresion_Cad: expresion_Cad
  };
},

n_Declaracion: function(tipo, lista_variables) {
  return {
    Tipo: TIPO_INSTRUCCION.DECLARACION,
    Tipo_dato: tipo,
    Definicion_variables: lista_variables
  }
},

n_Variable: function(identificador, valor_variable) {
  return {
    Identificador: identificador,
    Valor_variable: valor_variable
  }
},

n_Asignacion: function(identificador, expresion) {
  return {
    Tipo: TIPO_INSTRUCCION.ASIGNACION,
    Identificador: identificador,
    Valor_variable: expresion
  }
},

// ciclo while
n_While: function(expresion, instrucciones) {
  return {
    Tipo: TIPO_INSTRUCCION.WHILE,
    Expresion: expresion,
    Instrucciones: instrucciones
  };
},

n_For: function (inicio, condicion, fin, instrucciones) {
  return {
    Tipo: TIPO_INSTRUCCION.FOR,
    Inicio_for:     inicio,
    Condicion_for:  condicion,
    Incremento:     fin,
    Instrucciones:  instrucciones
  }
},

n_Funcion : function(identificador,parametro){
    return{
      Tipo: TIPO.FUNCION,
      Identificador: identificador,
      Parametro: parametro
    }
},

n_Parametro : function (parametro) {
  return {
    Definicion_Parametro: parametro
  }
},

n_If: function(expresion, instrucciones) {
  return {
    Tipo: TIPO_INSTRUCCION.IF,
    Expresion: expresion,
    Instrucciones: instrucciones
  }
},

n_ElseIf: function(expresion, instrucciones) {
  return {
    Tipo: TIPO_INSTRUCCION.ELSE_IF,
    Expresion: expresion,
    Instrucciones: instrucciones
  }
},

n_Else: function(instrucciones) {
  return {
    Tipo: TIPO_INSTRUCCION.ELSE,
    Instrucciones: instrucciones
  }
},

n_Switch: function(expresion, instrucciones) {
  return {
    Tipo: TIPO_INSTRUCCION.SWITCH,
    Expresion: expresion,
    Instrucciones: instrucciones
  }
},

n_Case: function(expresion, instrucciones) {
  return {
    Tipo: TIPO_INSTRUCCION.CASE,
    Expresion: expresion,
    Instrucciones: instrucciones
  }
},

n_Default: function(instrucciones) {
  return {
    Tipo: TIPO_INSTRUCCION.DEFAULT,
    Instrucciones: instrucciones
  }
},

//ciclo do while
n_DoWhile: function(instrucciones, expresion) {
  return {
    Tipo: TIPO_INSTRUCCION.DO_WHILE,
    Instrucciones: instrucciones,
    Expresion: expresion
  }
},

//continue
n_Continue: function() {
  return {
    Tipo: TIPO_INSTRUCCION.CONTINUE
  }
},

//return
n_Return: function(expresion) {
  return {
    Tipo: TIPO_INSTRUCCION.RETURN,
    Expresion: expresion
  }
},

//break
n_Break: function() {
  return {
    Tipo: TIPO_INSTRUCCION.BREAK
  }
},

// metodos que no retornan valores
n_Metodo : function(identificador, parametro, instrucciones){
  return {
    Tipo: TIPO_INSTRUCCION.METODO,
    Identificador: identificador,
    Parametro: parametro,
    Instrucciones: instrucciones
  }
},

// funciones que retornan valor
n_Metodo_Funcion : function(tipo_funcion,identificador, parametro,instrucciones){
  return {
    Tipo: TIPO_INSTRUCCION.METODO_FUNCION,
    Tipo_Retorno: tipo_funcion,
    Identificador: identificador,
    Parametros:  parametro,
    Instrucciones: instrucciones
  }
},

//metodo principal
n_Metodo_Principal : function(instrucciones){
  return{
    Tipo: TIPO_INSTRUCCION.MAIN,
    Instrucciones: instrucciones
  }
},

//declaracion de parametros en metodos
n_ParametroM : function(tipo_parametro, identificador){
  return{
    Tipo: tipo_parametro,
    Identificador: identificador
  }
},

n_Clase : function(identificador, instrucciones){
  return{
    Tipo: TIPO_INSTRUCCION.CLASE,
    Identificador: identificador,
    Instrucciones: instrucciones
  }
},

n_Import : function(identificador){
  return{
    Tipo: TIPO_INSTRUCCION.IMPORT,
    Identificador: identificador
  }
},

n_Ident : function(identificador){
  return{
    Tipo: TIPO.IDENTIFICADOR,
    Identificador: identificador
  }
},

cont_If : function(if_contener){
  return{
      text :TIPO_INSTRUCCION.CONTIF,
      icon:'./img/interfaz.png',
      children : if_contener
  }
},

}



module.exports.TIPO = TIPO;
module.exports.TIPO_OPERACION = TIPO_OPERACION;
module.exports.TIPO_INSTRUCCION = TIPO_INSTRUCCION;
module.exports.API = API;