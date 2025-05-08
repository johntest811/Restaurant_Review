import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewEntry extends StatefulWidget {
  const ReviewEntry({super.key});

  @override
  State<ReviewEntry> createState() => _ReviewEntryState();
}

class _ReviewEntryState extends State<ReviewEntry> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedRestaurant;
  String? _selectedReviewer;
  int? _rating;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('reviews').add({
          'restaurant': _selectedRestaurant,
          'reviewer': _selectedReviewer,
          'rating': _rating,
          'notes': _notesController.text,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review saved successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving review: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Review',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD32F2F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('restaurants')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const Text('No restaurants available');
                    }
                    final restaurants = snapshot.data!.docs;
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Restaurant',
                        labelStyle: GoogleFonts.roboto(),
                        border: const OutlineInputBorder(),
                      ),
                      value: _selectedRestaurant,
                      items: restaurants
                          .map((doc) => DropdownMenuItem<String>(
                        value: doc['name'] as String,
                        child: Text(doc['name'] as String),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRestaurant = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Please select a restaurant' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('reviewers')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return const Text('No reviewers available');
                    }
                    final reviewers = snapshot.data!.docs;
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Reviewer',
                        labelStyle: GoogleFonts.roboto(),
                        border: const OutlineInputBorder(),
                      ),
                      value: _selectedReviewer,
                      items: reviewers
                          .map((doc) => DropdownMenuItem<String>(
                        value: doc['name'] as String,
                        child: Text(doc['name'] as String),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedReviewer = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Please select a reviewer' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Rating',
                    labelStyle: GoogleFonts.roboto(),
                    border: const OutlineInputBorder(),
                  ),
                  value: _rating,
                  items: [1, 2, 3, 4, 5]
                      .map((rating) => DropdownMenuItem(
                    value: rating,
                    child: Text('$rating Stars'),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a rating' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Review Notes',
                    labelStyle: GoogleFonts.roboto(),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    ElevatedButton(
                      onPressed: _saveReview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.roboto(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}