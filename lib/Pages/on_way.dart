import 'package:driver/Components/commonwidget.dart';
import 'package:driver/Components/custom_button.dart';
import 'package:driver/Locale/locales.dart';
import 'package:driver/Routes/routes.dart';
import 'package:flutter/material.dart';

class OnWayPage extends StatefulWidget {
  const OnWayPage({super.key});

  @override
  State<OnWayPage> createState() => _OnWayPageState();
}

class _OnWayPageState extends State<OnWayPage> {
  bool orderInfo = false;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(locale.newDeliveryTask!),
          automaticallyImplyLeading: false,
          actions: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    orderInfo = orderInfo ? false : true;
                  });
                },
                child: buildCircularButton(context, orderInfo ? Icons.close : Icons.shopping_basket, orderInfo ? locale.close! : locale.orderInfo!)),
          ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/onwaymap.png',
            fit: BoxFit.fill,
            width: 500,
          ),
          orderInfo
              ? Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    title: Text(
                      locale.distance!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
                    ),
                    subtitle: RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(text: '8.5 km ', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.green)),
                        TextSpan(text: '(12 min)', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300)),
                      ]),
                    ),
                    trailing: buildCircularButton(context, Icons.navigation, locale.direction!),
                  ),
                  const Divider(
                    height: 5,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    title: Text(
                      'Operum Market',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '1024, Hemiltone Street, Union Market, USA',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.call,
                      color: Color(0xFF39c526),
                      size: 18,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.navigation,
                      color: Colors.green,
                    ),
                    title: Text(
                      'Sam Smith',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'D-32 Deniel Street, Central Residency, USA',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
                    ),
                    trailing: const Icon(
                      Icons.call,
                      color: Color(0xFF39c526),
                      size: 18,
                    ),
                  ),
                  CustomButton(
                      onTap: () {
                        Navigator.popAndPushNamed(context, PageRoutes.orderDeliveredPage);
                      },
                      label: locale.markAsDelivered),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
