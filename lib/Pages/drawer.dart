import 'dart:convert';

import 'package:driver/Locale/locales.dart';
import 'package:driver/Routes/routes.dart';
import 'package:driver/Theme/colors.dart';
import 'package:driver/baseurl/baseurlg.dart';
import 'package:driver/beanmodel/appinfo.dart';
import 'package:driver/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDrawer extends StatelessWidget {

  const AccountDrawer({super.key});

  Future getSharedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('boy_name');
  }

  void hitAppInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var http = Client();
    http.post(appInfoUri, body: {'user_id': ''}).then((value) {
      debugPrint(value.body);
      if (value.statusCode == 200) {
        AppInfoModel data1 = AppInfoModel.fromJson(jsonDecode(value.body));
        if (data1.status == "1" || data1.status == 1) {
          prefs.setString('app_currency', '${data1.currencySign}');
          prefs.setString('app_referaltext', '${data1.refertext}');
          prefs.setString('numberlimit', '${data1.phoneNumberLength}');
          prefs.setString('imagebaseurl', '${data1.imageUrl}');
          getImageBaseUrl();
        }
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/menubg.png',
          ),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      hitAppInfo();
                    }
                    return Text('${locale.hey!}, ${snapshot.data}', style: const TextStyle(color: Colors.white, fontSize: 22,));
                  },
                  future: getSharedValue(),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  buildListTile(context, Icons.home, locale.home!, () => Navigator.popAndPushNamed(context, PageRoutes.homePage)),
                  buildListTile(context, Icons.account_box, locale.myAccount!, () => Navigator.popAndPushNamed(context, PageRoutes.editProfilePage)),
                  buildListTile(context, Icons.insert_chart, locale.insight!, () => Navigator.popAndPushNamed(context, PageRoutes.insightPage)),
                  buildListTile(context, Icons.food_bank_sharp, locale.sendToBank!, () => Navigator.popAndPushNamed(context, PageRoutes.addToBank)),
                  buildListTile(context, Icons.notifications_active, locale.notifications!, () => Navigator.popAndPushNamed(context, PageRoutes.notificationList)),
                  buildListTile(context, Icons.view_list, locale.aboutUs!, () => Navigator.popAndPushNamed(context, PageRoutes.aboutus)),
                  buildListTile(context, Icons.admin_panel_settings_rounded, locale.tnc!, () => Navigator.popAndPushNamed(context, PageRoutes.tnc)),
                  buildListTile(context, Icons.chat, locale.helpCenter!, () => Navigator.popAndPushNamed(context, PageRoutes.contactUs)),
                  buildListTile(context, Icons.language, locale.language!, () => Navigator.popAndPushNamed(context, PageRoutes.languagePage)),
                  const LogoutTile(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(BuildContext context, IconData icon, String text, Function onTap) {
    var theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text.toUpperCase(), style: theme.textTheme.titleLarge!.copyWith(fontSize: 18, letterSpacing: 0.8).copyWith(color: Colors.white)),
      onTap: onTap as void Function()?,
    );
  }
}

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return ListTile(
      leading: const Icon(Icons.exit_to_app, color: Colors.white),
      title: Text(locale.logout!.toUpperCase(), style: theme.textTheme.titleLarge!.copyWith(fontSize: 18, letterSpacing: 0.8).copyWith(color: Colors.white)),
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Logging out'),
                content: const Text('Are you sure?'),
                actions: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      backgroundColor: WidgetStateProperty.all(Colors.transparent),
                      foregroundColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Text(
                      'No',
                      style: TextStyle(color: kMainColor),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        shadowColor: WidgetStateProperty.all(Colors.transparent),
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                        foregroundColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: kMainColor),
                      ),
                      onPressed: () async {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.clear().then((value) {
                          if (value) {
                            if(!context.mounted) return;
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                              return const DeliveryBoyLogin();
                            }), (Route<dynamic> route) => false);
                          }
                        });
                      })
                ],
              );
            });
      },
    );
  }
}
