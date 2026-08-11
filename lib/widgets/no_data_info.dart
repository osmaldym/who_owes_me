import 'package:flutter/material.dart';
import 'package:who_owes_me/l10n/app_localizations.dart';

class NoDataInfo extends StatelessWidget {
  String? text;
  String? message;
  bool showMessage;
  IconData? icon;
  EdgeInsetsGeometry? padding; 

  NoDataInfo({
    super.key,
    this.text,
    this.message,
    this.icon,
    this.showMessage = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: padding ?? const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            CircleAvatar(
              radius: 38,
              child: Icon(icon ?? Icons.money_off, size: 38,),
            ),
            Text(
              text ?? AppLocalizations.of(context)!.theresNoDataToShow,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500
              ),
            ),
            if (showMessage)
              Text(
                message ?? AppLocalizations.of(context)!.clickTheButtomBelowToAddANewElement,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey
                ),
              )
          ],
        ),
      )
    );
  }
}
