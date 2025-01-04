// import 'package:flutter/material.dart';

// class ContractorSearchPage1 extends StatelessWidget {
//   const ContractorSearchPage1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double widthFactor = MediaQuery.of(context).size.width;
//     double heightFactor = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.green,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back,
//               color: Colors.white, size: widthFactor * 0.07),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'Search Contractor',
//           style: TextStyle(
//             fontSize: widthFactor * 0.05,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Search Bar Section
//           Container(
//             color: Colors.white,
//             padding: EdgeInsets.all(widthFactor * 0.04),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Search by name, company, or location",
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: widthFactor * 0.04,
//                         vertical: heightFactor * 0.015,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(widthFactor * 0.05),
//                         borderSide:
//                             const BorderSide(color: Colors.green, width: 2),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(widthFactor * 0.05),
//                         borderSide:
//                             const BorderSide(color: Colors.green, width: 2),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(widthFactor * 0.05),
//                         borderSide:
//                             const BorderSide(color: Colors.green, width: 2),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: widthFactor * 0.03),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Add search functionality here
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(widthFactor * 0.03),
//                     ),
//                     padding: EdgeInsets.all(widthFactor * 0.03),
//                   ),
//                   child: Icon(Icons.search,
//                       color: Colors.white, size: widthFactor * 0.07),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: heightFactor * 0.02),
//           // Contractor Cards Section
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5, // Replace with dynamic data count.
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: EdgeInsets.symmetric(
//                     horizontal: widthFactor * 0.05,
//                     vertical: heightFactor * 0.01,
//                   ),
//                   padding: EdgeInsets.all(widthFactor * 0.04),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(widthFactor * 0.05),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 8.0,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.green,
//                             child: Text(
//                               "C${index + 1}",
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: widthFactor * 0.03),
//                           Expanded(
//                             child: Text(
//                               "Contractor ${index + 1}",
//                               style: TextStyle(
//                                 fontSize: widthFactor * 0.05,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: heightFactor * 0.015),
//                       Text(
//                         "Company: Example Co.",
//                         style: TextStyle(
//                           fontSize: widthFactor * 0.045,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(height: heightFactor * 0.01),
//                       Row(
//                         children: [
//                           Icon(Icons.phone,
//                               color: Colors.green, size: widthFactor * 0.05),
//                           SizedBox(width: widthFactor * 0.02),
//                           Text(
//                             "+91 9876543210",
//                             style: TextStyle(fontSize: widthFactor * 0.04),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: heightFactor * 0.01),
//                       Row(
//                         children: [
//                           Icon(Icons.email,
//                               color: Colors.green, size: widthFactor * 0.05),
//                           SizedBox(width: widthFactor * 0.02),
//                           Text(
//                             "contractor${index + 1}@example.com",
//                             style: TextStyle(fontSize: widthFactor * 0.04),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: heightFactor * 0.01),
//                       Row(
//                         children: [
//                           Icon(Icons.location_on,
//                               color: Colors.green, size: widthFactor * 0.05),
//                           SizedBox(width: widthFactor * 0.02),
//                           Text(
//                             "City ${index + 1}",
//                             style: TextStyle(fontSize: widthFactor * 0.04),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
