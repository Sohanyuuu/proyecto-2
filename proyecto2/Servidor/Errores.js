exports.leerJsonErroresL = function (json) {
    var cadErrores = "";
    json.forEach((element) => {
      cadErrores +=
        "Tipo Error: " +
        element.Tipo_Error +
        "\tError: " +
        element.Error +
        "\tFila: " +
        element.Fila +
        "\tColumna: " +
        element.Columna +
        "\n";
    });
    return cadErrores;
  }
  
exports.leerJsonErroresS = function (json) {
    var cadErrores = "";
    json.forEach((element) => {
      cadErrores +=
        "Tipo Error: " +
        element.Tipo_Error +
        "\tError: " +
        element.Error +
        "\tFila: " +
        element.Fila +
        "\tColumna: " +
        element.Columna +
        "\n";
    });
    return cadErrores;
  }

  exports.leerJsonErroresLS = function(json){
    var contE = 0;
    var cadErrores = "";
    json.forEach((element) => {
      cadErrores += "<tr>";
      cadErrores += "<td>" + (contE + 1) + "</td>";
      cadErrores += "<td>" + element.Tipo_Error + "</td>";
      cadErrores += "<td>" + element.Error + "</td>";
      cadErrores += "<td>" + element.Fila + "</td>";
      cadErrores += "<td>" + element.Columna + "</td>";
      cadErrores += "</tr>";
      contE++;
    });
    return cadErrores;
  }