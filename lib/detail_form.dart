import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailForm extends StatelessWidget {
  final QueryDocumentSnapshot review;

  const DetailForm({super.key, required this.review});

  Widget _getStarIcons(int rating) {
    return Row(
      children: List.generate(rating, (index) => const Icon(Icons.star, color: Colors.yellow)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review Details',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD32F2F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant: ${review['restaurant']}',
              style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Reviewer: ${review['reviewer']}',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Rating: ${review['rating']} Stars',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            const SizedBox(height: 10),
            _getStarIcons(review['rating']),
            const SizedBox(height: 10),
            Text(
              'Notes: ${review['notes']}',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.roboto(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}