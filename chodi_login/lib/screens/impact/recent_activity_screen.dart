import 'package:flutter/material.dart';
import 'package:flutter_chodi_app/screens/impact/impact_screen.dart';
import 'package:flutter_chodi_app/widget/recent_activity_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/activity.dart';
import '../../viewmodel/main_view_model.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({Key? key}) : super(key: key);
  Future<List<dynamic>> getHistory() async {
    var list = [];

    await fbservice.getUserRecentHistoryData().then((res) => {list = res});

    return list;
  }

  Future createRecentActivityWidget() async {
    var list = <Widget>[];
    String activityResults = '';
    String date = '';

    //retrieve data and hours/minutes from firebase
    await getHistory().then((res) async => {
          for (var i = 0; i < res.length; i++)
            {
              await storage.downloadURL(res[i]['assetURL']).then((url) => {
                    date = DateFormat.yMMMd().format(res[i]['date'].toDate()),
                    if (res[i]['action'] == 'volunteer')
                      {
                        if (int.parse(res[i]['donated']) < 1)
                          activityResults = res[i]['donated'] + ' minutes'
                        else
                          activityResults = res[i]['donated'] + ' hours',
                      }
                    else if (res[i]['action'] == 'donation')
                      activityResults = res[i]['donated'] + ' dollars',
                    list.add(RecentActivityWidget(
                        activity: Activity("assets/images/img_1.png",
                            res[i]['organizationName'], activityResults, date)))
                  })
            }
        });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    list.add(RecentActivityWidget(
        activity: Activity("assets/images/img_1.png", "Autism Speaks",
            "3 hours", "Oct 25, 2021")));

    list.add(RecentActivityWidget(
        activity: Activity("assets/images/img_2.png", "World Concern",
            "3 hours", "Oct 25, 2021")));

    return FutureBuilder(
        future: createRecentActivityWidget(),
        builder: ((context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Image.asset(
                      "assets/images/back.png",
                      height: 40,
                      width: 40,
                      fit: BoxFit.fill,
                    ),
                    onTap: () {
                      Provider.of<MainScreenViewModel>(context, listen: false)
                          .setWidget(const ImpactScreen());
                    },
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        "Recent Activity",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, left: 3, right: 3),
                                  child: snapshot.data[index]);
                            },
                            itemCount: snapshot.data.length,
                          )))
                ],
              ),
            );
          }
        }));
  }
}
