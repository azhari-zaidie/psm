import 'package:get/get.dart';

class MakroDetailsController extends GetxController {
  RxBool _isFavorite = false.obs;

  bool get isFavorite => _isFavorite.value;

  setIsFavorite(bool isFavoriteMakro) {
    _isFavorite.value = isFavoriteMakro;
  }
}
