import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';

class MyPageTwoTitleFeedDetailScreen extends StatelessWidget {
  final String firstTitle;
  final String secondTitle;

  const MyPageTwoTitleFeedDetailScreen(
      {required this.firstTitle, required this.secondTitle, super.key});

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
                    firstTitle,
                    style: kBody11RegularStyle.copyWith(color: kTextBodyColor),
                  ),
                  Text(secondTitle),
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
