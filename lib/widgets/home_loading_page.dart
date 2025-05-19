import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeLoadingPage extends StatelessWidget {
  const HomeLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Skeletonizer(
        enabled: true,
        child: Column(
          spacing: 8.0,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(5, (index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Container(
                      width: 130,
                      height: 170,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: 100,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 14,
                            width: 140,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 14,
                            width: 180,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 14,
                            width: 120,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
