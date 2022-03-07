import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  String assetURL;

  ProfileAvatar({Key? key, required this.assetURL}) : super(key: key);

  List<Widget> organizationAvatars = [];

  //Return a dynamic Row
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Image.asset(assetURL),
      backgroundColor: Colors.transparent,
    );
  }
}
