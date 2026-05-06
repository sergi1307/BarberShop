import 'package:flutter/material.dart';

class LuxeCutsScreen extends StatelessWidget {
  const LuxeCutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {},
          ),
          title: const Text(
            'LUXE CUTS AD',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), // Un pelín menos de padding ayuda
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Network Overview',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Usamos Flexible/Expanded dentro del Row para evitar overflow horizontal
              Row(
                children: [
                  Expanded(child: _buildStatCard('ACTIVE ADS', '128', Icons.campaign, '+12% hoy', Icons.trending_up, Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('TOTAL REACH', '42.5K', Icons.groups, 'Active analytics', Icons.visibility, Colors.blue)),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Advertiser Directory',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Text(
                      '4 of 32',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildAdvertiserCard('Precision Grooming Co.', 'PREMIUM', 'Oct 23', '4.2%', true, Icons.spa),
              _buildAdvertiserCard('Midnight Chronos', 'LUXURY', 'Dec 23', '2.8%', true, Icons.watch),
              _buildAdvertiserCard('Old Town Distillery', 'LIFESTYLE', 'Jan 24', '--', false, Icons.sports_bar),
              _buildAdvertiserCard('Iron & Oak Gym', 'HEALTH', 'Feb 24', '5.1%', true, Icons.fitness_center),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey[400],
          currentIndex: 2,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Dir'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
            BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Ads'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData bgIcon, String subtitle, IconData subIcon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, 
            style: TextStyle(color: Colors.grey[500], fontSize: 9, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox( // Esto hace que el número se encoja si no cabe
            fit: BoxFit.scaleDown,
            child: Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(subIcon, size: 12, color: iconColor),
              const SizedBox(width: 4),
              Expanded(child: Text(subtitle, style: TextStyle(color: iconColor, fontSize: 9), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertiserCard(String name, String tag, String date, String ctr, bool isActive, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.grey[600], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded( // CLAVE: Esto evita el overflow si el nombre es largo
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text('$tag • $date', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(ctr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(isActive ? 'Active' : 'End', style: TextStyle(fontSize: 10, color: isActive ? Colors.green : Colors.red)),
            ],
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}