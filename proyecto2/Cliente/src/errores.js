import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'
import './App.css';
import ReactJson from 'react-json-view'

export default class Inicio extends Component {

    state = {
        lexicos: [],
        sintacticos: []
    }

    async componentDidMount() {
        this.getActividades();
        this.getpest();
    }

    getpest = async () => {
        const res = await axios.get('http://localhost:4000/lexico');
        this.setState({
            lexicos: res.data
        });
    }


    getActividades = async () => {
        const res = await axios.get('http://localhost:4000/sintactico');
        document.getElementById('archivo').value = res.data;
        this.setState({
            sintacticos: res.data
        });
    }

    render() {
        return (

            <center>
                <h1 >Errores</h1>
                <br></br>
                <br></br>
                <div class="container">
                    <form>
                        <div class="form-row bg-secondary">
                            <div class="form-group col-md-5">
                                <div class="card-header">Reporte de Errores lexicos</div>
                                <br></br>
                                <div id="div1" class="table-wrapper-scroll-y my-custom-scrollbar" className="bg">
                                    <table class="table table-bordered table-striped mb-0">
                                        <thead>
                                            <tr>
                                                <th> Tipo</th>
                                                <th> Error</th>
                                                <th> Fila</th>
                                                <th> Columna</th>
                                            </tr>
                                        </thead>
                                        {
                                            this.state.lexicos.map(r => (
                                                <tbody>
                                                    <td>{r.Tipo_Error}</td>
                                                    <td>{r.Error}</td>
                                                    <td>{r.Fila}</td>
                                                    <td>{r.Columna}</td>
                                                </tbody>
                                            ))
                                        }
                                    </table>
                                </div>
                            </div>

                            <div class="form-group col-md-2">
                            </div>
                            <div class="form-group col-md-5">
                                <div class="card-header">Reporte de Errores sintacticos</div>
                                <br></br>
                                <div id="div1" class="table-wrapper-scroll-y my-custom-scrollbar" className="bg">
                                    <table class="table table-bordered table-striped mb-0">
                                        <thead>
                                            <tr>
                                                <th> Tipo</th>
                                                <th> Error</th>
                                                <th> Fila</th>
                                                <th> Columna</th>
                                            </tr>
                                        </thead>
                                        {
                                            this.state.sintacticos.map(r => (
                                                <tbody>
                                                    <td>{r.Tipo_Error}</td>
                                                    <td>{r.Error}</td>
                                                    <td>{r.Fila}</td>
                                                    <td>{r.Columna}</td>
                                                </tbody>
                                            ))
                                        }
                                    </table>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

            </center>
        )
    }

}