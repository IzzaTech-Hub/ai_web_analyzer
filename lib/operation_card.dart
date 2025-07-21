// import 'package:ai_web_analyzer/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
// import '../models/pdf_models.dart';

class OperationCard extends StatelessWidget {
  final PdfOperation operation;
  final VoidCallback onTap;

  const OperationCard({
    super.key,
    required this.operation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        // borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade700, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade800,
                        // color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(operation.iconName),
                        // color: Theme.of(context).colorScheme.primary,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        operation.name,
                        // style:
                        //     Theme.of(context).textTheme.titleMedium?.copyWith(
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        style: TextStyle(
                            color: Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  operation.description,
                  // style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //       color: Theme.of(context).colorScheme.onSurfaceVariant,
                  //     ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontFamily: 'Roboto',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'info':
        return Icons.info_outline;
      case 'merge':
        return Icons.merge_type;
      case 'split':
        return Icons.call_split;
      case 'extract':
        return Icons.content_cut;
      case 'rotate':
        return Icons.rotate_right;
      case 'compress':
        return Icons.compress;
      case 'convert_word':
        return Icons.description;
      case 'convert_pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.description;
    }
  }
}

class PdfOperation {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String route;

  PdfOperation({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.route,
  });
}
