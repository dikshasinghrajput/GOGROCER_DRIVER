import 'package:driver/beanmodel/orderhistory.dart';
import 'package:driver/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:driver/Components/custom_button.dart';
import 'package:driver/Locale/locales.dart';
import 'package:driver/Routes/routes.dart';

class OrderDeliveredPage extends StatefulWidget {
  const OrderDeliveredPage({super.key});

  @override
  State<OrderDeliveredPage> createState() => _OrderDeliveredPageState();
}

class _OrderDeliveredPageState extends State<OrderDeliveredPage> {
  OrderHistory? orderDetaials;
  bool enterFirst = false;
  bool isLoading = false;
  dynamic apCurency;
  dynamic distance;
  dynamic time;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    final Map<String, dynamic>? dataObject = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (!enterFirst) {
      setState(() {
        enterFirst = true;
        orderDetaials = dataObject!['OrderDetail'] as OrderHistory?;
        distance = dataObject['dis'];
        time = dataObject['time'];
        debugPrint('$distance');
        debugPrint('$time');
      });
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            Image.asset(
              'assets/delivery completed.png',
              scale: 3,
            ),
            const Spacer(),
            Text(locale.deliveredSuccessfully!, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20)),
            const SizedBox(
              height: 6,
            ),
            Text(locale.thankYouForDelivering!),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Row(
                children: [
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(text: '${locale.youDrove!}\n', style: Theme.of(context).textTheme.titleSmall),
                    TextSpan(text: '$time ($distance km)\n', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16, height: 1.7)),
                    TextSpan(
                      text: locale.viewOrderInfo,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor,
                            height: 1.5,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, PageRoutes.orderHistoryPage, arguments: {
                            'OrderDetail': orderDetaials,
                          });
                        },
                    ),
                  ])),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              onTap: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                  return const DeliveryBoyHome();
                }), (Route<dynamic> route) => false);
              },
              label: locale.backToHome,
            ),
          ],
        ),
      ),
    );
  }
}
