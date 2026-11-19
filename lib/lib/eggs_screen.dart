
import 'package:flutter/material.dart';

import '../models/egg_record.dart';
import '../services/egg_storage_service.dart';

class EggsScreen extends StatefulWidget {
  const EggsScreen({super.key});

  @override
  State<EggsScreen> createState() => _EggsScreenState();
}

class _EggsScreenState extends State<EggsScreen> {
  final EggStorageService storage = EggStorageService();

  List<EggRecord> records = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    final result = await storage.getRecords();

    if (!mounted) return;

    setState(() {
      records = result;
      loading = false;
    });
  }

  bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  bool sameWeek(DateTime date, DateTime now) {
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return !date.isBefore(startOfWeek) &&
        date.isBefore(endOfWeek);
  }

  Future<void> addRecord() async {
    final henController = TextEditingController();
    final countController = TextEditingController();
    final notesController = TextEditingController();

    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: const Text('Hanampy atody'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: henController,
                      decoration: const InputDecoration(
                        labelText: 'ID-n\'ny akoho vavy',
                        hintText: 'Ohatra: HEN001',
                      ),
                    ),
                    TextField(
                      controller: countController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Isan\'ny atody',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Daty: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (picked != null) {
                              updateDialog(() {
                                selectedDate = picked;
                              });
                            }
                          },
                        ),
                      ],
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
                    final count = int.tryParse(
                      countController.text.trim(),
                    );

                    if (henController.text.trim().isEmpty ||
                        count == null ||
                        count <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ampidiro ny ID sy isan\'ny atody marina.',
                          ),
                        ),
                      );
                      return;
                    }

                    final record = EggRecord(
                      id: DateTime.now()
                          .microsecondsSinceEpoch
                          .toString(),
                      henId: henController.text.trim(),
                      date: selectedDate,
                      eggCount: count,
                      notes: notesController.text.trim(),
                    );

                    try {
                      await storage.addRecord(record);

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }

                      await loadRecords();
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Tsy voatahiry ny firaketana.',
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

    henController.dispose();
    countController.dispose();
    notesController.dispose();
  }

  int get dailyTotal {
    final now = DateTime.now();

    return records
        .where((r) => sameDay(r.date, now))
        .fold(0, (sum, r) => sum + r.eggCount);
  }

  int get weeklyTotal {
    final now = DateTime.now();

    return records
        .where((r) => sameWeek(r.date, now))
        .fold(0, (sum, r) => sum + r.eggCount);
  }

  int get monthlyTotal {
    final now = DateTime.now();

    return records
        .where((r) =>
            r.date.year == now.year &&
            r.date.month == now.month)
        .fold(0, (sum, r) => sum + r.eggCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Famokarana atody'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addRecord,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.9,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      totalCard('Androany', dailyTotal),
                      totalCard('Herinandro', weeklyTotal),
                      totalCard('Volana', monthlyTotal),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tantaran\'ny famokarana',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: records.isEmpty
                      ? const Center(
                          child: Text(
                            'Tsy mbola misy atody voasoratra.',
                          ),
                        )
                      : ListView.builder(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final record =
                                records[records.length - 1 - index];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.egg),
                                ),
                                title: Text(
                                  'Akoho: ${record.henId}',
                                ),
                                subtitle: Text(
                                  'Daty: ${record.date.day}/${record.date.month}/${record.date.year}\n'
                                  'Atody: ${record.eggCount}\n'
                                  '${record.notes}',
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

  Widget totalCard(String title, int total) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              '$total',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Text('Atody'),
          ],
        ),
      ),
    );
  }
}
