import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/screens/advertisement_details.dart';
import 'package:intl/intl.dart';
import 'tag_field.dart';

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
            decoration: BoxDecoration(
              border: Border.all( color: Colors.blue.shade300),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: InkWell(
                ///Navigation logic
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdvertisementDetailed(
                            data: widget.data, userType: widget.userType))),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [

                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    child: Image.network(
                                        widget.data['profilePhotoUrl']),
                                  ),
                                ),
                              ),

                              ///Title and category in widget
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: Text(
                                        DateFormat.yMMMMd('en_US').format(widget.data['endDate'].toDate()).toString(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    ///Title in widget
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 2, 10, 0),
                                      child: Text(
                                        '${widget.data['title']} by ${widget.data['authorName']}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),

                                    ///Category in widget
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: Text(
                                        widget.data['category'][0],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    ///Description in widget
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: Text(
                                        descriptionBuilder(),
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: RenderTags(
                                  addedChips: List<String>.from(
                                      widget.data['requirements'] as List),
                                  chipColor: Colors.blue.shade300,
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                  nChips: 3,
                                ),
                              ),
                            ],
                          ),
                          // Positioned(
                          //   right: 0,
                          //   top: 0,
                          //   bottom: 0,
                          //   child: Container(
                          //     width: 40,
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: Colors.black,
                          //     ),
                          //     child: Center(
                          //       child: Text(
                          //         '+1',
                          //
                          //         ///Number regarding other skills that are required but arent displayed on the dashboard card. Currently this is UI element only
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 10,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
