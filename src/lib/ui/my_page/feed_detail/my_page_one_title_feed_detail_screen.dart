import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/components/feed/feed_detail_widget.dart';

class MyPageOneTitleFeedDetailScreen extends ConsumerStatefulWidget {
  final String title;
  final String memberIdx;
  const MyPageOneTitleFeedDetailScreen(
      {required this.title, required this.memberIdx, super.key});

  @override
  MyPageMainState createState() => MyPageMainState();
}

class MyPageMainState extends ConsumerState<MyPageOneTitleFeedDetailScreen> {
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
                widget.title,
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
                // FeedDetailWidget(),
                // FeedDetailWidget(),
                // FeedDetailWidget(),
                // FeedDetailWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
