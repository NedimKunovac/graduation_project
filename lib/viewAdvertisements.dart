import 'package:flutter/material.dart';
import 'advertisementWidget.dart';

/// Widget that loads the list of advertisements available on the first page
/// Called by dashboard

class ViewAdvertisements extends StatefulWidget {
  const ViewAdvertisements({Key? key}) : super(key: key);

  @override
  State<ViewAdvertisements> createState() => _ViewAdvertisementsState();
}

class _ViewAdvertisementsState extends State<ViewAdvertisements> {
  ///Widget list that contains advertisements
  List<Widget> availableAdvertisements = <Widget>[
    Text(
      'Your currently available volunteering opportunities:',
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
    ),

    ///TODO: REMOVE THIS PLACEHOLDER LIST, ADD GENERATOR FOR THIS
    Advertisement(
        title: 'OSCE',
        description:
            'The OSCE stands for the Organization for Security and Co-operation in Europe.',
        adImage: Image(image: AssetImage('assetsTesting/guySmiling.jpg')),
        accepted: false),
    Advertisement(
        title: 'The United Nations (UN)',
        description:
            'The United Nations (UN) is an intergovernmental organization whose stated purposes are to maintain international peace and security, develop friendly relations among nations, achieve international cooperation, and be a centre for harmonizing the actions of nations.',
        adImage:
            Image(image: AssetImage('assetsTesting/advertisementIconTest.jpg')),
        accepted: false),
    Advertisement(
        title: 'Red Cross',
        description:
            'The International Committee of the Red Cross (ICRC) ensuring humanitarian protection and assistance for victims of war and other situations of violence.',
        adImage: Image(image: AssetImage('assetsTesting/flutterLogo.jpg')),
        accepted: false),
    Advertisement(
        title: 'AIESEC',
        description:
            'AIESEC is an international youth-run and led, non-governmental and not-for-profit organization that provides young people with leadership development, cross-cultural internships, and global volunteer exchange experiences.',
        adImage: Image(image: AssetImage('assetsTesting/flutterBird.png')),
        accepted: false),
    Advertisement(
        title: 'Sarajevo Film Festival',
        description:
            'The Sarajevo Film Festival is the premier and largest film festival in Southeast Europe, and is one of the largest film festivals in Europe.',
        adImage:
            Image(image: AssetImage('assetsTesting/advertisementIconTest.jpg')),
        accepted: false),
  ];

  @override
  ///Legit just a column widget
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: availableAdvertisements,
        ),
      ),
    );
  }
}
