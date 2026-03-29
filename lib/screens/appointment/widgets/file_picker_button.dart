import 'package:flutter/material.dart';

class FilePickerButton extends StatelessWidget {
  final String? selectedFileName;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const FilePickerButton({
    super.key,
    required this.selectedFileName,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFB565A7).withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.attach_file, color: Color(0xFFB565A7), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedFileName ?? 'Attach a file (PDF, JPG, PNG)',
                style: TextStyle(
                  fontSize: 13,
                  color: selectedFileName == null
                      ? Colors.black38
                      : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selectedFileName != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, color: Colors.black38, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
