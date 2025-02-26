import 'dart:convert';

import 'package:driver/Locale/locales.dart';
import 'package:driver/Pages/drawer.dart';
import 'package:driver/Pages/home_page.dart';
import 'package:driver/Theme/colors.dart';
import 'package:driver/baseurl/baseurlg.dart';
import 'package:driver/beanmodel/completedorderhistory.dart';
import 'package:driver/beanmodel/driverstatus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class InsightPage extends StatelessWidget {
  const InsightPage({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: const AccountDrawer(),
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(locale.insight!.toUpperCase()),
        centerTitle: true,
        titleSpacing: 0.0,
      ),
      body: const Insight(),
    );
  }
}

class Insight extends StatefulWidget {
  const Insight({super.key});

  @override
  InsightState createState() {
    return InsightState();
  }
}

class InsightState extends State<Insight> {
  var http = Client();
  bool isLoading = false;
  List<OrderHistoryCompleted> newOrders = [];
  int totalOrder = 0;
  double totalincentives = 0.0;
  dynamic apCurrency;

  void getOrderHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      apCurrency = prefs.getString('app_currency');
    });
    http.post(completedOrdersUrl, body: {'dboy_id': '${prefs.getInt('db_id')}'}).then((value) {
      if (jsonDecode(value.body) != '[{"order_details":"no orders found"}]') {
        var js = jsonDecode(value.body) as List?;
        if (js != null && js.isNotEmpty) {
          newOrders.clear();
          newOrders = js.map((e) => OrderHistoryCompleted.fromJson(e)).toList();
        }
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

  @override
  void initState() {
    super.initState();
    getOrderHistory();
    getDrierStatus();
  }

  @override
  void dispose() {
    http.close();
    super.dispose();
  }

  void getDrierStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.post(driverStatusUri, body: {'dboy_id': '${prefs.getInt('db_id')}'}).then((value) {
      if (value.statusCode == 200) {
        DriverStatus dstatus = DriverStatus.fromJson(jsonDecode(value.body));
        if ('${dstatus.status}' == '1') {
          int onoff = int.parse('${dstatus.onlineStatus}');
          prefs.setInt('online_status', onoff);
          totalOrder = int.parse('${dstatus.totalOrders}');
          totalincentives = double.parse('${dstatus.totalIncentive}');
        }
      }
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const Divider(thickness: 6.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildRowChild(theme, '$totalOrder', locale.orders!),
                buildRowChild(theme, '$apCurrency $totalincentives', locale.earnings!),
              ],
            ),
          ),
          const Divider(thickness: 6),
          (!isLoading)
              ? (newOrders.isNotEmpty)
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      shrinkWrap: true,
                      itemCount: newOrders.length,
                      itemBuilder: (context, index) {
                        return buildTransactionCard(context, newOrders[index]);
                      })
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      alignment: Alignment.center,
                      child: Text(locale.nohistoryfound!),
                    )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return buildTransactionSHCard();
                  })
        ],
      ),
    );
  }

  Container buildTransactionCard(BuildContext context, OrderHistoryCompleted newOrder) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.titleMedium, children: <TextSpan>[
                TextSpan(text: '${newOrder.userName}\n'),
                TextSpan(text: '${locale.deliveryDate!} ${newOrder.deliveryDate}\n\n', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12, height: 1.3)),
                TextSpan(text: '${locale.orderID!} ', style: Theme.of(context).textTheme.titleSmall!.copyWith(height: 0.5)),
                TextSpan(text: '#${newOrder.cartId}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0.5, fontWeight: FontWeight.w500)),
              ])),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Text(
              '\n\n$apCurrency ${newOrder.remainingPrice!.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: '${newOrder.orderStatus}'.toUpperCase() == 'Completed'.toUpperCase() ? Theme.of(context).colorScheme.onSecondaryContainer : kRedColor, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionSHCard() {
    return Shimmer(
      duration: const Duration(seconds: 3),
      color: Colors.white,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 70,
                      width: 70,
                      color: Colors.grey[300],
                    )),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
