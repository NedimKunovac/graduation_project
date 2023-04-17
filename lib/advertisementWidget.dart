import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/advertisementDetailed.dart';
import 'tagField.dart';

/// Advertisement Preview [Small box seen on dashboard]
/// Requires title, description, image link and status[accepted or not]

class Advertisement extends StatefulWidget {
  ///Widget data
  Map<String, dynamic> data;
  bool accepted;
  var userType;

  Advertisement({
    Key? key,
    required this.data,
    required this.accepted,
    required this.userType,
  }) : super(key: key);

  @override
  State<Advertisement> createState() => _AdvertisementState();
}

class _AdvertisementState extends State<Advertisement> {
  ///Makes it so description displayed on dash is limited to cutoffLen number of characters
  descriptionBuilder() {
    var cutoffLen = 200;
    if (widget.data['description'].length <= cutoffLen) {
      return widget.data['description'];
    } else {
      return widget.data['description']
          .replaceRange(cutoffLen, widget.data['description'].length, '...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    /// Widget background color logic
                    if (widget.accepted == true) {
                      return Colors.green;
                    } else {
                      return Colors.blue;
                    }
                  }),
                ),

                ///Navigation logic
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AdvertisementDetailed(data: widget.data, userType: widget.userType))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                widget.data['category'][0],
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.grey.shade200,
                                  fontSize: 10,
                                ),
                              ),
                            ))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 10, 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),

                            ///Image in corner of widget
                            child: Container(
                              height: 70.0,
                              width: 70.0,
                              child:
                                  Image.network(widget.data['profilePhotoUrl']),
                            ),
                          ),
                        ),

                        ///Title in widget
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 13, 10, 10),
                            child: Text(
                              '${widget.data['title']} by ${widget.data['authorName']}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///Description in widget
                    Row(
                      children: [
                        Flexible(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            descriptionBuilder(),
                            textAlign: TextAlign.justify,
                          ),
                        ))
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RenderTags(addedChips:List<String>.from(
                            widget.data['requirements'] as List)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
