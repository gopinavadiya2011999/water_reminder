import 'package:get/get_rx/src/rx_types/rx_types.dart';

class GenderList {
  String? name;
  String? image;
  RxBool selected = false.obs;

  GenderList({this.name, this.image, required this.selected});
}

List<GenderList> genderList = [
  GenderList(name: 'Male', image: 'assets/male.png', selected: true.obs),
  GenderList(name: 'Female', image: 'assets/girl.png', selected: false.obs),
  GenderList(name: 'Other', image: 'assets/other.png', selected: false.obs),
];