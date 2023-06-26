import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';

class MyPageMyActivityDetailScreen extends StatelessWidget {
  final String title;
  const MyPageMyActivityDetailScreen({required this.title, super.key});

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
              title: Text(
                title,
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
