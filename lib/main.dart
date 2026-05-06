import 'package:flutter/material.dart';
// Importamos la nueva pantalla de reservas
import 'views/screens/reservas.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barber Shop',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        useMaterial3: true,
        // Configuramos el brillo a claro para que el diseño se vea limpio
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      // Ahora la app arrancará directamente en la pantalla de "Mis Reservas"
      home: const ReservationsScreen(),
    );
  }
}