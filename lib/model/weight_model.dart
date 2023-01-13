import 'package:get/get.dart';

class WeightList{
  int? item;
  RxBool? selected =false.obs;
List<WeightType>? weightType;
  WeightList({this.weightType,this.item, this.selected});
}
class WeightType {

  String? type;
  RxBool? selected =false.obs;

  WeightType({this.type, this.selected});
}



