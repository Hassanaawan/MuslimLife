// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import '../../viewmodel/bottom_nav_viewmodel.dart';
// import 'home/home_page.dart';
//
// class BottomNavigationBar extends StatelessWidget {
//   final NavController navController = Get.put(NavController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(
//         padding: EdgeInsets.zero,
//         child: SizedBox(
//           height: 100,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(navItems.length, (index) {
//                 return GestureDetector(
//                   onTap: () => navController.setIndex(index),
//                   child: SizedBox(
//                     width: 80,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         GetBuilder<NavController>(
//                           builder: (controller) => Icon(
//                             navItems[index]['icon'],
//                             color: controller.selectedIndex == index
//                                 ? Colors.blue
//                                 : Colors.grey,
//                             size: 24,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         GetBuilder<NavController>(
//                           builder: (controller) => Text(
//                             navItems[index]['label'],
//                             style: TextStyle(
//                               color: controller.selectedIndex == index
//                                   ? Colors.blue
//                                   : Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Navigation items and screens
// final List<Map<String, dynamic>> navItems = [
//   {'icon': Icons.home, 'label': 'Home'},
//   {'icon': Icons.book, 'label': 'Quran'},
//   {'icon': Icons.explore, 'label': 'Qibla'},
//   {'icon': Icons.menu_book, 'label': 'Hadith'},
//   {'icon': Icons.filter_vintage, 'label': 'Tasbih'},
//   {'icon': Icons.location_on, 'label': 'Location'},
//   {'icon': Icons.calculate, 'label': 'Calculator'},
//   {'icon': Icons.access_alarm, 'label': 'Dua'},
// ];
//
// final List<Widget> screens = [
//   HomePage(loadUserData: false,),
//   HomePage(loadUserData: true,),
//   HomePage(loadUserData: true,),
//   HomePage(loadUserData: true,),
//   HomePage(loadUserData: true,),
//   HomePage(loadUserData: true,),
//   HomePage(loadUserData: true,),
//   HomePage(loadUserData: true,),
// ];
