import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTravelPage extends ConsumerStatefulWidget {
  const CreateTravelPage({super.key});

  @override
  ConsumerState<CreateTravelPage> createState() => _CreateTravelPageState();
}

class _CreateTravelPageState extends ConsumerState<CreateTravelPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSaving = false;

  Future<void> _saveTravelPlan() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try { // Save to firestore database
      await FirebaseFirestore.instance.collection('plans').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'accomodations': [],
        'activities': [],
        'flightDetails': [],
        'notes': [],
        'sharedWith': [],
      });

      if (mounted) {
        Navigator.of(context).pop(); // Return to home page
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving plan: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Create Travel Plan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isSaving 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
            onPressed: _isSaving ? null : _saveTravelPlan,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create from scratch',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {}, // TODO: Implement image picker
              child: DottedBorder(
                color: accent,
                borderType: BorderType.RRect,
                radius: const Radius.circular(16),
                dashPattern: const [8, 4],
                strokeWidth: 2,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: accent, size: 32),
                      const SizedBox(height: 8),
                      Text('Insert image', style: TextStyle(color: accent)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                prefixIcon: Icon(Symbols.text_fields, color: accent),
                hintText: 'Title',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                prefixIcon: Icon(Symbols.text_fields, color: accent),
                hintText: 'Description',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('or', style: TextStyle(color: accent)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Join a friend's travel plan",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {}, // TODO: Implement QR code scanner
                    borderRadius: BorderRadius.circular(40),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: accent,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ask your friend for their QR code!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DottedBorder widget implementation (since not imported by default)
class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final BorderType borderType;
  final Radius radius;
  final List<double> dashPattern;
  final double strokeWidth;

  const DottedBorder({
    required this.child,
    required this.color,
    required this.borderType,
    required this.radius,
    required this.dashPattern,
    required this.strokeWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // For simplicity, just use a Container with a border for now
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: strokeWidth, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(radius),
      ),
      child: child,
    );
  }
}

enum BorderType { RRect }
