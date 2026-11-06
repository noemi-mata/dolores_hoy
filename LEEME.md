# Dolores Hoy — cómo compilar

1. Crea el proyecto base (genera android/, ios/, etc.):
   ```
   flutter create dolores_hoy
   ```
2. Copia ENCIMA del proyecto creado el contenido de este zip:
   `pubspec.yaml`, `lib/`, `test/`, `secrets.json`, `secrets.json.example`.
   Reemplaza cuando te pregunte.
3. Borra `test/widget_test.dart` (el que generó Flutter; si no, falla `flutter test`).
4. Agrega al final de `.gitignore` las líneas de `gitignore_agregar.txt`.
5. En `android/app/src/main/AndroidManifest.xml`, justo arriba de `<application`, agrega:
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   ```
6. Ejecuta:
   ```
   flutter pub get
   flutter test
   flutter run --dart-define-from-file=secrets.json
   ```

APK final:
```
flutter build apk --obfuscate --split-debug-info=build/simbolos --dart-define-from-file=secrets.json
```

Si tienes tu propia clave de la NASA, ponla en `secrets.json` en lugar de `DEMO_KEY`
(no subas `secrets.json` a GitHub).
