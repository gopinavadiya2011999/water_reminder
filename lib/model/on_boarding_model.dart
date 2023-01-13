

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class OnBoardingModel{
  String? text;
  RxBool selected = false.obs;
  OnBoardingModel({this.text, required this.selected});
}

List<OnBoardingModel> onBoardingModel=[
  OnBoardingModel(text: 'What is your gender?',
 selected: true.obs ),
  OnBoardingModel(text: 'What is your current weight?',
selected: false.obs),
  OnBoardingModel(text: 'What is your bed time?',
 selected: false.obs),
  OnBoardingModel(text: 'What is your wake up time?',
 selected: false.obs),
  OnBoardingModel(text: 'What is your daily water intake goal?',
  selected: false.obs),
];