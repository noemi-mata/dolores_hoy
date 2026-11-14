import 'package:dolores_hoy/datos/config_claves.dart';
import 'package:dolores_hoy/datos/servicios.dart';
import 'package:dolores_hoy/presentacion/pantalla_tablero.dart';
import 'package:dolores_hoy/presentacion/tablero_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'ayudas.dart';

/// En estas pruebas la NASA responde 500 a propósito: así no se intenta
/// descargar ninguna imagen real y comprobamos la tarjeta de error.
TableroViewModel crear() {
  final c = seguro((http.Request r) async =>
      r.url.host == 'api.nasa.gov' ? jsonOk({}, 500) : await servidorFalso(r));
  return TableroViewModel(
    clima: ServicioClima(c),
    cambio: ServicioCambio(c),
    festivos: ServicioFestivos(c),
    wikipedia: ServicioWikipedia(c),
    nasa: ServicioNasa(c, const ConfigClaves(nasa: 'DEMO_KEY')),
  );
}

/// Pantalla alta para que las 5 tarjetas quepan sin hacer scroll.
void pantallaGrande(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('muestra los títulos de las 5 tarjetas', (tester) async {
    pantallaGrande(tester);
    await tester.pumpWidget(MaterialApp(home: PantallaTablero(vm: crear())));
    expect(find.text('Dolores Hoy'), findsOneWidget);
    expect(find.text('Clima en Dolores Hidalgo'), findsOneWidget);
    expect(find.text('Tipo de cambio'), findsOneWidget);
    expect(find.text('Próximos festivos'), findsOneWidget);
    expect(find.text('Wikipedia'), findsOneWidget);
    expect(find.text('Foto astronómica (NASA)'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('al terminar de cargar muestra los datos y el error de la NASA',
      (tester) async {
    pantallaGrande(tester);
    await tester.pumpWidget(MaterialApp(home: PantallaTablero(vm: crear())));
    await tester.pumpAndSettle();
    expect(find.textContaining('24.3 °C'), findsOneWidget);
    expect(find.textContaining('1 USD ='), findsOneWidget);
    expect(find.textContaining('Dolores Hidalgo es una ciudad'), findsOneWidget);
    expect(find.textContaining('(500)'), findsOneWidget);
  });
}