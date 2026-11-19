
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<String?> savePhoto(XFile image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final extension = image.name.contains('.')
          ? image.name.substring(image.name.lastIndexOf('.'))
          : '.jpg';

      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}$extension';

      final savedImage = await File(image.path).copy(
        '${directory.path}/$fileName',
      );

      return savedImage.path;
    } catch (e) {
      return null;
    }
  }

  Future<void> addBird() async {
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final breedController = TextEditingController();
    final fatherController = TextEditingController();
    final motherController = TextEditingController();
    final notesController = TextEditingController();

    String gender = 'Lahy';
    String photoPath = '';
    DateTime birthDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, updateDialog) {
            return AlertDialog(
              title: const Text('Hanampy akoho vaovao'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'ID na laharan\'ny akoho',
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Anaran\'ny akoho',
                      ),
                    ),
                    TextField(
                      controller: breedController,
                      decoration: const InputDecoration(
                        labelText: 'Karazana (Race)',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: gender,
                      decoration: const InputDecoration(
                        labelText: 'Lahy sa vavy',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Lahy',
                          child: Text('Lahy'),
                        ),
                        DropdownMenuItem(
                          value: 'Vavy',
                          child: Text('Vavy'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          updateDialog(() {
                            gender = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Daty nahaterahana: ${birthDate.day}/${birthDate.month}/${birthDate.year}',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: birthDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );

                            if (picked != null) {
                              updateDialog(() {
                                birthDate = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: fatherController,
                      decoration: const InputDecoration(
                        labelText: 'ID na anaran\'ny ray',
                      ),
                    ),
                    TextField(
                      controller: motherController,
                      decoration: const InputDecoration(
                        labelText: 'ID na anaran\'ny reny',
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (photoPath.isNotEmpty)
                      Image.file(
                        File(photoPath),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Misafidy sary'),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                        );

                        if (image != null) {
                          final savedPath = await savePhoto(image);

                          if (savedPath != null) {
                            updateDialog(() {
                              photoPath = savedPath;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tsy voatahiry ny sary.'),
                              ),
                            );
                          }
                        }
                      },
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
                      fatherId: fatherController.text.trim(),
                      motherId: motherController.text.trim(),
                      photoPath: photoPath,
                      notes: notesController.text.trim(),
                    );

                    await storage.addBird(bird);

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }

                    await loadBirds();
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
    nameController.dispose();
    breedController.dispose();
    fatherController.dispose();
    motherController.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitantanana akoho'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBird,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : birds.isEmpty
              ? const Center(
                  child: Text('Tsy mbola misy akoho voasoratra.'),
                )
              : ListView.builder(
                  itemCount: birds.length,
                  itemBuilder: (context, index) {
                    final bird = birds[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              bird.photoPath.isNotEmpty &&
                                      File(bird.photoPath).existsSync()
                                  ? FileImage(File(bird.photoPath))
                                  : null,
                          child: bird.photoPath.isEmpty ||
                                  !File(bird.photoPath).existsSync()
                              ? const Icon(Icons.pets)
                              : null,
                        ),
                        title: Text(bird.name),
                        subtitle: Text(
                          'ID: ${bird.id}\n'
                          'Race: ${bird.breed}\n'
                          'Lahy/Vavy: ${bird.gender}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }
}
