import 'package:flutter/material.dart';

///This widget creates a list of checkboxes based on the given input list

class CheckboxTiles extends StatefulWidget {
  CheckboxTiles({Key? key, required this.tileValues}) : super(key: key);

  ///These are the inputs based on which the list is created
  List<String>? tileValues;

  ///List that shows which values are already added upon load
  List<String>? added = <String>[];

  @override
  State<CheckboxTiles> createState() => _CheckboxTilesState();
}

class _CheckboxTilesState extends State<CheckboxTiles> {
  ///What is checked
  List<bool> checked = <bool>[];

  ///Actual tiles
  List<Widget> tiles = <Widget>[];

  ///Generator that takes into account preselected tiles
  genTiles() {
    if (checked.isEmpty) {
      for (int i = 0; i < widget.tileValues!.length; i++)
        if (widget.added!.isNotEmpty &&
            widget.added!.contains(widget.tileValues![i])) {
          checked.add(true);
        } else
          checked.add(false);
    }

    for (int i = 0; i < widget.tileValues!.length; i++) {
      tiles.add(CheckboxListTile(
        title: Text(widget.tileValues![i]),
        controlAffinity: ListTileControlAffinity.leading,
        value: checked[i],
        onChanged: (bool? value) {
          setState(() {
            checked[i] = value!;
            if (value) {
              widget.added!.add(widget.tileValues![i]);
            } else {
              widget.added!.remove(widget.tileValues![i]);
            }
          });
        },
      ));
    }

    return Column(
      children: tiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return genTiles();
  }
}
