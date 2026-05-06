import 'package:flutter/material.dart';
// Asegúrate de que este nombre coincida con tu archivo de reservas
import 'reservas.dart'; 

class LuxeCutsScreen extends StatelessWidget {
  const LuxeCutsScreen({super.key});

  final List<Map<String, dynamic>> adsData = const [
    {
      'name': 'Modern Tech Gadgets',
      'desc': 'Discover the latest in minimalist technology and home automation solutions.',
      'image': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80',
      'tag': 'TECHNOLOGY',
      'active': true,
    },
    {
      'name': 'Urban Barber Essentials',
      'desc': 'The best pomades and razors for the modern gentleman. Professional quality.',
      'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=800&q=80',
      'tag': 'FASHION',
      'active': true,
    },
    {
      'name': 'Mountain Coffee Roasters',
      'desc': 'Organic beans roasted at high altitude for a unique and bold flavor profile.',
      'image': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
      'tag': 'FOOD & BEV',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Center(
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
            ),
          ),
          title: const Text(
            'LUXE CUTS AD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Featured Ads',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              
              Column(
                children: adsData.map((ad) => _buildFeaturedCard(ad)).toList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[400],
          currentIndex: 2, // Mantenemos seleccionado el icono de Ads (índice 2)
          onTap: (index) {
            // Si el usuario pulsa el índice 0 (Reservas), volvemos atrás
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReservationsScreen()),
              );
            }
          },
          items: const [
            // Hemos actualizado los iconos para que sean iguales en ambas pantallas
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Reservas'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Locales'),
            BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Ads'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> ad) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            ad['image'],
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ad['tag'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: ad['active'] ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  ad['name'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  ad['desc'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}