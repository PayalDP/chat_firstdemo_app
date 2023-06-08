import 'package:flutter/material.dart';

import '../../../../../main.dart';

class SheetOptions extends StatelessWidget {
  const SheetOptions(
      {super.key, required this.icon, required this.name, required this.onTap});

  final Icon icon;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: mq.width* .05, bottom: mq.height* .025, top: mq.height* .015),
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            icon,
            Flexible(child: Text('   $name',style: const TextStyle(fontSize: 16, color: Colors.black54, letterSpacing: 0.5),)),
          ],
        ),
      ),
    );
  }
}
