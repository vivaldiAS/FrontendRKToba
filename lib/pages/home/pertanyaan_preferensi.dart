import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rumah_kreatif_toba/utils/app_constants.dart';

class PreferensiPage extends StatefulWidget {
  final int userId;
  const PreferensiPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<PreferensiPage> createState() => _PreferensiPageState();
}

class _PreferensiPageState extends State<PreferensiPage> {
  List<dynamic> pertanyaanList = [];
  int currentIndex = 0;
  Map<int, Set<int>> jawaban = {}; // key: pertanyaan_id, value: set opsi_id
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    final prefs = await SharedPreferences.getInstance();
    bool sudahIsi = prefs.getBool('preferensi_${widget.userId}') ?? false;
    if (sudahIsi) {
      Get.offAllNamed('/');
      return;
    }
    await fetchPertanyaan();
  }

  Future<void> fetchPertanyaan() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}kuisioner'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          pertanyaanList = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Gagal memuat pertanyaan (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Terjadi kesalahan: $e';
      });
    }
  }

  Future<void> submitJawaban() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}jawaban'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_id": widget.userId,
          "jawaban": jawaban.entries
              .map((e) => {
            "pertanyaan_id": e.key,
            "opsi_id": e.value.toList(),
          })
              .toList()
        }),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('preferensi_${widget.userId}', true);
        Get.snackbar('Berhasil', 'Preferensi tersimpan');
        Get.offAllNamed('/');
      } else {
        Get.snackbar(
            'Gagal', 'Gagal menyimpan jawaban (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text(error!)),
      );
    }

    final pertanyaan = pertanyaanList[currentIndex];
    final opsi = pertanyaan['opsi'] as List<dynamic>;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentIndex > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      currentIndex--;
                    });
                  },
                ),
              ),
            Text(
              pertanyaan['teks_pertanyaan'],
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Pilih satu atau lebih opsi sesuai preferensi Anda'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: opsi.map((item) {
                  final isSelected =
                      jawaban[pertanyaan['id']]?.contains(item['id']) ?? false;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        jawaban.putIfAbsent(
                            pertanyaan['id'], () => <int>{});
                        if (isSelected) {
                          jawaban[pertanyaan['id']]!.remove(item['id']);
                        } else {
                          jawaban[pertanyaan['id']]!.add(item['id']);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade50 : null,
                        border: Border.all(
                            color:
                            isSelected ? Colors.blue : Colors.black12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          item['teks_opsi'],
                          style: TextStyle(
                              fontSize: 16,
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  if ((jawaban[pertanyaan['id']]?.isEmpty ?? true)) {
                    Get.snackbar('Peringatan',
                        'Pilih minimal satu opsi untuk melanjutkan');
                    return;
                  }
                  if (currentIndex < pertanyaanList.length - 1) {
                    setState(() {
                      currentIndex++;
                    });
                  } else {
                    if (jawaban.length == pertanyaanList.length) {
                      submitJawaban();
                    } else {
                      Get.snackbar(
                          'Peringatan', 'Semua pertanyaan wajib dijawab');
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5C00),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      currentIndex < pertanyaanList.length - 1
                          ? 'Selanjutnya'
                          : 'Kirim Jawaban',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
