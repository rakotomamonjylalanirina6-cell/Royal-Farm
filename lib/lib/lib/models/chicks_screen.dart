
import 'package:flutter/material.dart';

import '../models/chick.dart';
import '../services/chick_storage_service.dart';

class ChicksScreen extends StatefulWidget {
  const ChicksScreen({super.key});

  @override
  State<ChicksScreen> createState() => _ChicksScreenState();
}

class _ChicksScreenState extends State<ChicksScreen> {
  final ChickStorageService storage = ChickStorageService();

  List<Chick> chicks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadChicks();
  }

  Future<void> loadChicks() async {
    final result = await storage.getChicks();

    if (!mounted) return;

    setState(() {
      chicks = result;
      loading = false;
    });
  }

  Future<void> addChick() async {
    final idController = TextEditingController();
    final fatherController = TextEditingController();
    final motherController = TextEditingController();
    final maleController = TextEditingController(text: '0');
    final femaleController = TextEditingController(text: '0');
    final aliveController = TextEditingController(text: '0');
    final deadController = TextEditingController(text: '0');
    final notesController = TextEditingController();

    DateTime hatchDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: const Text('Hanampy zanak\'akoho'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'ID na laharana',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Daty foy: ${hatchDate.day}/${hatchDate.month}/${hatchDate.year}',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: hatchDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (picked != null) {
                              updateDialog(() {
                                hatchDate = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: fatherController,
                      decoration: const InputDecoration(
                        labelText: 'ID-n\'ny ray',
                      ),
                    ),
                    TextField(
                      controller: motherController,
                      decoration: const InputDecoration(
                        labelText: 'ID-n\'ny reny',
                      ),
                    ),
                    TextField(
                      controller: maleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Isan\'ny lahy',
                      ),
                    ),
                    TextField(
                      controller: femaleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Isan\'ny vavy',
                      ),
                    ),
                    TextField(
                      controller: aliveController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Isan\'ny velona',
                      ),
                    ),
                    TextField(
                      controller: deadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Isan\'ny maty',
                      ),
                    ),
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Fanamarihana',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Hanafoana'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final male = int.tryParse(maleController.text);
                    final female = int.tryParse(femaleController.text);
                    final alive = int.tryParse(aliveController.text);
                    final dead = int.tryParse(deadController.text);

                    if (idController.text.trim().isEmpty ||
                        male == null ||
                        female == null ||
                        alive == null ||
                        dead == null ||
                        male < 0 ||
                        female < 0 ||
                        alive < 0 ||
                        dead < 0 ||
                        alive + dead != male + female) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Hamarino ny ID sy ny isa. Ny velona + maty dia tsy maintsy mitovy amin\'ny lahy + vavy.',
                          ),
                        ),
                      );
                      return;
                    }

                    final chick = Chick(
                      id: idController.text.trim(),
                      hatchDate: hatchDate,
                      fatherId: fatherController.text.trim(),
                      motherId: motherController.text.trim(),
                      maleCount: male,
                      femaleCount: female,
                      aliveCount: alive,
                      deadCount: dead,
                      notes: notesController.text.trim(),
                    );

                    try {
                      await storage.addChick(chick);

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }

                      await loadChicks();
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Efa misy io ID io. Mampiasà ID hafa.',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Tehirizo'),
                ),
              ],
            );
          },
        );
      },
    );

    idController.dispose();
    fatherController.dispose();
    motherController.dispose();
    maleController.dispose();
    femaleController.dispose();
    aliveController.dispose();
    deadController.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAlive = chicks.fold<int>(
      0,
      (sum, item) => sum + item.aliveCount,
    );

    final totalDead = chicks.fold<int>(
      0,
      (sum, item) => sum + item.deadCount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zanak\'akoho'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addChick,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Velona'),
                            Text(
                              '$totalAlive',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Maty'),
                            Text(
                              '$totalDead',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: chicks.isEmpty
                      ? const Center(
                          child: Text(
                            'Tsy mbola misy zanak\'akoho voasoratra.',
                          ),
                        )
                      : ListView.builder(
                          itemCount: chicks.length,
                          itemBuilder: (context, index) {
                            final chick = chicks[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.egg),
                                ),
                                title: Text('ID: ${chick.id}'),
                                subtitle: Text(
                                  'Daty foy: ${chick.hatchDate.day}/${chick.hatchDate.month}/${chick.hatchDate.year}\n'
                                  'Lahy: ${chick.maleCount} | Vavy: ${chick.femaleCount}\n'
                                  'Velona: ${chick.aliveCount} | Maty: ${chick.deadCount}',
                                ),
                                isThreeLine: true,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
