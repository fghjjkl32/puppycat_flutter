import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedWriteContentProvider = StateProvider<TextEditingController>((ref) => TextEditingController());

final feedEditContentProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
