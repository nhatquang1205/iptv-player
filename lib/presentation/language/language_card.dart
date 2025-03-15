import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String localeCode;
  final String languageName;
  final String flagAsset;
  final String? selectedLocale;
  final Function(String) onLocaleSelected;

  const LanguageSelector({
    super.key,
    required this.localeCode,
    required this.languageName,
    required this.flagAsset,
    required this.selectedLocale,
    required this.onLocaleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          onLocaleSelected(localeCode);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                flagAsset,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Text(languageName),
              const Spacer(),
              Radio(
                value: localeCode,
                groupValue: selectedLocale,
                onChanged: (value) {
                  onLocaleSelected(value!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
