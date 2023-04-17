import 'package:flutter/material.dart';

class CheckboxTiles extends StatefulWidget {
  CheckboxTiles({Key? key, required this.tileValues}) : super(key: key);

  List<String>? tileValues;

  List<String> added = <String>[];

  @override
  State<CheckboxTiles> createState() => _CheckboxTilesState();
}

class _CheckboxTilesState extends State<CheckboxTiles> {
  List<bool> checked = <bool>[];
  genTiles() {
    List<Widget> tiles = <Widget>[];
    if(checked.isEmpty){
      for (int i = 0; i < widget.tileValues!.length; i++)
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
            if(value){
              widget.added.add(widget.tileValues![i]);
            } else {
              widget.added.remove(widget.tileValues![i]);
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
