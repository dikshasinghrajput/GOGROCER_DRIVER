import 'package:driver/Components/commonwidget.dart';
import 'package:flutter/material.dart';
import 'package:driver/Components/custom_button.dart';
import 'package:driver/Locale/locales.dart';
import 'package:driver/Routes/routes.dart';

class NewDeliveryPage extends StatefulWidget {
  const NewDeliveryPage({super.key});

  @override
  State<NewDeliveryPage> createState() => _NewDeliveryPageState();
}

class _NewDeliveryPageState extends State<NewDeliveryPage> {

  bool acceptDelivery = false;
  bool markAsPicked = false;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(title: Text(locale.newDeliveryTask!),
        automaticallyImplyLeading: false,
        actions: [
          acceptDelivery?buildCircularButton(context,Icons.shopping_basket,locale.orderInfo!):const SizedBox.shrink(),
        ],
        ),
      ),
      body: Stack(
        children: [
          Image.asset('assets/map1.png',fit: BoxFit.fill,),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                ListTile(
                  title: Text(locale.distance!,style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),),
                  subtitle: RichText(text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: '16.5 km ',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.green)),
                      TextSpan(text: '(20 min)',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w300)),
                    ]
                  ),),
                  trailing: acceptDelivery?buildCircularButton(context, Icons.navigation, locale.direction!):null,
                ),
                const Divider(height: 5,),
                  ListTile(
                    leading: const Icon(Icons.location_on,color: Colors.green,),
                    title: Text('Operum Market',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),),
                    subtitle: Text('1024, Hemiltone Street, Union Market, USA',style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),),
                    trailing: acceptDelivery?const Icon(Icons.call,color: Colors.black,size: 18,):null,
                  ),
                  ListTile(
                    leading: const Icon(Icons.navigation,color: Colors.green,),
                    title: Text('Sam Smith',style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),),
                    subtitle: Text('D-32 Deniel Street, Central Residency, USA',style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),),
                  ),
                  CustomButton(
                    onTap: (){
                      Navigator.popAndPushNamed(context, PageRoutes.orderAcceptedPage);
                    },
                    label: locale.acceptDelivery),
              ],),
            ),
          ),
        ],
      ),

    );
  }
}

