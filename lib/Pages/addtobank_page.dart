import 'dart:convert';

import 'package:driver/Pages/drawer.dart';
import 'package:driver/baseurl/baseurlg.dart';
import 'package:driver/beanmodel/driverstatus.dart';

import 'package:flutter/material.dart';
import 'package:driver/Components/custom_button.dart';
import 'package:driver/Components/entry_field.dart';
import 'package:driver/Locale/locales.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddToBank extends StatefulWidget {
  const AddToBank({super.key});

  @override
  AddState createState() {
    return AddState();
  }
}

class AddState extends State<AddToBank> {
  var http = Client();
  bool isLoading = false;
  int totalOrder = 0;
  double totalincentives = 0.0;
  dynamic apCurrency;

  TextEditingController upiC = TextEditingController();
  TextEditingController accountC = TextEditingController();
  TextEditingController ifscC = TextEditingController();
  TextEditingController bankC = TextEditingController();
  TextEditingController accountHolderC = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDrierStatus();
  }

  void setMoneyToBank() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.post(driverBankUri, body: {
      'dboy_id': '${prefs.getInt('db_id')}',
      'ac_no': accountC.text,
      'ac_holder': accountHolderC.text,
      'ifsc': ifscC.text,
      'bank_name': bankC.text,
      'upi': upiC.text,
    }).then((value) {
      debugPrint('dv - ${value.body}');
      var js = jsonDecode(value.body);
      if ('${js['status']}' == '1') {
        accountHolderC.clear();
        accountC.clear();
        ifscC.clear();
        upiC.clear();
        bankC.clear();
        totalincentives = 0.0;
      }
      if(!mounted) return;
      ToastContext().init(context);
      Toast.show(js['message'], duration: Toast.lengthShort, gravity: Toast.center);
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e);
    });
  }

  void getDrierStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      apCurrency = prefs.getString('app_currency');
    });
    http.post(driverStatusUri, body: {'dboy_id': '${prefs.getInt('db_id')}'}).then((value) {
      if (value.statusCode == 200) {
        DriverStatus dstatus = DriverStatus.fromJson(jsonDecode(value.body));
        if ('${dstatus.status}' == '1') {
          setState(() {
            int onoff = int.parse('${dstatus.onlineStatus}');
            prefs.setInt('online_status', onoff);
            totalOrder = int.parse('${dstatus.totalOrders}');
            totalincentives = double.parse('${dstatus.remainingIncentive}');
          });
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(locale.sendToBank!),
        centerTitle: true,
      ),
      drawer: const AccountDrawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(text: locale.availableBalance! + '\n'.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondary, height: 2.0)),
                      TextSpan(text: '$apCurrency $totalincentives', style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.primary)),
                    ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Text(
                      locale.bankInfo!.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 15),
                    ),
                  ),
                  EntryField(
                    labelColor: Theme.of(context).disabledColor,
                    textCapitalization: TextCapitalization.words,
                    label: locale.accountHolderName!.toUpperCase(),
                    labelFontSize: 13,
                    readOnly: isLoading,
                    labelFontWeight: FontWeight.w500,
                    controller: accountHolderC,
                  ),
                  EntryField(
                    labelColor: Theme.of(context).disabledColor,
                    labelFontSize: 13,
                    labelFontWeight: FontWeight.w500,
                    textCapitalization: TextCapitalization.words,
                    label: locale.bankName!.toUpperCase(),
                    readOnly: isLoading,
                    controller: bankC,
                  ),
                  EntryField(
                    labelColor: Theme.of(context).disabledColor,
                    labelFontSize: 13,
                    labelFontWeight: FontWeight.w500,
                    textCapitalization: TextCapitalization.none,
                    label: locale.branchCode!.toUpperCase(),
                    readOnly: isLoading,
                    controller: ifscC,
                  ),
                  EntryField(
                    labelColor: Theme.of(context).disabledColor,
                    labelFontSize: 13,
                    labelFontWeight: FontWeight.w500,
                    textCapitalization: TextCapitalization.none,
                    readOnly: isLoading,
                    label: locale.accountNumber!.toUpperCase(),
                    controller: accountC,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: EntryField(
                      labelColor: Theme.of(context).disabledColor,
                      labelFontSize: 13,
                      labelFontWeight: FontWeight.w500,
                      textCapitalization: TextCapitalization.words,
                      label: locale.upilable!.toUpperCase(),
                      controller: upiC,
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: const Align(
                    heightFactor: 40,
                    widthFactor: 40,
                    child: CircularProgressIndicator(),
                  ),
                )
              : CustomButton(
                  label: locale.sendToBank,
                  onTap: () {
                    if (!isLoading) {
                      if (accountC.text.isNotEmpty) {
                        if (accountHolderC.text.isNotEmpty) {
                          if (ifscC.text.isNotEmpty) {
                            if (bankC.text.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              setMoneyToBank();
                            } else {
                              ToastContext().init(context);
                              Toast.show(locale.pleaseallfield!, duration: Toast.lengthShort, gravity: Toast.center);
                            }
                          } else {
                            ToastContext().init(context);
                            Toast.show(locale.pleaseallfield!, duration: Toast.lengthShort, gravity: Toast.center);
                          }
                        } else {
                          ToastContext().init(context);
                          Toast.show(locale.pleaseallfield!, duration: Toast.lengthShort, gravity: Toast.center);
                        }
                      } else {
                        ToastContext().init(context);
                        Toast.show(locale.pleaseallfield!, duration: Toast.lengthShort, gravity: Toast.center);
                      }
                    }
                  },
                ),
        ],
      ),
    );
  }
}
