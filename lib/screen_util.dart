import 'package:flutter/material.dart';

//TODO refer to adaptive_breakpoint package.
bool isPortrait(BuildContext context) =>
    MediaQuery.of(context).size.aspectRatio < 1;
