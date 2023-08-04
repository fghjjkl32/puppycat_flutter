import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/size_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';

class FeedImageMainWidget extends StatelessWidget {
  const FeedImageMainWidget({
    required this.imageList,
    Key? key,
  }) : super(key: key);

  final List<FeedImgListData> imageList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w, right: 12.w, bottom: 12.h),
      child: Column(
        children: [
          if (imageList.length == 1) ...[
            Container(
              height: 266.h,
              child: Padding(
                padding: kPrimarySideFeedImagePadding,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    "https://dev-imgs.devlabs.co.kr${imageList[0].url!}",
                    fit: BoxFit.cover,
                    height: 266.h,
                  ),
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
                    child: Image.network(
                      "https://dev-imgs.devlabs.co.kr${imageList[0].url!}",
                      fit: BoxFit.cover,
                      height: 266.h,
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
                    child: Image.network(
                      "https://dev-imgs.devlabs.co.kr${imageList[1].url!}",
                      fit: BoxFit.cover,
                      height: 266.h,
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
                    child: Image.network(
                      "https://dev-imgs.devlabs.co.kr${imageList[0].url!}",
                      fit: BoxFit.cover,
                      height: 266.h,
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
                        child: Image.network(
                          "https://dev-imgs.devlabs.co.kr${imageList[1].url!}",
                          fit: BoxFit.cover,
                          height: 132.h,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(12.0),
                        ),
                        child: Image.network(
                          "https://dev-imgs.devlabs.co.kr${imageList[2].url!}",
                          fit: BoxFit.cover,
                          height: 132.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else if (imageList.length > 4) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                    child: Image.network(
                      "https://dev-imgs.devlabs.co.kr${imageList[0].url!}",
                      fit: BoxFit.cover,
                      height: 266.h,
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
                        child: Image.network(
                          "https://dev-imgs.devlabs.co.kr${imageList[1].url!}",
                          fit: BoxFit.cover,
                          height: 132.h,
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
                            child: Image.network(
                              "https://dev-imgs.devlabs.co.kr${imageList[2].url!}",
                              fit: BoxFit.cover,
                              height: 132.h,
                            ),
                          ),
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                '+ ${imageList.length - 4}',
                                style: kTitle18BoldStyle.copyWith(
                                    color: kNeutralColor100),
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
