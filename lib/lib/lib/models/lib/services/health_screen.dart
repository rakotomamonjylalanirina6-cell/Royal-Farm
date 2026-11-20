
import 'package:flutter/material.dart';
import '../models/health_record.dart';
import '../services/health_storage_service.dart';
import 'screens/health_screen.dart';
class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final HealthStorageService _storage = HealthStorageService();
  List<HealthRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final records = await _storage.getRecords();
    if (!mounted) return;
    setState(() {
      _records = records;
      _loading = false;
    });
  }

  Future<void> _addRecord() async {
    final formKey = GlobalKey<FormState>();
    final birdId = TextEditingController();
    final symptoms = TextEditingController();
    final diagnosis = TextEditingController();
    final medicine = TextEditingController();
    final dosage = TextEditingController();
    final duration = TextEditingController();
    final result = TextEditingController();
    final notes = TextEditingController();

    String type = 'Fitsaboana';
    DateTime date = DateTime.now();
    DateTime? nextDate;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Firaketana vaovao'),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          value: type,
                          decoration: const InputDecoration(
                            labelText: 'Karazana firaketana',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Fitsaboana',
                              child: Text('Fitsaboana'),
                            ),
                            DropdownMenuItem(
                              value: 'Vaksiny',
                              child: Text('Vaksiny'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                type = value;
                                nextDate = null;
                              });
                            }
                          },
                        ),
                        TextFormField(
                          controller: birdId,
                          decoration: const InputDecoration(
                            labelText: 'ID na laharan’ny akoho *',
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? 'Fenoy ny ID'
                                  : null,
                        ),
                        if (type == 'Fitsaboana') ...[
                          TextFormField(
                            controller: symptoms,
                            decoration: const InputDecoration(
                              labelText: 'Soritr’aretina',
                            ),
                          ),
                          TextFormField(
                            controller: diagnosis,
                            decoration: const InputDecoration(
                              labelText: 'Aretina / Diagnostic',
                            ),
                          ),
                        ],
                        TextFormField(
                          controller: medicine,
                          decoration: InputDecoration(
                            labelText: type == 'Vaksiny'
                                ? 'Anaran’ny vaksiny'
                                : 'Anaran’ny fanafody',
                          ),
                        ),
                        TextFormField(
                          controller: dosage,
                          decoration: const InputDecoration(
                            labelText: 'Fatra nomena (araka ny toromarika)',
                          ),
                        ),
                        TextFormField(
                          controller: duration,
                          decoration: const InputDecoration(
                            labelText: 'Faharetana',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Daty nanaovana azy'),
                          subtitle: Text(
                            '${date.day}/${date.month}/${date.year}',
                          ),
                          trailing: const Icon(Icons.calendar_month),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: dialogContext,
                              initialDate: date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setDialogState(() => date = picked);
                            }
                          },
                        ),
                        if (type == 'Vaksiny')
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Daty vaksiny manaraka'),
                            subtitle: Text(
                              nextDate == null
                                  ? 'Tsy mbola voafaritra'
                                  : '${nextDate!.day}/${nextDate!.month}/${nextDate!.year}',
                            ),
                            trailing: const Icon(Icons.event),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: dialogContext,
                                initialDate: nextDate ?? date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setDialogState(() => nextDate = picked);
                              }
                            },
                          ),
                        TextFormField(
                          controller: result,
                          decoration: const InputDecoration(
                            labelText: 'Vokatra / Toetry ny akoho',
                          ),
                        ),
                        TextFormField(
                          controller: notes,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Fanamarihana',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Hiverina'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogContext, true);
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

    if (saved == true) {
      final record = HealthRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        birdId: birdId.text.trim(),
        type: type,
        symptoms: symptoms.text.trim(),
        diagnosis: diagnosis.text.trim(),
        medicine: medicine.text.trim(),
        dosage: dosage.text.trim(),
        duration: duration.text.trim(),
        date: date,
        nextDate: nextDate,
        result: result.text.trim(),
        notes: notes.text.trim(),
      );

      try {
        await _storage.addRecord(record);
        await _loadRecords();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Voatahiry ny firaketana.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tsy voatahiry: $e')),
          );
        }
      }
    }

    birdId.dispose();
    symptoms.dispose();
    diagnosis.dispose();
    medicine.dispose();
    dosage.dispose();
    duration.dispose();
    result.dispose();
    notes.dispose();
  }

  Future<void> _deleteRecord(HealthRecord record) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hamafa firaketana?'),
        content: const Text('Tena hofafana ve ity firaketana ity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tsia'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eny, fafao'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.deleteRecord(record.id);
      await _loadRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fahasalamana sy Vaksiny'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRecord,
        icon: const Icon(Icons.add),
        label: const Text('Firaketana vaovao'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const Center(
                  child: Text('Tsy mbola misy firaketana.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            record.type == 'Vaksiny'
                                ? Icons.vaccines
                                : Icons.medical_services,
                          ),
                        ),
                        title: Text(
                          '${record.type} - ${record.birdId}',
                        ),
                        subtitle: Text(
                          'Daty: ${record.date.day}/${record.date.month}/${record.date.year}\n'
                          '${record.medicine.isEmpty ? '' : 'Fanafody/Vaksiny: ${record.medicine}\n'}'
                          '${record.nextDate == null ? '' : 'Manaraka: ${record.nextDate!.day}/${record.nextDate!.month}/${record.nextDate!.year}'}'
                          '${record.result.isEmpty ? '' : '\nVokatra: ${record.result}'}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _deleteRecord(record),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
