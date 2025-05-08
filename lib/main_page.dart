import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'restaurant_entry.dart';
import 'reviewer_entry.dart';
import 'review_entry.dart';
import 'detail_form.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurant Reviews',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD32F2F),
      ),
      body: Row(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No reviews available',
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  );
                }
                final reviews = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          '${review['reviewer']} - ${review['restaurant']}',
                          style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailForm(review: review),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            width: 150,
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReviewEntry()),
                    );
                  },
                  icon: const Icon(Icons.add, color: Color(0xFFD32F2F)),
                  label: Text(
                    'Add Review',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReviewerEntry()),
                    );
                  },
                  icon: const Icon(Icons.person_add, color: Color(0xFFD32F2F)),
                  label: Text(
                    'Add Reviewer',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RestaurantEntry()),
                    );
                  },
                  icon: const Icon(Icons.restaurant, color: Color(0xFFD32F2F)),
                  label: Text(
                    'Add Restaurant',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}