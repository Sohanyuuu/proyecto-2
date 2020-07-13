import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'
import './App.css';
import ReactJson from 'react-json-view'

export default class Inicio extends Component {

    state = {
        archivo: "",
        pest: [],
        traduccion: "",
        tokens: [],
        html : "",
        json:"",
        arbol:"",
        actual:""
    }

    async componentDidMount() {
        this.getActividades();
        this.getpest();
        this.gettraduccion();
        this.gettokens();
        this.gethtml();
        this.getjson();
        this.getarbol();
    }

    getpest = async () => {
        const res = await axios.get('http://localhost:4000/pes');
        this.setState({
            pest: res.data
        });  
    }

    gettokens = async () => {
        const res = await axios.get('http://localhost:4000/tokens');
        this.setState({
            tokens: res.data
        });
    }

    gethtml = async () => {
        const res = await axios.get('http://localhost:4000/h');
        this.setState({
            html: res.data
        });
        document.getElementById('contenidohtml').value = this.state.html;
    }

    getjson = async () => {
        const res = await axios.get('http://localhost:4000/json');
        this.setState({
            json: res.data
        });
        document.getElementById('contenidojson').value = this.state.json;
    }

    getarbol = async () => {
        const res = await axios.get('http://localhost:4000/arbol');
        document.getElementById('idjson').value = "";
        this.setState({
            arbol: res.data
        });
        document.getElementById('idjson').value = this.state.arbol;
    }

    gettraduccion = async () => {
        const res = await axios.get('http://localhost:4000/traduccir');
        this.state.traduccion = "";
        document.getElementById('archivotraduccion').value = "";
        this.setState({
            traduccion: res.data
        });
        document.getElementById('archivotraduccion').value = this.state.traduccion;
    }

    actual = async (nom) => {
        var o = document.getElementById('archivotraduccion').value;
        const res = await axios.post('http://localhost:4000/actual', {
            contenido: nom
        });
        this.getActividades();
    }

    actualhyj = async (nom) => {
        if(nom === "HTML"){
            document.getElementById('contenidohtml').value = this.state.html;
        }else{
            document.getElementById('contenidohtml').value = this.state.json;
        }
    }

    getActividades = async () => {
        const res = await axios.get('http://localhost:4000/archivo');
        document.getElementById('archivo').value = res.data;
        this.getpest();
    }
    render() {
        return (
            <center>
                <h1 >Traductor</h1>
                <br></br>
                <br></br>
                <Link to='/errores'><button>Ver errores lexicos y sintacticos</button></Link>
                <br></br>
                <br></br>
                <div class="container">
                    <form>
                        <div class="form-row">
                            <div class="form-group col-md-5 bg-secondary">
                            <div class="card-header"><h2>Archivos</h2></div>
                                <center>
                                <div class="card-header">Editor</div>
                                    <ul class="nav nav-tabs" role="tablist">
                                        {
                                            this.state.pest.map(pest => (
                                                <li class="nav-item">
                                                    <button class="nav-link" href="#" onClick={() => this.actual(pest.contenido)}>{pest.nombre}</button>
                                                </li>
                                            ))
                                        }
                                    </ul>
                                    
                                    <textarea type="text" id="archivo" className="new-task" class="form-control" cols="50" rows="10"> </textarea>
                                    <br></br>
                                    <br></br>
                                    <div class="card-header">Reporte de tokens</div>
                                    <div id="div1" class="table-wrapper-scroll-y my-custom-scrollbar" className="bg">
                                        <table class="table table-bordered table-striped mb-0">
                                            <thead>
                                                <tr>
                                                    <th> Tipo</th>
                                                    <th> Lexema</th>
                                                    <th> Fila</th>
                                                    <th> Columna</th>
                                                </tr>
                                            </thead>
                                            {
                                                this.state.tokens.map(r => (
                                                    <tbody>
                                                        <td>{r.Tipo}</td>
                                                        <td>{r.Lexema}</td>
                                                        <td>{r.Fila}</td>
                                                        <td>{r.Columna}</td>
                                                    </tbody>
                                                ))
                                            }
                                        </table>
                                    </div>
                                </center>
                            </div>

                            <div class="form-group col-md-2">
                            </div>
                            <div class="form-group col-md-5 bg-secondary">
                                <div class="card-header"><h2>Reportes</h2></div>
                                <center>
                                <div class="card-header">Traduccion a Python</div>
                                    <textarea readOnly="true" type="text" id="archivotraduccion" className="new-task" class="form-control" cols="50" rows="10"></textarea>
                                </center>
                                <br></br>
                                <center>
                                <div class="card-header">HTML</div>
                                    <ul class="nav nav-tabs" role="tablist">
                                        <li class="nav-item">
                                            <button class="nav-link" href="#">HTML</button>
                                        </li>
                                    </ul>
                                    <textarea readOnly="true" type="text" id = "contenidohtml" className="new-task" class="form-control" cols="50" rows="10"></textarea>
                                <div class="card-header">JSON</div>
                                <ul class="nav nav-tabs" role="tablist">
                                        <li class="nav-item">
                                            <button class="nav-link" href="#">JSON</button>
                                        </li>
                                    </ul>
                                <textarea readOnly="true" type="text" id="contenidojson" className="new-task" class="form-control" cols="50" rows="10"></textarea>
                                </center>
                            </div>

                        </div>
                    </form>
                    <div class="form-group col-md-5 bg-secondary">
                    <div class="card-header">Arbol formato json</div>
                    <textarea readOnly="true" id= "idjson" type="text" className="new-task" class="form-control" cols="80" rows="10"></textarea>
                    <ReactJson src={this.state.arbol} theme="monokai"/>
                    </div>
                </div>
            </center>
        )
    }

}