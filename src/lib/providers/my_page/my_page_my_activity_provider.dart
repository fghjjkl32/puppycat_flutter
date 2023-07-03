import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageMyActivityNotifier extends StateNotifier<String> {
  MyPageMyActivityNotifier() : super('');

  List<String> searchResult = [
    'https://img.freepik.com/free-photo/adorable-kitty-looking-like-it-want-to-hunt_23-2149167099.jpg?w=2000',
    'https://www.chemicalnews.co.kr/news/photo/202106/3636_10174_4958.jpg',
    'https://i.namu.wiki/i/PagwakcE00JZaGpEvXym79-IMvKFBmdqOBlq778J-bvJMwz15lDLleTKc56S2wwcRcaEm3FZZ4EtniRa5bXdeQ.webp',
    'https://www.chemicalnews.co.kr/news/photo/202106/3636_10174_4958.jpg',
    'https://cdn.eyesmag.com/content/uploads/posts/2022/08/08/main-ad65ae47-5a50-456d-a41f-528b63071b7b.jpg',
    'https://c.files.bbci.co.uk/4532/production/_126241771_gettyimages-1224404559-1.jpg',
    'https://src.hidoc.co.kr/image/lib/2022/11/15/1668491763670_0.jpg',
    'https://dimg.donga.com/ugc/CDB/WEEKLY/Article/5b/02/77/fa/5b0277fa109dd2738de6.jpg',
    'https://www.chemicalnews.co.kr/news/photo/202106/3636_10174_4958.jpg',
    'https://cdn.edujin.co.kr/news/photo/202105/35768_68227_247.jpg',
    'https://img.freepik.com/free-photo/adorable-kitty-looking-like-it-want-to-hunt_23-2149167099.jpg?w=2000',
    'https://i.namu.wiki/i/PagwakcE00JZaGpEvXym79-IMvKFBmdqOBlq778J-bvJMwz15lDLleTKc56S2wwcRcaEm3FZZ4EtniRa5bXdeQ.webp',
    'https://cdn.eyesmag.com/content/uploads/posts/2022/08/08/main-ad65ae47-5a50-456d-a41f-528b63071b7b.jpg',
    'https://c.files.bbci.co.uk/4532/production/_126241771_gettyimages-1224404559-1.jpg',
    'https://src.hidoc.co.kr/image/lib/2022/11/15/1668491763670_0.jpg',
    'https://dimg.donga.com/ugc/CDB/WEEKLY/Article/5b/02/77/fa/5b0277fa109dd2738de6.jpg',
    'https://www.chemicalnews.co.kr/news/photo/202106/3636_10174_4958.jpg',
    'https://cdn.edujin.co.kr/news/photo/202105/35768_68227_247.jpg',
    'https://img.freepik.com/free-photo/adorable-kitty-looking-like-it-want-to-hunt_23-2149167099.jpg?w=2000',
    'https://i.namu.wiki/i/PagwakcE00JZaGpEvXym79-IMvKFBmdqOBlq778J-bvJMwz15lDLleTKc56S2wwcRcaEm3FZZ4EtniRa5bXdeQ.webp',
    'https://cdn.eyesmag.com/content/uploads/posts/2022/08/08/main-ad65ae47-5a50-456d-a41f-528b63071b7b.jpg',
    'https://c.files.bbci.co.uk/4532/production/_126241771_gettyimages-1224404559-1.jpg',
    'https://src.hidoc.co.kr/image/lib/2022/11/15/1668491763670_0.jpg',
    'https://dimg.donga.com/ugc/CDB/WEEKLY/Article/5b/02/77/fa/5b0277fa109dd2738de6.jpg',
    'https://www.chemicalnews.co.kr/news/photo/202106/3636_10174_4958.jpg',
    'https://cdn.edujin.co.kr/news/photo/202105/35768_68227_247.jpg',
  ];
}

final myPageMyActivityProvider =
    StateNotifierProvider<MyPageMyActivityNotifier, String>(
  (ref) => MyPageMyActivityNotifier(),
);
