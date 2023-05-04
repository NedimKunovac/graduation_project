import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';

///This file contains two widgets
///First is TagField, which returns a textField that generated Tags under it
///Second is RenderTags, which renders the inputted tags
///Requires that the suggestions be pre-inputted
///Includes profanity check!

class RenderTags extends StatefulWidget {
  RenderTags(
      {Key? key, required this.addedChips, this.chipColor, this.textStyle, this.nChips})
      : super(key: key);

  ///List of added tags
  List<String> addedChips;

  ///Chip background color
  Color? chipColor;

  ///Chip inner text color
  TextStyle? textStyle;

  ///Number of chips to be loaded
  int? nChips;

  @override
  State<RenderTags> createState() => _RenderTagsState();
}

class _RenderTagsState extends State<RenderTags> {
  ///Getter for top fun
  getChipList() {
    int ChipLimit = widget.addedChips.length;

    if(widget.nChips!=null && widget.addedChips.length>widget.nChips!){
      ChipLimit = widget.nChips!;
    }

    List<Widget> chipList = <Widget>[];
    for (var i = 0; i < ChipLimit; i++) {
      chipList.add(
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
          child: Chip(
            label: Text(
              widget.addedChips[i].length<20? widget.addedChips[i].toString() : widget.addedChips[i].replaceRange(20, widget.addedChips[i].length, '...'),
              style: widget.textStyle,
            ),
            backgroundColor: widget.chipColor,
          ),
        ),
      );
    }
    if(widget.nChips!=null && widget.addedChips.length>widget.nChips!){
      chipList.add(
        Padding(
          padding: EdgeInsets.fromLTRB(0, 2, 7, 2),
          child: Chip(
            label: Text(
              "+${widget.addedChips.length-widget.nChips!}",
              style: widget.textStyle,
            ),
            backgroundColor: widget.chipColor,
          ),
        ),
      );
    }

    return chipList;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: getChipList(),
    );
  }
}

///TEMPLATE FOR CHIP OBJECT THAT HOLDS CHIP DATA
class ChipObjectData {
  const ChipObjectData(this.value);

  final String value;
}

///TAGS FIELD WIDGET
///-----------------------------------------------------------------------------
class TagsField extends StatefulWidget {
  TagsField(
      {super.key,
      required this.suggestionsList,
      this.chipColor,
      this.textStyle,
      this.iconColor});

  ///Passed suggestions
  List<String> suggestionsList;

  ///Chip background color
  Color? chipColor;

  ///Chip inner text color
  TextStyle? textStyle;

  ///Icon colors
  Color? iconColor;

  ///List of chip data objects so it can be iterated
  List<ChipObjectData> chipDataList = <ChipObjectData>[];

  ///List of added tags
  List<String> addedChips = <String>[];

  ///List of suggestions
  List<String> suggestions = <String>[];

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  ///Fliter and textfield controller
  final filter = ProfanityFilter();
  late TextEditingController textEditingController;

  ///Function that generates the chip tag widget things
  Iterable<Widget> get actorWidgets {
    return widget.chipDataList.map((ChipObjectData data) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 2, 7, 2),
        child: Chip(
          backgroundColor: widget.chipColor,
          deleteIcon: Icon(Icons.highlight_remove, color: widget.iconColor),
          label: Text(data.value, style: widget.textStyle),
          onDeleted: () {
            setState(() {
              widget.chipDataList.removeWhere((ChipObjectData entry) {
                if (entry.value == data.value) {
                  print('You removed ${entry.value}');
                  widget.addedChips.remove(data.value);
                  widget.suggestions.add(data.value);
                  return true;
                } else {
                  return false;
                }
              });
            });
          },
        ),
      );
    });
  }

  ///Getter for top fun
  getActorWidget() {
    return actorWidgets.toList();
  }

  @override
  Widget build(BuildContext context) {
    ///Pre-load passed tags
    if (widget.suggestions.isEmpty) {
      widget.suggestions = widget.suggestionsList;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Actual form
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return widget.suggestions.where((String option) {
              return option.contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            if (!filter.hasProfanity(selection)) {
              if (!widget.addedChips.contains(selection)) {
                debugPrint('You just selected $selection');
                textEditingController.text = "";
                setState(() {
                  widget.addedChips.add(selection);
                  widget.chipDataList.add(ChipObjectData(selection));
                  widget.suggestions.remove(selection);
                });
              } else {
                textEditingController.text = "";
                print('Chip already exists');
              }
            } else {
              print('What you entered has the following bad words:');
              List<String> wordsFound =
                  filter.getAllProfanity(textEditingController.text);
              print(wordsFound);
              textEditingController.text = "";
            }
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            textEditingController = fieldTextEditingController;
            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      if (textEditingController.text != '') if (!filter
                          .hasProfanity(textEditingController.text)) {
                        if (!widget.addedChips
                            .contains(textEditingController.text)) {
                          debugPrint(
                              'You just selected ${textEditingController.text}');
                          setState(() {
                            widget.addedChips.add(textEditingController.text);
                            widget.chipDataList.add(
                                ChipObjectData(textEditingController.text));
                            widget.suggestions
                                .remove(textEditingController.text);
                            textEditingController.text = "";
                          });
                        } else {
                          textEditingController.text = "";
                          print('Chip already exsists');
                        }
                      } else {
                        print('What you entered has the following bad words:');
                        List<String> wordsFound =
                            filter.getAllProfanity(textEditingController.text);
                        print(wordsFound);
                        textEditingController.text = "";
                      }
                    },
                    icon: Icon(Icons.add)),
              ),
            );
          },
        ),
        Wrap(
          children: getActorWidget(),
        )
      ],
    );
  }
}
