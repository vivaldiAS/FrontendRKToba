import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:rumah_kreatif_toba/utils/app_constants.dart'; // Import AppConstants


class ReviewSection extends StatefulWidget {
  final int productId;

  const ReviewSection({super.key, required this.productId});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  List<dynamic> reviews = [];
  bool isLoading = true;
  int selectedRating = 0; // 0 = Semua
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    final url = '${AppConstants.BASE_URL}reviews/${widget.productId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        double total = 0.0;
        for (var review in data) {
          total += (review['nilai_review'] ?? 0).toDouble();
        }

        setState(() {
          reviews = data;
          averageRating = data.isNotEmpty ? total / data.length : 0.0;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ⭐ Average Rating + Lihat Semua
        // ⭐ Average Rating + Lihat Semua
if (reviews.isNotEmpty) Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Text(
            averageRating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 18, color: Colors.amber),
          const SizedBox(width: 8),
          Text(
            'Penilaian Produk (${reviews.length})',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      if (reviews.length > 2)
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => buildReviewDialog(),
            );
          },
          child: const Text(
            'Lihat Semua >',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
    ],
  ),
),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Review Pembeli',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : reviews.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Belum ada review.'),
                  )
                : Column(
                    children: [
                      ...reviews.take(2).map((review) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person, size: 20),
                                    const SizedBox(width: 8),
                                    Text('User ${review['user_id']}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                RatingBarIndicator(
                                  rating:
                                      (review['nilai_review'] ?? 0).toDouble(),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                ),
                                const SizedBox(height: 8),
                                Text(review['isi_review'] ?? ''),
                              ],
                            ),
                          )),
                      if (reviews.length > 2)
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => buildReviewDialog(),
                            );
                          },
                          child: const Text('Lihat Selengkapnya'),
                        )
                    ],
                  ),
      ],
    );
  }

  Widget buildReviewDialog() {
    return StatefulBuilder(
      builder: (context, setStateDialog) => AlertDialog(
        title: const Text('Semua Review'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Filter bintang
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setStateDialog(() {
                            selectedRating = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: selectedRating == index
                                ? Colors.amber[100]
                                : Colors.grey[200],
                            border: Border.all(
                                color: selectedRating == index
                                    ? Colors.amber
                                    : Colors.grey),
                            borderRadius: BorderRadius.zero,
                          ),
                          child: index == 0
                              ? const Text(
                                  'SEMUA',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    index,
                                    (_) => const Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              // Review list
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: reviews
                      .where((review) =>
                          selectedRating == 0 ||
                          (review['nilai_review']?.toInt() ?? 0) ==
                              selectedRating)
                      .map((review) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person, size: 20),
                                    const SizedBox(width: 8),
                                    Text('User ${review['user_id']}'),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                RatingBarIndicator(
                                  rating:
                                      (review['nilai_review'] ?? 0).toDouble(),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                ),
                                const SizedBox(height: 8),
                                Text(review['isi_review'] ?? ''),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
