
import 'package:flutter/material.dart';

void main() {
  runApp(const RoyalFarmApp());
}

class RoyalFarmApp extends StatelessWidget {
  const RoyalFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Royal Farm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF276749),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF276749),
        foregroundColor: Colors.white,
        title: const Text(
          'ROYAL FARM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tongasoa eto amin’ny Royal Farm',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Fitantanana sy fanaraha-maso ny fiompiana akoho.'),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  FarmCard(
                    icon: Icons.male,
                    title: 'Akoho lahy',
                  ),
                  FarmCard(
                    icon: Icons.female,
                    title: 'Akohovavy',
                  ),
                  FarmCard(
                    icon: Icons.egg,
                    title: 'Atody',
                  ),
                  FarmCard(
                    icon: Icons.child_care,
                    title: "Zanak'akoho",
                  ),
                  FarmCard(
                    icon: Icons.medical_services,
                    title: 'Fahasalamana',
                  ),
                  FarmCard(
                    icon: Icons.calendar_month,
                    title: 'Kalandrie',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const FarmCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 42, color: const Color(0xFF276749)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
