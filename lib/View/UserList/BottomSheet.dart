import 'package:flutter/material.dart';

Future<void> showSortBottomSheet(BuildContext context, String selectedOption,
    Function(String) onOptionSelected) async {
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sort',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            RadioListTile<String>(
              title: const Text('All'),
              value: 'all',
              groupValue: selectedOption,
              onChanged: (value) {
                if (value != null) {
                  onOptionSelected(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Age: Elder'),
              value: 'age_elder',
              groupValue: selectedOption,
              onChanged: (value) {
                if (value != null) {
                  onOptionSelected(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Age: Younger'),
              value: 'age_younger',
              groupValue: selectedOption,
              onChanged: (value) {
                if (value != null) {
                  onOptionSelected(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
