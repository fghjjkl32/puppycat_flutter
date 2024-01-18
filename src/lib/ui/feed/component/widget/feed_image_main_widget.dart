import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_data.dart';

class FeedImageMainWidget extends StatelessWidget {
  const FeedImageMainWidget({
    required this.imageList,
    // required this.imageDomain,
    Key? key,
  }) : super(key: key);

  final List<FeedImgListData> imageList;

  // final String imageDomain;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
      child: Column(
        children: [
          if (imageList.length == 1) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: kBlackColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width - 24,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    color: kPreviousNeutralColor300,
                  ),
                  imageUrl: thumborUrl(imageList[0].url ?? ''),
                  // fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ] else if (imageList.length == 2) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: thumborUrl(imageList[0].url ?? ''),
                      placeholder: (context, url) => Container(
                        color: kPreviousNeutralColor300,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width.floor().toDouble(),
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        color: kPreviousNeutralColor300,
                      ),
                      imageUrl: thumborUrl(imageList[1].url ?? ''),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width.floor().toDouble(),
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (imageList.length == 3) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        color: kPreviousNeutralColor300,
                      ),
                      imageUrl: thumborUrl(imageList[0].url ?? ''),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width.floor().toDouble(),
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12.0),
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            color: kPreviousNeutralColor300,
                          ),
                          imageUrl: thumborUrl(imageList[1].url ?? ''),
                          fit: BoxFit.cover,
                          height: (MediaQuery.of(context).size.width / 2).floor().toDouble() - 1,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(12.0),
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            color: kPreviousNeutralColor300,
                          ),
                          imageUrl: thumborUrl(imageList[2].url ?? ''),
                          fit: BoxFit.cover,
                          height: (MediaQuery.of(context).size.width / 2).floor().toDouble() - 1,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else if (imageList.length > 3) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        color: kPreviousNeutralColor300,
                      ),
                      imageUrl: thumborUrl(imageList[0].url ?? ''),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width.floor().toDouble(),
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12.0),
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            color: kPreviousNeutralColor300,
                          ),
                          imageUrl: thumborUrl(imageList[1].url ?? ''),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: (MediaQuery.of(context).size.width / 2).floor().toDouble() - 1,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                color: kPreviousNeutralColor300,
                              ),
                              imageUrl: thumborUrl(imageList[2].url ?? ''),
                              fit: BoxFit.cover,
                              height: (MediaQuery.of(context).size.width / 2).floor().toDouble() - 1,
                              width: double.infinity,
                            ),
                          ),
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.5,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(12.0),
                                ),
                                child: Container(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                '+ ${imageList.length - 3}',
                                style: kTitle18BoldStyle.copyWith(color: kPreviousNeutralColor100),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
