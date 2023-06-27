import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_post_state.dart';

const List<String> searchResult = [
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

class MyPageMyPostNotifier extends StateNotifier<MyPostState> {
  MyPageMyPostNotifier()
      : super(MyPostState(selectOrder: List.filled(searchResult.length, -1)));

  //하나라도 선택 되어있는지 검사하는 메소드
  bool hasSelectedImage() {
    return state.selectOrder.any((order) => order != -1);
  }

  void resetSelection() {
    List<int> newOrderList = List.filled(searchResult.length, -1);
    state = state.copyWith(selectOrder: newOrderList, currentOrder: 1);
  }

  // 선택 순서를 업데이트하는 메소드
  void updateSelectOrder(int index, int order) {
    final newOrderList = List<int>.from(state.selectOrder);
    newOrderList[index] = order;
    state = state.copyWith(selectOrder: newOrderList);
  }

  // 현재 순서를 업데이트하는 메소드
  void updateCurrentOrder(int order) {
    state = state.copyWith(currentOrder: order);
  }

  void updateNumber(index) {
    if (state.selectOrder[index] == -1) {
      // 선택되지 않은 사진을 탭한 경우
      updateSelectOrder(index, state.currentOrder);
      updateCurrentOrder(state.currentOrder + 1);
    } else {
      // 이미 선택된 사진을 탭한 경우
      int removedOrder = state.selectOrder[index];
      updateSelectOrder(index, -1); // 선택 해제
      updateCurrentOrder(state.currentOrder - 1); // 순서 하나를 줄임
      // 해제된 사진보다 뒤의 선택 순서를 하나씩 앞당김
      for (int i = 0; i < state.selectOrder.length; i++) {
        if (state.selectOrder[i] > removedOrder) {
          updateSelectOrder(i, state.selectOrder[i] - 1);
        }
      }
    }
  }
}

final myPageMyPostProvider =
    StateNotifierProvider<MyPageMyPostNotifier, MyPostState>(
  (ref) => MyPageMyPostNotifier(),
);
