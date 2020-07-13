import React from 'react';
import 'bootstrap/dist/css/bootstrap.min.css'
import './App.css';
import {BrowserRouter as Router, Route} from 'react-router-dom';
import Navegar from './navegar';
import Inicio from './inicio';
import Errores from './errores';

function App() {
  return (
      <Router>
        <Navegar/>
        <Route path="/inicio" component ={Inicio}/>
        <Route path="/errores" exact component ={Errores}/>
        <Inicio/>
      </Router>
  );
}

export default App;
