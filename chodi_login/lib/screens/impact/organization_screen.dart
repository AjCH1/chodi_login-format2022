import 'package:flutter/material.dart';
import 'package:flutter_chodi_app/screens/impact/impact_screen.dart';
import 'package:flutter_chodi_app/services/firebase_authentication_service.dart';
import 'package:flutter_chodi_app/services/firebase_storage_service.dart';
import 'package:flutter_chodi_app/widget/organization_widget.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/main_view_model.dart';

FirebaseService fbservice = FirebaseService();
Storage storage = Storage();

class OrganizationScreen extends StatelessWidget {
  const OrganizationScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: createOrganizationWidget(),
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
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: Text(
                        "Organization You Support",
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
                                child: snapshot.data[index],
                              );
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
