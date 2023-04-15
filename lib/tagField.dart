import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';

///This widget returns a text field where the user can enter tags
///Requires that the suggestions be pre-inputted
///Includes profanity check!

class RenderTags extends StatefulWidget {
  RenderTags({Key? key, required this.addedChips}) : super(key: key);

  ///List of added tags
  List<String> addedChips;

  @override
  State<RenderTags> createState() => _RenderTagsState();
}

class _RenderTagsState extends State<RenderTags> {
  ///Getter for top fun
  getChipList() {
    List<Widget> chipList = <Widget>[];
    for (var i = 0; i < widget.addedChips.length; i++) {
      chipList.add(
        Chip(label: Text(widget.addedChips[i].toString())),
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
  TagsField({
    super.key,
    required this.suggestionsList,
  });

  ///Passed suggestions
  List<String> suggestionsList;

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
      return Chip(
        label: Text(data.value),
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
      children: [
        ///Acutal form
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
