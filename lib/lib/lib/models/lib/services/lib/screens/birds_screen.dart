
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/bird.dart';
import '../services/storage_service.dart';

class BirdsScreen extends StatefulWidget {
  const BirdsScreen({super.key});

  @override
  State<BirdsScreen> createState() => _BirdsScreenState();
}

class _BirdsScreenState extends State<BirdsScreen> {
  final StorageService storage = StorageService();
  List<Bird> birds = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBirds();
  }

  Future<void> loadBirds() async {
    final result = await storage.getBirds();
    if (!mounted) return;
    setState(() {
      birds = result;
      loading = false;
    });
  }

  Future<void> addBird() async {
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    final idController = TextEditingController();
    final notesController = TextEditingController();

    String gender = 'Lahy';
    DateTime birthDate = DateTime.now();
    String photoPath = '';

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: const Text('Manampy akoho vaovao'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Laharana / ID',
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Anarana',
                      ),
                    ),
                    TextField(
                      controller: breedController,
                      decoration: const InputDecoration(
                        labelText: 'Karazana / Race',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: const InputDecoration(
                        labelText: 'Sokajy',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Lahy',
                          child: Text('Akoho lahy'),
                        ),
                        DropdownMenuItem(
                          value: 'Vavy',
                          child: Text('Akohovavy'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          updateDialog(() => gender = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Misafidy sary'),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (image != null) {
                          updateDialog(() {
                            photoPath = image.path;
                          });
                        }
                      },
                    ),
                    if (photoPath.isNotEmpty)
                      const Text('Voafidy ny sary'),
                    TextField(
                      controller: notesController,
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
                    if (idController.text.trim().isEmpty ||
                        nameController.text.trim().isEmpty) {
                      return;
                    }

                    final bird = Bird(
                      id: idController.text.trim(),
                      name: nameController.text.trim(),
                      breed: breedController.text.trim(),
                      gender: gender,
                      birthDate: birthDate,
                      entryDate: DateTime.now(),
                      photoPath: photoPath,
                      notes: notesController.text.trim(),
                    );

                    await storage.addBird(bird);

                    if (!dialogContext.mounted) return;
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Tehirizo'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    breedController.dispose();
    idController.dispose();
    notesController.dispose();

    await loadBirds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitantanana akoho'),
        backgroundColor: const Color(0xFF276749),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBird,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : birds.isEmpty
              ? const Center(
                  child: Text('Mbola tsy misy akoho voasoratra.'),
                )
              : ListView.builder(
                  itemCount: birds.length,
                  itemBuilder: (context, index) {
                    final bird = birds[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.flutter_dash),
                        ),
                        title: Text(bird.name),
                        subtitle: Text(
                          '${bird.id} • ${bird.breed} • ${bird.gender}',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
