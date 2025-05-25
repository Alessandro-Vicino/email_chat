import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String text;
  final String? route;
  final EdgeInsets padding;
  final VoidCallback? onPressed; // Aggiunto parametro onPressed

  const RoundedButton({
    Key? key,
    required this.color,
    required this.text,
    this.route,
    this.onPressed, // Reso opzionale
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed ??
              () {
                if (route != null) {
                  Navigator.pushNamed(context, route!);
                }
              },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
