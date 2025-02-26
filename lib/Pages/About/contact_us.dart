import 'dart:convert';

import 'package:driver/Components/custom_button.dart';
import 'package:driver/Components/entry_field.dart';
import 'package:driver/Locale/locales.dart';
import 'package:driver/Pages/drawer.dart';
import 'package:driver/Theme/colors.dart';
import 'package:driver/Theme/style.dart';
import 'package:driver/baseurl/baseurlg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController numberC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController messageC = TextEditingController();
  String? userName;
  String? userNumber;
  int numberLimit = 1;
  bool? isLogin = false;

  bool isLoading = false;

  var http = Client();

  @override
  void initState() {
    getProfileDetails();
    super.initState();
  }

  void getProfileDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isLogin = preferences.getBool('islogin');
      userName = preferences.getString('boy_name');
      userNumber = preferences.getString('boy_phone');
      numberLimit = int.parse('${preferences.getString('numberlimit')}');
      nameC.text = '$userName';
      numberC.text = '$userNumber';
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: const AccountDrawer(),
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          locale.contactUs!,
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/icon.png',
                scale: 2.5,
                height: 280,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      locale.callBackReq2!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shadowColor: WidgetStateProperty.all(primaryColor),
                        overlayColor: WidgetStateProperty.all(primaryColor),
                        backgroundColor: WidgetStateProperty.all(primaryColor),
                        foregroundColor: WidgetStateProperty.all(primaryColor),
                      ),
                      onPressed: () {
                        if (!isLoading) {
                          setState(() {
                            isLoading = true;
                          });
                          sendCallBackRequest(context);
                        }
                      },
                      child: Text(
                        locale.callBackReq1!,
                        style: TextStyle(color: kMainTextColor),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
                child: Text(
                  locale.or!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                child: Text(
                  locale.letUsKnowYourFeedbackQueriesIssueRegardingAppFeatures!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 17),
                ),
              ),
              const Divider(
                thickness: 3.5,
                color: Colors.transparent,
              ),
              EntryField(labelFontSize: 16, controller: nameC, labelFontWeight: FontWeight.w400, label: locale.fullName),
              EntryField(controller: numberC, labelFontSize: 16, maxLength: numberLimit, readOnly: true, labelFontWeight: FontWeight.w400, label: locale.phoneNumber),
              EntryField(hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: kHintColor, fontSize: 18.3, fontWeight: FontWeight.w400), hint: locale.enterYourMessage, controller: messageC, labelFontSize: 16, labelFontWeight: FontWeight.w400, label: locale.yourFeedback),
              const Divider(
                thickness: 3.5,
                color: Colors.transparent,
              ),
              isLoading
                  ? SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: const Align(
                        widthFactor: 40,
                        heightFactor: 40,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CustomButton(
                      label: locale.submit,
                      onTap: () {
                        if (!isLoading) {
                          setState(() {
                            isLoading = true;
                          });
                          sendFeedBack(messageC.text);
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  void sendFeedBack(dynamic message) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    http.post(driverFeedbackUrl, body: {'dboy_id': '${preferences.getInt('db_id')}', 'feedback': '$message'}).then((value) {
      debugPrint('ddv - ${value.body}');
      if (value.statusCode == 200) {
        var js = jsonDecode(value.body);
        if ('${js['status']}' == '1') {
          messageC.clear();
        }
        if(!mounted) return;
        ToastContext().init(context);
        Toast.show(js['message'], duration: Toast.lengthShort, gravity: Toast.center);
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void sendCallBackRequest(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    http.post(driverCallbackReqUrl, body: {
      'driver_id': '${preferences.getInt('db_id')}',
    }).then((value) {
      debugPrint('ddv - ${value.body}');
      if (value.statusCode == 200) {
        var js = jsonDecode(value.body);
        if(!context.mounted) return;
        ToastContext().init(context);
        Toast.show(js['message'], duration: Toast.lengthShort, gravity: Toast.center);
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }
}
