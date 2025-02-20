import 'package:driver/Locale/locales.dart';
import 'package:driver/Theme/colors.dart';
import 'package:driver/beanmodel/orderhistory.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemInformation extends StatefulWidget{
  const ItemInformation({super.key});

  @override
  ItemInformationState createState() {
    return ItemInformationState();
  }
  
}

class ItemInformationState extends State<ItemInformation>{

  List<ItemsDetails>? orderDetails =[];

  String? appCurrency;

  bool enterFirst = true;

  @override
  void initState() {
    super.initState();
    getSharedValue();
  }

  void getSharedValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appCurrency = prefs.getString('app_currency');
    });

  }
  
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    Map<String, dynamic>? receivedData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if(enterFirst){
      setState(() {
        enterFirst = false;
        orderDetails = receivedData!['details'];
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(locale.itemInfo!,style: TextStyle(
          color: kMainTextColor
        ),),
      ),
      body: (orderDetails!=null && orderDetails!.isNotEmpty)?ListView.separated(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                              '${orderDetails![index].varientImage}',
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${orderDetails![index].productName} (${orderDetails![index].quantity} ${orderDetails![index].unit})',
                              style: TextStyle(
                                fontSize: 16,
                                color: kWhiteColor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${locale.invoice2h} - ${orderDetails![index].qty}',
                              style: TextStyle(
                                fontSize: 13,
                                color: kWhiteColor,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${locale.invoice3h} - $appCurrency ${double.parse((orderDetails![index].price! / orderDetails![index].qty).toString()).round()}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: kWhiteColor,
                                  ),
                                ),
                                Text(
                                  '${locale.invoice4h} ${locale.invoice3h} - $appCurrency ${orderDetails![index].price}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, indext) {
            return const Divider(
              thickness: 0.1,
              color: Colors.transparent,
            );
          },
          itemCount: orderDetails!.length):const SizedBox.shrink(),
    );
  }
  
}