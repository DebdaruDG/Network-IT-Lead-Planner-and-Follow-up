import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchableDropdown extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final String label;
  final ValueChanged<String> onChanged;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.label,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  late String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue =
        widget.initialValue ??
        (widget.items.isNotEmpty ? widget.items.first : null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownSearch<String>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                ),
              ),
              menuProps: MenuProps(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            dropdownBuilder:
                (context, selectedItem) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(selectedItem ?? ''),
                ),
            items: (String filter, LoadProps? loadProps) {
              return widget.items
                  .where(
                    (item) => item.toLowerCase().contains(filter.toLowerCase()),
                  )
                  .toList();
            },
            selectedItem: _selectedValue,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedValue = value);
                widget.onChanged(value);
              }
            },
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.8,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.8,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.8,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
