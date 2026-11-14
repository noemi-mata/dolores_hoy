import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'datos/cliente_seguro.dart';
import 'datos/config_claves.dart';
import 'datos/servicios.dart';
import 'presentacion/pantalla_tablero.dart';
import 'presentacion/tablero_viewmodel.dart';

void main() {
  // Composition root: aquí se arma todo.
  // 20 s de espera: en el emulador 8 s se quedaba corto y salía "No hay conexión".
  final cliente = ClienteSeguro(http.Client(), espera: const Duration(seconds: 20));
  final claves = ConfigClaves.desdeEntorno();
  final vm = TableroViewModel(
    clima: ServicioClima(cliente),
    cambio: ServicioCambio(cliente),
    festivos: ServicioFestivos(cliente),
    wikipedia: ServicioWikipedia(cliente),
    nasa: ServicioNasa(cliente, claves),
  );
  runApp(MaterialApp(
    title: 'Dolores Hoy',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: PantallaTablero(vm: vm),
  ));
}