import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'
import 'bootstrap/dist/css/bootstrap.min.css'

export default class navegar extends Component {

    getUsers = async () => {
        const res = await axios.get('http://localhost:4000/archivo');
    }


    handleChangeFile(event) {
        const file = event.target.files[0];
        let formData = new FormData();
        formData.append('file', file);
        const res = axios.post('http://localhost:4000/uploadfile', formData);
        console.log(res.data);
        window.location.reload(true);
    }

    onSubmit = async (e) => {
            e.preventDefault();
            const response = window.prompt("Nombre de la pestaña");
            const res = await axios.post('http://localhost:4000/pes', {
                nombre: response,
                contenido: ""
            });
    }

    gettraduccion = async () => {
        const res = await axios.get('http://localhost:4000/traduccion');
        console.log(res.data);
        window.location.reload(true);
    }

    render() {
        return (
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <a class="navbar-brand">Proyecto 2</a>
                <div class="collapse navbar-collapse" id="navbarNavDropdown">
                    <ul class="navbar-nav">
                        <li class="nav-item active">
                            <button type="button" class="btn btn-dark" onClick={(e) => this.onSubmit(e)}>Nuevo</button>
                        </li>
                        
                        <li class="nav-item">
                            <button type="button" class="btn btn-dark">Guardar</button>
                        </li>
                        <li class="nav-item">
                            <button type="button" class="btn btn-dark">Salir</button>
                        </li>
                    </ul>
                <form class="form-inline">
                    <input type="file" class="btn btn-secondary btn-lg" onChange={this.handleChangeFile.bind(this)} />
                </form>
                </div>
                <div>
                <li class="nav-item active">
                            <button type="button" class="btn btn-dark" onClick={() => this.gettraduccion()}>Generar reporte</button>
                        </li>
                </div>
            </nav>
        )
    }
}