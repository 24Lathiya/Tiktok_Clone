import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class IconTextWidget extends StatelessWidget {
  final IconData icon;
  final String count;
  final Color color;
  const IconTextWidget({Key? key, required this.icon, required this.count, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [const SizedBox(height: 20,), Icon(icon, size: 30, color: color, shadows: [BoxShadow(color: Colors.black, blurRadius: 2)],), const SizedBox(height: 10,), count.text.xl.shadow(1, 1, 1, Colors.black).make()],);
  }
}
