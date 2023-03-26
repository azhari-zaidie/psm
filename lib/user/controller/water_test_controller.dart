// ignore_for_file: prefer_final_fields, invalid_use_of_protected_member

import 'package:get/get.dart';
import 'package:psm_v2/user/model/makro.dart';

class WaterTestController extends GetxController {
  RxList<Makro> _makroList = <Makro>[].obs; //set semua makro yang ada
  RxList<int> _selectedMakroList = <int>[].obs;
  RxDouble _total = 0.0.obs;
  RxBool _selectedBox = false.obs;

  List<Makro> get makroList => _makroList.value;
  List<int> get selectedMakroList => _selectedMakroList.value;
  double get total => _total.value;
  bool get selectedBox => _selectedBox.value;

  setList(List<Makro> list) {
    _makroList.value = list;
  }

  addSelectedMakro(int makroSelectedID) {
    _selectedMakroList.value.add(makroSelectedID);
    update();
  }

  deleteSelectedMakro(int makroSelectedID) {
    _selectedMakroList.value.remove(makroSelectedID);
    update();
  }

  setTotal(double total) {
    _total.value = total;
  }

  setSelectedBox() {
    _selectedBox.value = !_selectedBox.value;
  }

  clearAllSelectedMakro() {
    _selectedMakroList.value.clear();
    update();
  }
}
