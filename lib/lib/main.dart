
import 'package:flutter/material.dart';
import 'screens/eggs_screen.dart';
import 'screens/birds_screen.dart';
import 'screens/chicks_screen.dart';

void main() {
  runApp(const RoyalFarmApp());
}

class RoyalFarmApp extends StatelessWidget {
  const RoyalFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Farm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
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
    final menuItems = [
      {
        'title': 'Akoho lahy',
        'icon': Icons.pets,
        'page': 'birds',
      },
      {
        'title': 'Akohovavy',
        'icon': Icons.egg_alt,
        'page': 'birds',
      },
      {
        'title': 'Zanak\'akoho',
        'icon': Icons.egg,
        'page': 'chicks',
      },
      {
        'title': 'Atody',
        'icon': Icons.breakfast_dining,
        'page': 'eggs',
      },
      {else if (page == 'santé') {
  return const HealthScreen();
}
        'title': 'Fahasalamana',
        'icon': Icons.medical_services,
        'page': 'health',
      },
      {
        'title': 'Kalandrie',
        'icon': Icons.calendar_month,
        'page': 'calendar',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROYAL FARM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];

            return Card(
              elevation: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final page = item['page'];

                  if (page == 'birds') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BirdsScreen(),
                      ),
                    );
                  } else if (page == 'chicks') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ChicksScreen(),
    ),
  );
} else if (page == 'eggs') {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const EggsScreen(),
    ),
  );
} else {
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item['title']} mbola eo am-panamboarana.',
                        ),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 42,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
