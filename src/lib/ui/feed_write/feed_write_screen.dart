import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/insta_assets_picker/insta_assets_crop_controller.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/ui/feed_write/componenet/post_feed_view.dart';
import 'package:pet_mobile_social_flutter/viewmodels/feed_write/feed_write_provider.dart';

class FeedWriteScreen extends ConsumerWidget {
  const FeedWriteScreen({super.key, required this.cropStream});

  final Stream<InstaAssetsExportDetails> cropStream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('새 게시물'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();

            ref.read(feedWriteProvider.notifier).resetTag();
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            child: Text(
              '등록',
              style: kButton12BoldStyle.copyWith(color: kPrimaryColor),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<InstaAssetsExportDetails>(
        stream: cropStream,
        builder: (context, snapshot) => PostFeedView(
          croppedFiles: snapshot.data?.croppedFiles ?? [],
          progress: snapshot.data?.progress,
        ),
      ),
    );
  }
}
