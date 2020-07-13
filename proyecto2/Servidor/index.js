var express = require("express");
var bodyParser = require('body-parser');
var app = express();
const fs = require('fs');
const multer = require('multer');
const { TIPO_INSTRUCCION } = require('./api_cast');
const { Console } = require("console");

const TIPO = require('./api_cast').TIPO;
const TIPO_OPERACION = require('./api_cast').TIPO_OPERACION;
const INSTRUCCIONES_CONST = require('./api_cast').TIPO_INSTRUCCION;
const API = require('./api_cast').API;

app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, DELETE');
    res.header('Allow', 'GET, POST, OPTIONS, PUT, DELETE');
    next();
});



app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var respuesta = "";
var pest = [];
var contenido = "";
var traduccion = "";
var eti = "";
var conttab = 0;
var TextoAnalizar1 = " ";
var TextoAnalizar2 = " ";
var html = " ";
var j = "";
var etiquetas = [];
var JsonTemp1 = [];
var JsonTemp2 = [];
var Arbolito1 = [];
var Arbolito2 = [];
var tokens = [];
var tokenstem = [];
var ReporteAst;
var ErroresLexicos = [];
var ErroresSintacticos= [];
var ErroresLS = [];

//------------------------------------------subir archivo-------------------------------------------
var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads')
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname + '-' + Date.now())
    }
})

var upload = multer({ storage });

app.post('/uploadfile', upload.single('file'), (req, res, next) => {
    const file = req.file
    console.log(file.filename)

    fs.readFile('C:/Users/sohal/proyecto 2/proyecto2/Servidor/uploads/' + file.filename, 'utf-8', (err, data) => {
        if (err) {
            console.log('error: ', err);
        } else {
            console.log(data);
            respuesta = data;
            const con = {
                nombre: file.filename,
                contenido: data
            }
            pest.push(con);

        }
    });
});
//---------------------------------------------traduccion----------------------------------------------
app.get('/traduccion', function (req, res) {
    const analizar = require('./gramatica');
    analizar.LimpiarV();
    analizar.LimpiarV();
    TextoAnalizar2 = contenido;
    JsonTemp2 = analizar.parse(TextoAnalizar2);
    ErroresLexicos = analizar.errL();
    ErroresSintacticos = analizar.errS();
    ErroresLS = analizar.errLS();
    html ="";
    jsonhtml="";
    tokens=[];
    tokens = analizar.tks();
    console.log(tokens);
    analizar.LimpiarV();
    analizar.LimpiarV();
    res.json({ JsonTemp2 });
    console.log(JsonTemp2);

    TextoAnalizar1 = "";
    tokenstem=[];
    tokenstem = tokens;
    traducir(JsonTemp2);
    console.log(ErroresLexicos);
    console.log(ErroresSintacticos);
    return res.send(TextoAnalizar1);

});


app.get('/lexico', function (req, res) {
    return res.send(ErroresLexicos);

});

app.get('/sintactico', function (req, res) {
    return res.send(ErroresSintacticos);

});





app.get('/traduccir', function (req, res) {
    console.log(TextoAnalizar1);
    return res.send(TextoAnalizar1);

});

app.get('/tokens', function (req, res) {
    return res.send(tokenstem);
});

function tabs(tab) {
    var tabulaciones = ""
    console.log(tab);
    for (var i = 0; i < tab; i++) {
        tabulaciones += "\t";
    }
    return tabulaciones;
}

function traducir(ast) {
    ast.forEach(element => {
        if (element.Tipo === TIPO_INSTRUCCION.CLASE) procesarClase(element, conttab + 1); //busco si el elemento es tipo clase
        else if (element.Tipo === TIPO_INSTRUCCION.MAIN) console.log("tipo " + element.Tipo); //busco si el elemento es tipo main
    });
}

function procesarClase(instruccion, cont) {
    TextoAnalizar1 += ("Class " + instruccion.Identificador);
    console.log("inicia traduccion---->" + TextoAnalizar1);
    //obtengo la cantidad de tabs
    var tab = tabs(cont);
    //proceso instrucciones del elemento
    instruccion.Instrucciones.forEach(element => {
        if (element.Tipo === TIPO_INSTRUCCION.MAIN) {
            TextoAnalizar1 += ("\n" + tab + "def Main()");
            procesarMain(element, cont + 1);
        }
        else if (element.Tipo === TIPO_INSTRUCCION.DECLARACION) procesarDeclaracion(element, cont);
        else if (element.Tipo === TIPO_INSTRUCCION.METODO_FUNCION) procesarMetodoFuncion(element, cont);
        else if (element.Tipo === TIPO.FUNCION) procesarFuncion(element, cont);
        else if (element.Tipo === TIPO_INSTRUCCION.METODO) procesarMetodo(element, cont);
    });
}

//si viene un void main
function procesarMain(Inst, cont) {
    //obtengo numero de tab
    var tab = tabs(cont);
    //proceso instruccion del objeto
    procesarInstrucGeneral(Inst, cont);
}

function procesarAsignacion(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += "\n" + tab + inst.Identificador + "=" + inst.Valor_variable.Dato;

}

function procesarDeclaracion(inst, cont) {
    var tab = tabs(cont);
    var cont = 0;
    var cont2 = 1;
    TextoAnalizar1 += "\n" + tab + "Def ";

    inst.Definicion_variables.forEach(element => {
        cont++;
    });

    inst.Definicion_variables.forEach(element => {
        if (element.Valor_variable === "undefined") {
            TextoAnalizar1 += (element.Identificador);
        } else {
            TextoAnalizar1 += (element.Identificador + "=" + element.Valor_variable.Dato)
        }
        if (cont2 != cont) {
            TextoAnalizar1 += ", ";
        }
        cont2++;
    });
}

function procesarFuncion(inst, cont) {
    var tab = tabs(cont);
    var cont = 0;
    var cont2 = 1;
    TextoAnalizar1 += ("\n" + tab + inst.Identificador + "(");
    if (inst.Parametro.Definicion_Parametro != null) {
        inst.Parametro.Definicion_Parametro.forEach(element => {
            cont++;
        });
        inst.Parametro.Definicion_Parametro.forEach(element => {
            if (element.Dato != null) {
                TextoAnalizar1 += element.Dato;
            }


            if (cont2 != cont) {
                TextoAnalizar1 += ", ";
            }
            cont2++;
        });
        TextoAnalizar1 += ")"
    } else {
        TextoAnalizar1 += ")"
    }
}

function procesarif(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += ("\n" + tab + "if ");
    inst.children.forEach(element => {
        if (element.Tipo === TIPO_INSTRUCCION.IF) //if
        {
            procesarExpresiones(element.Expresion);
            if (element.Instrucciones != null) {
                procesarInstrucGeneral(element, cont + 1);
            } else {
                console.log("no tiene instrucciones");
            }
        }
        else if (element.Tipo === TIPO_INSTRUCCION.ELSE) procesarElse(element, cont); // else
        else if (element.Tipo === TIPO_INSTRUCCION.ELSE_IF) procesarElseIF(element, cont);
    });


}

function procesarElseIF(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += ("\n" + tab + "elif ");
    procesarExpresiones(inst.Expresion);
    if (inst.Instrucciones != null) {
        procesarInstrucGeneral(inst, cont + 1);
    } else {
        console.log("no tiene instrucciones");
    }
}

function procesarElse(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += ("\n" + tab + "else ");

    if (inst.Instrucciones != null) {
        procesarInstrucGeneral(inst, cont + 1);
    }


}

function procesarInstrucGeneral(inst, cont) {
    var tab = tabs(cont);
    inst.Instrucciones.forEach(element => {
        if (element.Tipo_Operacion === TIPO_INSTRUCCION.IMPRIMIR_LN) {
            TextoAnalizar1 += ("\n" + tab + "print(");
            procesarExpresiones(element.Expresion_Cad);
            TextoAnalizar1 += (")");

            if (element.Expresion_Cad.Tipo_Dato === "Cadena_HTML") {
                console.log("cadena html");
                html += element.Expresion_Cad.Dato;
            }

        } else if (element.Tipo_Operacion === TIPO_INSTRUCCION.IMPRIMIR) {
            TextoAnalizar1 += ("\n" + tab + "print(")
            procesarExpresiones(element.Expresion_Cad);
            TextoAnalizar1 += (" end=\"\")");

            if (element.Expresion_Cad.Tipo_Dato === "Cadena_HTML") {
                console.log("cadena html");
                html += element.Expresion_Cad.Dato;
            }
        } else if (element.Tipo === TIPO_INSTRUCCION.DECLARACION) procesarDeclaracion(element, cont);
        else if (element.Tipo === TIPO_INSTRUCCION.ASIGNACION) procesarAsignacion(element, cont);
        else if (element.Tipo === TIPO.FUNCION) procesarFuncion(element, cont);
        else if (element.text == TIPO_INSTRUCCION.CONTIF) procesarif(element, cont);
        else if (element.Tipo == TIPO_INSTRUCCION.SWITCH) procesarSwtich(element, cont);
        else if (element.Tipo == TIPO_INSTRUCCION.WHILE) procesarWhile(element, cont);
        else if (element.Tipo == TIPO_INSTRUCCION.DO_WHILE) procesarDoWhile(element, cont);
        else if (element.Tipo == TIPO_INSTRUCCION.FOR) procesarFor(element, cont);
    });
}

function procesarFor(inst, cont) {
    var tab = tabs(cont)
    TextoAnalizar1 += "\n" + tab + "for in a range(";
    if (inst.Inicio_for.Definicion_variables != null) {
        TextoAnalizar1 += inst.Inicio_for.Definicion_variables[0].Valor_variable.Dato + ",";
    } else {
        TextoAnalizar1 += inst.Inicio_for.Valor_variable.Dato + ",";
    }
    if (inst.Condicion_for.Operador_Derecho.Dato != null) {
        TextoAnalizar1 += inst.Condicion_for.Operador_Derecho.Dato + ")";
    }
    if (inst.Instrucciones != null) {
        procesarInstrucGeneral(inst, cont + 1);
    } else {
        console.log("no tiene instrucciones");
    }
}

function procesarDoWhile(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += "\n" + tab + "Do";
    if (inst.Instrucciones != null) {
        procesarInstrucGeneral(inst, cont + 1);
    } else {
        console.log("no tiene instrucciones");
    }
    if (inst.Expresion.Dato == null) {
        TextoAnalizar1 += "\n" + tab + "Do ";
        procesarExpresiones(inst.Expresion);

    } else {
        TextoAnalizar1 += "\n" + tab + "While " + inst.Expresion.Data;
    }
}

function procesarWhile(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += "\n" + tab + "while ";
    if (inst.Expresion.Dato == null) {
        procesarExpresiones(inst.Expresion);
        if (inst.Instrucciones != null) {
            procesarInstrucGeneral(inst, cont + 1);
        } else {
            console.log("no tiene instrucciones");
        }
    } else {
        TextoAnalizar1 += inst.Expresion.Data;
    }
}

function procesarSwtich(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += ("\n" + tab + "def switch (" + inst.Expresion.Dato + "):");
    var tab2 = tabs(cont + 1);
    TextoAnalizar1 += ("\n") + tab2 + "switcher={";
    inst.Instrucciones.forEach(element => {
        if (element.Tipo === TIPO_INSTRUCCION.CASE) {
            TextoAnalizar1 += "\n" + tab2 + element.Expresion.Dato + ":";
            procesarInstrucGeneral(element, cont + 2);
        } else if (element.Tipo === TIPO_INSTRUCCION.DEFAULT) {

        }

    });
    TextoAnalizar1 += ("\n") + tab2 + "}";
}

function procesarExpresiones(inst) {
    if (inst == null) {
        return;
    }

    procesarExpresiones(inst.Operador_Izquierdo);
    //TextoAnalizar1+=" "+inst.Dato;
    if (inst.Operador === inst.Operador_Izquierdo) {
        TextoAnalizar1 += inst.Dato;
    } else {
        if (inst.Tipo_Operacion === TIPO_OPERACION.MAYOR_IGUAL_QUE) TextoAnalizar1 += ">=";
        else if (inst.Tipo_Operacion === TIPO_OPERACION.MENOR_IGUAL_QUE) TextoAnalizar1 += "<=";
        else if (inst.Tipo_Operacion === TIPO_OPERACION.IGUAL_IGUAL) TextoAnalizar1 += "==";
        else if (inst.Tipo_Operacion === TIPO_OPERACION.DISTINTO) TextoAnalizar1 += "!=";
        else if (inst.Tipo_Operacion === TIPO_OPERACION.MAYOR_QUE) TextoAnalizar1 += ">";
        else if (inst.Tipo_Operacion === TIPO_OPERACION.MENOR_QUE) TextoAnalizar1 += "<";
        else if (inst.Tipo_Operacion === TIPO_OPERACION.NOT) TextoAnalizar1 += " ! ";
        else if (inst.Tipo_Operacion === TIPO_OPERACION.AND) TextoAnalizar1 += " && ";
        else if (inst.Tipo_Operacion === TIPO_OPERACION.OR) TextoAnalizar1 += " || ";
    }
    procesarExpresiones(inst.Operador_Derecho);

}

function procesarMetodoFuncion(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += "\n" + tab + inst.Identificador + "(";

    procesarParametros(inst);

    TextoAnalizar1 += ")";

    if (inst.Instrucciones != null) {
        procesarInstrucGeneral(inst, cont + 1);
    } else {
        console.log("no tiene instrucciones");
    }

}

function procesarParametros(inst) {
    var cont = 0;
    var cont2 = 1;

    inst.Parametros.forEach(element => {
        cont++;
    });

    inst.Parametros.forEach(element => {
        if (element.Identificador != null) {
            TextoAnalizar1 += element.Identificador;
        }

        if (cont2 != cont) {
            TextoAnalizar1 += ", ";
        }
        cont2++;
    });

}



function procesarMetodo(inst, cont) {
    var tab = tabs(cont);
    TextoAnalizar1 += "\n" + tab + inst.Identificador + "(";

    procesarParametro(inst);

    TextoAnalizar1 += ")";

    if (inst.Instrucciones != null) {
        procesarInstrucGeneral(inst, cont + 1);
    } else {
        console.log("no tiene instrucciones");
    }

}

function procesarParametro(inst) {
    var cont = 0;
    var cont2 = 1;

    inst.Parametro.forEach(element => {
        cont++;
    });

    inst.Parametro.forEach(element => {
        if (element.Identificador != null) {
            TextoAnalizar1 += element.Identificador;
        }

        if (cont2 != cont) {
            TextoAnalizar1 += ", ";
        }
        cont2++;
    });
}
//------------------------------------------pestañas--------------------------------------------
app.post('/pestaña', async (req, res) => {
    try {
        const con = {
            nombre: req.body.nombre,
            contenido: req.body.contenido
        }
        pestañas.push(con)
        res.send("se pudo")
    } catch{
        res.send("nose puede");
    }
})

app.post('/actual', async (req, res) => {
    try {
        contenido = req.body.contenido;
        console.log(contenido);
        res.send("se pudo")
    } catch{
        res.send("nose puede");
    }
})


app.get('/json', function (req, res) {
    console.log(j);
    return res.json(j);
})



app.get('/h', function (req, res) {
    console.log(html);
    var co = 0;
    var cos = "";
    var e = [];
    var el=[];
    var nuevo = [];
    var bandera = false;
    eti = "";
    etiquetas = html.split('<');
    etiquetas.forEach(element =>{
        e.push(element.split('>'));
    });

    e.forEach(element =>{
        element.forEach(elem=>{
            el.push(elem.split(' '));
        });
    });
    el.forEach(element =>{
        element.forEach(elem=>{
            nuevo.push(elem.split('='));
        });
    });
el = [];
    nuevo.forEach(element =>{
        element.forEach(elem=>{
            el.push(elem.split(':'));
        });
    });

    console.log(el);
    var jsonhtml="";
    var palabra = "";
    var style = true;
    var stylediv = false;
    var descripcion = [];
    var color = "";
    var temporal = [];
    var temporal1 = [];
    var div = false;
    el.forEach(ele => {
        ele.forEach( element =>{
            console.log(element);
            if (element === 'HTML') {
                eti += "<"+element + ">" + "\n";
                
            } else if (element === '/HTML') {
                eti += "<"+element + ">" + "\n";
                const f = {
                    HTML: descripcion
                }
                jsonhtml=f;
            } else if (element === 'BODY') {
                style=false;
                bandera = true;
                eti += cos+"<"+element+"  ";
                co++;
                cos = tabshtml(co);
                temporal=[];

            } else if (element === '/BODY') {
                co--;
                cos = tabshtml(co);
                bandera = false;
                eti += cos+"<"+element + ">" + "\n";
                if(style===true){
                    const f = {
                        BODY: temporal
                    }
                    descripcion.push(f);
                }else{
                    const f = {
                        BODY: temporal
                    }
                    descripcion.push(f);
                }
                console.log(style);
                temporal=[];
                style = false;
            } else if (element === 'HEAD') {
                temporal=[];
                eti += cos+"<"+element + ">" + "\n";
                co++;
                cos = tabshtml(co);
            } else if (element === '/HEAD') {
                co--;
                cos = tabshtml(co);
                eti += cos+"<"+element + ">" + "\n";
                const f = {
                    HEAD: temporal
                }
                descripcion.push(f);
                temporal=[];
            } else if (element === 'H1') {
                eti += cos+"<"+element + ">    " ;
                palabra="";
            } else if (element === '/H1') {
                eti += "<"+element + ">" + "\n";
                const f = {
                    H1: {TEXTO: palabra}
                }
                if(div===true){
                    temporal1.push(f);
                }else{
                    temporal.push(f);
                }
            }
            else if (element === 'DIV') {
                div=true;
                temporal1=[];
                stylediv=false;
                bandera = false;
                eti += cos +"<"+element + ">" + "\n";
                co++;
                cos = tabshtml(co);
            } else if (element === '/DIV') {
                bandera = false;
                co--;
                cos = tabshtml(co);
                eti += cos + "<"+element + ">" + "\n";
                if(stylediv===true){
                    const f = {
                        DIV: temporal1
                    }
                    temporal.push(f);
                }else{
                    const f = {
                        DIV: temporal1
                    }
                    temporal.push(f);
                }
                div=false;
            } else if (element === 'TITLE') {
                eti += cos + "<"+element + ">   " ;
                palabra="";
            } else if (element === '/TITLE') {
                eti += "<"+element + ">" + "\n";
                const f = {
                    TITLE: {TEXTO: palabra}
                }
                temporal.push(f);
                temporal1.push(f);
            }
            else if (element === 'BR') {
                eti += cos + "<"+element + ">" + "\n";
                const f = {
                    BR: {}
                }
                temporal.push(f);
                temporal1.push(f);
            } else if (element === 'P') {
                eti += cos + "<"+element + ">" + "\n";
                palabra="";
            } else if (element === '/P') {
                eti += cos + "<"+element + ">" + "\n";
                const f = {
                    P: {TEXTO: palabra}
                }
                if(div===true){
                    temporal1.push(f);
                }else{
                    temporal.push(f);
                }
            }
            else if (element === 'BUTTON') {
                eti += cos + "<"+element + ">";
                palabra="";
            }
            else if (element === '/BUTTON') {
                eti += cos + "<"+element + ">" + "\n";
                const f = {
                    BUTTON: {TEXTO: palabra}
                }
                if(div===true){
                    temporal1.push(f);
                }else{
                    temporal.push(f);
                }
            }
            else if (element === 'LABEL') {
                eti += cos + "<"+element + ">";
                palabra="";
            } else if (element === '/LABEL') {
                eti += cos + "<"+element + ">" + "\n";
                const f = {
                    LABEL: {TEXTO: palabra}
                }
                console.log(div+"label");
                if(div===true){
                    temporal1.push(f);
                    console.log(temporal1);
                }else{
                    temporal.push(f);
                }
            } else if (element === 'INPUT') {
                eti += cos + "<"+element + ">" + "\n";
                palabra="";
            }
            else if (element === '/INPUT') {
                eti += cos + "<"+element + ">" + "\n";
                const f = {
                    INPUT: {TEXTO: palabra}
                }
                if(div===true){
                    temporal1.push(f);
                }else{
                    temporal.push(f);
                }
            }else if (element === 'style') {
                stylediv=true;
                style = true;
                console.log(style);
                bandera = false;
                eti += element + "=";
                
            } else if (element === 'yellow"') {
                eti += ":"+element+ ">" + "\n";
                color = "background:yellow";
                bandera = false;
                style=true;
                const t = {
                    STYLE: color
                }
                temporal.push(t);
            } else if (element === 'green"') {
                eti += ":"+element+ ">" + "\n";
                bandera = false;
                color = "background:green";
                temporal.push({STYLE: {STYLE: color}});
            }else if (element === '"blue"') {
                eti +=":"+ element+ ">" + "\n";
                bandera = false;
                color = "background:blue";
                temporal.push({STYLE: color});
            }else if (element === 'red"') {
                eti +=":"+ element+ ">" + "\n";
                bandera = false;
                color = "background:red";
                temporal.push({STYLE: color});
            }else if (element === 'white"') {
                eti +=":"+ element + ">" + "\n";
                bandera = false;
                color = "background:white";
                temporal.push({STYLE: color});
            }else if (element === 'skyblue"') {
                bandera = false;
                eti += ":"+element + ">" + "\n";
                color = "background : skyblue";
                temporal.push({STYLE: color});
            }else if (element === '"background') {
                bandera = false;
                eti += element;
            } else if (element === '') {
                eti += element;
            }else{
                if(bandera===true){
                    eti += ">"+element;
                    bandera=false;
                }else{
                    eti += element;
                    palabra+= element;
                }
            }
        });
    }
    );
    console.log(jsonhtml);
    j="";
    j= JSON.stringify(jsonhtml, null, "\t");
    console.log(j);
    console.log(eti);
    var h = html;
    return res.send(eti)
});



function tabshtml(tab) {
    var tabulaciones = ""
    console.log(tab);
    for (var i = 0; i < tab; i++) {
        tabulaciones += "\t";
    }
    return tabulaciones;
}

app.get('/pes', function (req, res) {
    console.log(traduccion);
    console.log("-----------");
    return res.send(pest)
});

app.get('/arbol', function (req, res) {
    return res.send(JsonTemp2)
});


app.post('/pes', async (req, res) => {
    try {
        const user = {
            nombre: req.body.nombre,
            contenido: req.body.contenido
        }
        pest.push(user)
        res.send("pestaña agregada")
    } catch{

        alert("no se puedo agregar la pestaña");
    }


})
//---------------------------------------------archivo-----------------------------------------------------
app.get('/archivo', function (req, res) {
    return res.send(contenido);
    console.log(contenido);
});

app.listen(4000, () => {
    console.log("El servidor está inicializado en el puerto 4000");
});
