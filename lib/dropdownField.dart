import 'package:flutter/material.dart';

///This is a dropdown field that can take in values for selection
///Can be customized based on stuff provided below

class DropdownField extends StatefulWidget {
  DropdownField(
      {Key? key,
      required this.options,
      this.textColor,
      this.dropdownColor,
      this.fontSize,
      this.dropdownValue})
      : super(key: key);

  ///Options for dropdown
  List<String> options;

  ///Color Scheme text
  Color? textColor;

  ///Font size
  double? fontSize;

  ///Color Scheme dropdown
  Color? dropdownColor;

  ///Initial selected value
  String? dropdownValue;

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  @override
  Widget build(BuildContext context) {
    if (widget.dropdownValue == null)
      widget.dropdownValue = widget.options.first;
    return DropdownButton<String>(
      isExpanded: true,
      value: widget.dropdownValue,
      dropdownColor: widget.dropdownColor,
      icon: Icon(Icons.arrow_downward, color: widget.textColor),
      elevation: 16,
      style: TextStyle(color: widget.textColor, fontSize: widget.fontSize),
      underline: Container(
        height: 1,
        color: widget.textColor,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          widget.dropdownValue = value!;
        });
      },
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, overflow: TextOverflow.fade),
        );
      }).toList(),
    );
  }
}
