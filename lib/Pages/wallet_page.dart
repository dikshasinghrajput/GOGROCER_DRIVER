
import 'package:flutter/material.dart';
import 'package:driver/Components/custom_button.dart';
import 'package:driver/Locale/locales.dart';
import 'package:driver/Pages/drawer.dart';
import 'package:driver/Routes/routes.dart';

class WalletCard {
  final String name;
  final String orderDetails;
  final String payment;
  final String earnings;

  WalletCard(this.name, this.orderDetails, this.payment, this.earnings);
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return Scaffold(
      drawer: const AccountDrawer(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/headerr.png',
                height: 180,
                fit: BoxFit.fill,
              ),
              Container(
                color: theme.dividerColor,
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                child: Text(locale.recent!),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 230.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 15,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          buildRowChildWallet(theme, 'Sam Smith',
                              '3 items | 30 June 2018, 11.59 am'),
                          const Spacer(),
                          buildRowChildWallet(theme, '\$80.00', locale.online!,
                              alignment: CrossAxisAlignment.end),
                          const SizedBox(width: 20.0),
                          buildRowChildWallet(theme, '\$6.50', locale.earnings!,
                              alignment: CrossAxisAlignment.end),
                        ],
                      ),
                    ),
                    const Divider(thickness: 6),
                  ],
                );
              },
            ),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 155.0,
            end: 20.0,
            child: CustomButton(
              height: 48,
              color: theme.primaryColor,
              onTap: () => Navigator.pushNamed(context, PageRoutes.addToBank),
              label: locale.sendToBank,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                iconTheme: IconThemeData(color: theme.scaffoldBackgroundColor),
                title: Text(
                  locale.wallet!.toUpperCase(),
                  style: TextStyle(color: theme.scaffoldBackgroundColor),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                child: Text(
                  locale.availableBalance!.toUpperCase(),
                  style: TextStyle(color: theme.scaffoldBackgroundColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '\$ 520.50',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRowChildWallet(ThemeData theme, String text1, String text2,
      {CrossAxisAlignment? alignment}) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: <Widget>[
        Text(text1,
            style: theme.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10.0),
        Text(
          text2,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
