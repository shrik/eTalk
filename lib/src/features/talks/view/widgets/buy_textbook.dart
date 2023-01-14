//
// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
//
//
// class BuyTextbookButton extends StatefulWidget {
//   const BuyTextbookButton({Key? key}) : super(key: key);
//
//   @override
//   State<BuyTextbookButton> createState() => _BuyTextbookButtonState();
// }
//
// class _BuyTextbookButtonState extends State<BuyTextbookButton> {
//   @override
//   Widget build(BuildContext context) {
//     String buttonText = "Buy Textbook";
//
//     return GestureDetector(
//       onTap: ()  {
//         GoRouter.of(context).go('/talks/buyingtextbook');
//       },
//       child: Container(
//         height: 50.0,
//         padding: const EdgeInsets.all(8.0),
//         margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.0),
//           color: Colors.lightGreen[500],
//         ),
//         child: Center(
//           child: Text(buttonText),
//         ),
//       ),
//     );
//   }
// }
