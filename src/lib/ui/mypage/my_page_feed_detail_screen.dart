import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class MyPageFeedDetailScreen extends StatelessWidget {
  const MyPageFeedDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return false;
      },
      child: Material(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Column(
                children: [
                  Text(
                    "왕티즈왕왕",
                    style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                  ),
                  const Text('게시물'),
                ],
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: ListView(
              children: const [
                FeedDetailWidget(),
                FeedDetailWidget(),
                FeedDetailWidget(),
                FeedDetailWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
