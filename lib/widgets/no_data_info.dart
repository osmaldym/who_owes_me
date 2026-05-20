import 'package:flutter/material.dart';

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
              text ?? "There's no data to show",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500
              ),
            ),
            if (showMessage)
              Text(
                message ?? "Click the button below to add a new element",
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
