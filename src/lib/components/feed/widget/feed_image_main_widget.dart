import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:thumbor/thumbor.dart';

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
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
      child: Column(
        children: [
          if (imageList.length == 1) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                color: kBlackColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width - 24.w,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    color: kPreviousNeutralColor300,
                  ),
                  imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[0].url!}").toUrl(),
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
                      imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[0].url!}").toUrl(),
                      placeholder: (context, url) => Container(
                        color: kPreviousNeutralColor300,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width.floor().toDouble(),
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
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
                      imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[1].url!}").toUrl(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                      imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[0].url!}").toUrl(),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width.floor().toDouble(),
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
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
                          imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[1].url!}").toUrl(),
                          fit: BoxFit.cover,
                          height: (MediaQuery.of(context).size.width / 2).floor().toDouble() - 1,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(12.0),
                        ),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            color: kPreviousNeutralColor300,
                          ),
                          imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[2].url!}").toUrl(),
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
                      imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[0].url!}").toUrl(),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width.floor().toDouble(),
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
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
                          imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[1].url!}").toUrl(),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: (MediaQuery.of(context).size.width / 2).floor().toDouble() - 1,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
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
                              imageUrl: Thumbor(host: thumborHostUrl, key: thumborKey).buildImage("${imageList[2].url!}").toUrl(),
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
