import 'package:flutter/material.dart';
import 'package:driver/Components/custom_button.dart';
import 'package:driver/Components/entry_field.dart';
import 'package:driver/Locale/locales.dart';

class VerificationPage extends StatefulWidget {
  final VoidCallback onVerificationDone;

  const VerificationPage(this.onVerificationDone, {super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.verification!),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Spacer(),
          Text(
            locale.pleaseEnterVerificationCodeSentGivenNumber!,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          EntryField(
            label: '${locale.enterVerificationCode!}\n',
            hint: locale.enterVerificationCode,
          ),
          const Spacer(flex: 5),
          CustomButton(
            onTap: widget.onVerificationDone,
          ),
        ],
      ),
    );
  }
}
