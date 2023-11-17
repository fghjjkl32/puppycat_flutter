import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';

final feedWriteContentProvider = StateProvider<TextEditingController>((ref) => TextEditingController());

final feedEditContentProvider = StateProvider<TextEditingController>((ref) => TextEditingController());
