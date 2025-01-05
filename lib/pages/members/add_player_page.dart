import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepak_bulu_2/dataSources/firestore_collections.dart';
import 'package:nepak_bulu_2/models/player_firestore_model.dart';
import 'package:string_validator/string_validator.dart';

class AddPlayerPage extends StatefulWidget {
  final Function? onSuccessCreated;

  const AddPlayerPage({this.onSuccessCreated, super.key});

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  String? errorMessage;
  bool creating = false;

  Future<bool> isExists() async {
    final get = await playerCollection.doc(name.text).get();
    return get.exists;
  }

  onSubmit() async {
    setState(() {
      creating = true;
    });

    if (!isLength(name.text, 3, 12)) {
      setState(() {
        errorMessage = "Nama panggilan minimal 3 sampai 12 karakter.";
        creating = false;
      });
      return;
    } else if (!isAlpha(name.text)) {
      setState(() {
        errorMessage = "Nama panggilan hanya boleh huruf.";
        creating = false;
      });
      return;
    } else if (await isExists()) {
      setState(() {
        errorMessage = "Nama panggilan sudah ada.";
        creating = false;
      });
      return;
    }

    PlayerFirestoreModel playerFirestoreModel = PlayerFirestoreModel(
      name: name.text,
      presence: true,
      active: true,
      lowPriority: false,
      readonly: false,
      createdAt: DateTime.now(),
      dontMatchWith: [],
    );

    mainDb
        .collection("badminton_players")
        .withConverter<PlayerFirestoreModel>(
          fromFirestore: (snapshot, options) =>
              PlayerFirestoreModel.fromFirestore(
            snapshot.data()!,
            snapshot.reference,
          ),
          toFirestore: (value, options) => value.toFirestore(),
        )
        .doc(name.text)
        .set(playerFirestoreModel);

    setState(() {
      creating = false;
      errorMessage = null;
    });

    if (widget.onSuccessCreated != null) widget.onSuccessCreated!();

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
                const Text(
                  'Sukses!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('Pemain baru berhasil di tambahkan:'),
                Text(
                  name.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  name.clear();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  final TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Peserta"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                children: [
                  Icon(
                    Icons.person_add_rounded,
                    size: 64,
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Daftarkan Pemain Baru",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Silakan isi data pemain dengan benar",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Ketentuan Nama",
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildRequirementItem(
                          context,
                          "Hanya menggunakan huruf (A-Z)",
                          Icons.check_circle_outline,
                        ),
                        const SizedBox(height: 8),
                        _buildRequirementItem(
                          context,
                          "Panjang 3-12 karakter",
                          Icons.check_circle_outline,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: name,
                    inputFormatters: [UpperCaseTextFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Nama Panggilan',
                      hintText: 'Contoh: JOHN',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: !creating ? onSubmit : null,
                    child: creating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Tambah Pemain'),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(
      BuildContext context, String text, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
