import 'dart:ui';

import 'package:flutter/material.dart';

void showSucc(BuildContext context,{required String message, Color col = Colors.white}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message),backgroundColor: col,),
  );
}