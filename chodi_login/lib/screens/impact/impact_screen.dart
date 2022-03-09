import 'package:flutter/material.dart';
import 'package:flutter_chodi_app/models/activity.dart';
import 'package:flutter_chodi_app/screens/impact/organization_screen.dart';
import 'package:flutter_chodi_app/screens/impact/performance/performance_screen.dart';
import 'package:flutter_chodi_app/screens/impact/recent_activity_screen.dart';
import 'package:flutter_chodi_app/services/firebase_authentication_service.dart';
import 'package:flutter_chodi_app/services/firebase_storage_service.dart';
import 'package:flutter_chodi_app/services/google_authentication_service/log_out_button.dart';
import 'package:flutter_chodi_app/viewmodel/main_view_model.dart';
import 'package:flutter_chodi_app/widget/organization_widget.dart';
import 'package:flutter_chodi_app/widget/profile_avatar.dart';
import 'package:flutter_chodi_app/widget/recent_activity_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../widget/clock/analog_clock.dart';

FirebaseService fbservice = FirebaseService();
Storage storage = Storage();

class ImpactScreen extends StatefulWidget {
  const ImpactScreen({Key? key}) : super(key: key);

  @override
  State<ImpactScreen> createState() => _ImpactScreenState();
}

//Based off on Firestorage structure
Future<int> _getTotalVolunteerHours() async {
  int totalHours = 0;

  /*
  await fbservice.getUserRecentHistoryData().then((res) => {
        for (var i = 0; i < res.length; i++)
          {
            if (res[i]['action'] == 'volunteer')
              {totalHours += int.parse(res[i]['donated'])}
          }
      });

    */
  return totalHours;
}

//may return double or round the number?
Future<int> _getTotalDonationHours() async {
  int totalDonations = 0;

  /*
  await fbservice.getUserRecentHistoryData().then((res) => {
        for (var i = 0; i < res.length; i++)
          {
            if (res[i]['action'] == 'donation')
              {totalDonations += int.parse(res[i]['donated'])}
          }
      });

    */
  return totalDonations;
}

Future<int> _getTotalParticipatedEvents() async {
  int totalParticipatedEvents = 0;
  /*
  await fbservice
      .getUserRecentHistoryData()
      .then((res) => {totalParticipatedEvents = res.length});
    */
  return totalParticipatedEvents;
}

Future<List<dynamic>> _getSupportedOrganizations([dataField]) async {
  List<dynamic> allOrganizations = [];
  /*
  await fbservice.getUserSupportedOrganizationsData().then((res) => {
        allOrganizations = res,
      });

  for (var i = 0; i < allOrganizations.length; i++) {
    //print(allOrganizations[i]);
  }
  */

  return allOrganizations;
}

//Get list of the user's supported organizations icons
Future<List<dynamic>> _getOrganizationWidget(
  BuildContext context,
) async {
  var avatars = <Widget>[];

//Read data from Firebase Storage to get images

/*
  var organizationImages = await _getSupportedOrganizations('assetURL');

  if (organizationImages.isEmpty) {
    avatars.add(const Text(''));
  } else {
    for (var i = 0; i < organizationImages.length; i++) {
      avatars.add(ProfileAvatar(assetURL: organizationImages[i]));
    }
  }

  avatars.add(GestureDetector(
    onTap: () {
      Provider.of<MainScreenViewModel>(context, listen: false)
          .setWidget(const OrganizationScreen());
    },
    child: SvgPicture.asset(
      "assets/svg/arrow_right.svg",
      width: 15,
      height: 15,
    ),
  ));
  */

  return avatars;
}

Future<List<dynamic>> _getRecentActivityWidget() async {
  var recentActivity = [];
  /*
  var organizationImagesURL = [];

  await fbservice.getUserRecentHistoryData().then((res) async => {
        recentActivity = res,
        await fbservice.getUserSupportedOrganizationsData().then((res2) => {
              for (var i = 0; i < res2.length; i++)
                {for (var k = 0; k < recentActivity.length; k++) {}}
            })
      });
*/
  return recentActivity;
}

//DELETE ********
Future<List<dynamic>> getAllSupportedOrganizations() async {
  var list = [];

  await fbservice
      .getUserSupportedOrganizationsData()
      .then((res) => {list = res});

  return list;
}

Future createOrganizationWidget() async {
  var list = <Widget>[];

  await getAllSupportedOrganizations().then((res) async => {
        for (var i = 0; i < res.length; i++)
          {
            await storage.downloadURL(res[i]['assetURL']).then((res2) => {
                  list.add(OrganizationWidget(
                      img: res2, name: res[i]['organizationName']))
                })
          }
      });

  return list;
}
// DELETE *******

class _ImpactScreenState extends State<ImpactScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  String totalEventsParticipatedIn = '';

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1300),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() => {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var avatars = <Widget>[
      ProfileAvatar(
        assetURL: "assets/images/img_1.png",
      ),
      ProfileAvatar(
        assetURL: "assets/images/img_2.png",
      ),
      ProfileAvatar(
        assetURL: "assets/images/img_3.png",
      ),
      ProfileAvatar(
        assetURL: "assets/images/img_4.png",
      ),
      GestureDetector(
        onTap: () {
          Provider.of<MainScreenViewModel>(context, listen: false)
              .setWidget(const OrganizationScreen());
        },
        child: SvgPicture.asset(
          "assets/svg/arrow_right.svg",
          width: 15,
          height: 15,
        ),
      ),
    ];

    return FutureBuilder(
        future: Future.wait([createOrganizationWidget()]),
        builder: ((BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Scaffold(
                body: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  right: 16),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Hi there",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      AnalogClock(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.black),
                            color: Colors.transparent,
                            shape: BoxShape.circle),
                        width: 100.0,
                        height: 100.0,
                        isLive: true,
                        hourHandColor: Colors.black,
                        minuteHandColor: Colors.black,
                        showSecondHand: true,
                        numberColor: Colors.black87,
                        showNumbers: true,
                        showAllNumbers: true,
                        textScaleFactor: 1.4,
                        showTicks: true,
                        showDigitalClock: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Text(
                          (123 * animation.value).toInt().toString(),
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child:
                            logOutWidget(), //log out function logs people from google and firebase //Text("Volunteer hours donated"),
                      ),
                      // '\$${h}',
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "\$${(123 * animation.value).toInt().toString()}",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text("Volunteer dollars donated"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 26),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Text("Organizations You Support"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: avatars),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22, bottom: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Text("Recent Activity"),
                        ),
                      ),
                      RecentActivityWidget(
                          activity: Activity("assets/images/img_1.png",
                              "Autism Speaks", "3 hours", "Oct 25, 2021")),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: RecentActivityWidget(
                            activity: Activity("assets/images/img_2.png",
                                "World Concern", "3 hours", "Oct 25, 2021")),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<MainScreenViewModel>(this.context,
                                    listen: false)
                                .setWidget(const RecentActivityScreen());
                          },
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Text("More",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0000FF))),
                              ),
                              SvgPicture.asset(
                                "assets/svg/arrow_right.svg",
                                width: 13,
                                height: 13,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            const Text(
                              "What you’ve done",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Expanded(child: SizedBox()),
                            GestureDetector(
                                onTap: () {
                                  Provider.of<MainScreenViewModel>(this.context,
                                          listen: false)
                                      .setWidget(const PerformanceScreen());
                                },
                                child: const Text(
                                  "See Performance",
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF0000FF)),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            const Text("Donated"),
                            const Expanded(child: SizedBox()),
                            Text(
                              "\$${(123 * animation.value).toInt().toString()}",
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          children: [
                            const Text("Participated Event"),
                            const Expanded(child: SizedBox()),
                            Text(123.toString())
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
          }
        }));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


            /*
            return Scaffold(
                body: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  right: 16),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Hi there",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      AnalogClock(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.black),
                            color: Colors.transparent,
                            shape: BoxShape.circle),
                        width: 100.0,
                        height: 100.0,
                        isLive: true,
                        hourHandColor: Colors.black,
                        minuteHandColor: Colors.black,
                        showSecondHand: true,
                        numberColor: Colors.black87,
                        showNumbers: true,
                        showAllNumbers: true,
                        textScaleFactor: 1.4,
                        showTicks: true,
                        showDigitalClock: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Text(
                          (snapshot.data[0] * animation.value)
                              .toInt()
                              .toString(),
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child:
                            logOutWidget(), //log out function logs people from google and firebase //Text("Volunteer hours donated"),
                      ),
                      // '\$${h}',
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "\$${(snapshot.data[1] * animation.value).toInt().toString()}",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text("Volunteer dollars donated"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 26),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Text("Organizations You Support"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: snapshot.data[3]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22, bottom: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Text("Recent Activity"),
                        ),
                      ),
                      RecentActivityWidget(
                          activity: Activity("assets/images/img_1.png",
                              "Autism Speaks", "3 hours", "Oct 25, 2021")),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: RecentActivityWidget(
                            activity: Activity("assets/images/img_2.png",
                                "World Concern", "3 hours", "Oct 25, 2021")),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<MainScreenViewModel>(this.context,
                                    listen: false)
                                .setWidget(const RecentActivityScreen());
                          },
                          child: Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Text("More",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0000FF))),
                              ),
                              SvgPicture.asset(
                                "assets/svg/arrow_right.svg",
                                width: 13,
                                height: 13,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            const Text(
                              "What you’ve done",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Expanded(child: SizedBox()),
                            GestureDetector(
                                onTap: () {
                                  Provider.of<MainScreenViewModel>(this.context,
                                          listen: false)
                                      .setWidget(const PerformanceScreen());
                                },
                                child: const Text(
                                  "See Performance",
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF0000FF)),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            const Text("Donated"),
                            const Expanded(child: SizedBox()),
                            Text(
                              "\$${(snapshot.data[1] * animation.value).toInt().toString()}",
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          children: [
                            const Text("Participated Event"),
                            const Expanded(child: SizedBox()),
                            Text(snapshot.data[2].toString())
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )); */