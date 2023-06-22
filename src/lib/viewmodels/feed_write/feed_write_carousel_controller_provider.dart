import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedWriteCarouselControllerProvider =
    StateNotifierProvider<CarouselControllerNotifier, CarouselController>(
        (ref) {
  return CarouselControllerNotifier();
});

class CarouselControllerNotifier extends StateNotifier<CarouselController> {
  CarouselControllerNotifier() : super(CarouselController()) {
    state = CarouselController();
  }

  void jumpToPage(int index) {
    state.jumpToPage(index);
  }
}
