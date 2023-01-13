// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:waterreminder/app/modules/home/views/home_view.dart';
// import 'package:waterreminder/main_bottom_nav.dart';
// import '../constant/color_constant.dart';
// import 'modules/account/views/account_view.dart';
// import 'package:bottom_nav_layout/bottom_nav_layout.dart';
//
// class BottomNavView extends StatefulWidget {
//   const BottomNavView({Key? key}) : super(key: key);
//
//   @override
//   State<BottomNavView> createState() => _BottomNavViewState();
// }
//
// class _BottomNavViewState extends State<BottomNavView> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("intiit :: ");
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       primary: true,
//       body: Theme(
//         data: Theme.of(context).copyWith(canvasColor: ColorConstant.white),
//         child: BottomNavLayout(
//         //  lazyLoadPages: true,
//           pages: [
//             (navKey) =>
//                 HomeMainView(navKey: navKey, initialPage:  HomeView()),
//             (navKey) =>
//                 HomeMainView(navKey: navKey, initialPage:  AccountView()),
//           ],
//           bottomNavigationBar: (currentIndex, onTap) => BottomNavigationBar(
//             currentIndex: currentIndex,
//             onTap: (index)  {
//               return onTap(index);
//             } ,
//             showSelectedLabels: true,
//             showUnselectedLabels: true,
//             unselectedLabelStyle:
//                 const TextStyle(fontFamily: 'Sora', fontSize: 14),
//             selectedLabelStyle:
//                 const TextStyle(fontFamily: 'Sora', fontSize: 14),
//             unselectedItemColor: ColorConstant.greyAF,
//
//             elevation: 0,
//             selectedItemColor: ColorConstant.blueFE,
//             type: BottomNavigationBarType.fixed,
//             items: [
//               bottomIcon(
//                 currentIndex: currentIndex,
//                 iconIndex: 0,
//                 label: 'Home',
//                 iconData: 'assets/profile.svg',
//               ),
//               bottomIcon(
//                 currentIndex: currentIndex,
//                 iconIndex: 1,
//                 label: 'Account',
//                 iconData: 'assets/accounts.svg',
//               ),
//             ],
//           ),
//           savePageState: true,
//         ),
//       ),
//     );
//   }
//
//   BottomNavigationBarItem bottomIcon({
//     required int currentIndex,
//     required int iconIndex,
//     required String label,
//     required String iconData,
//   }) {
//     return BottomNavigationBarItem(
//       icon: Container(
//         padding: const EdgeInsets.only(bottom: 2, top: 5),
//         child: SvgPicture.asset(iconData,color: currentIndex==iconIndex? ColorConstant.blueFE: ColorConstant.greyAF,),
//       ),
//       label: label,
//     );
//   }
// }
