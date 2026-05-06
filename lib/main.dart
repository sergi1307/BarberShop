import 'package:flutter/material.dart';
// Importamos tu nueva pantalla (el editor debería reconocer esta ruta)
import 'views/screens/networkoverview.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barber Shop',
      debugShowCheckedModeBanner: false, // Esto quita la etiqueta roja de "DEBUG" de la esquina
      theme: ThemeData(
        useMaterial3: true,
      ),
      // ¡Aquí hacemos el cambiazo! Le decimos que arranque con tu diseño
      home: const LuxeCutsScreen(),
    );
  }
}