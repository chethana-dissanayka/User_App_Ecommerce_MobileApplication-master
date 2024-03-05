// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OrderHistoryPage extends StatefulWidget {
//   @override
//   _OrderHistoryPageState createState() => _OrderHistoryPageState();
// }

// class _OrderHistoryPageState extends State<OrderHistoryPage> {
//   late User? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _currentUser = FirebaseAuth.instance.currentUser;
//   }

//   Future<List<Map<String, dynamic>>> _fetchOrderHistory() async {
//     List<Map<String, dynamic>> orderHistory = [];

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection("costomer_oders")
//           .doc(_currentUser!.email)
//           .collection("Finalcoutmeroders")
//           .get();

//       orderHistory = querySnapshot.docs.map((doc) {
//         Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;

       
//         List<Map<String, dynamic>> cartItems = (orderData['cartItems'] as List<dynamic>)
//             .map((item) => item as Map<String, dynamic>)
//             .toList();

//         orderData['cartItems'] = cartItems;

//         return orderData;
//       }).toList();
//     } catch (error) {
//       print("Error fetching order history: $error");
//     }

//     return orderHistory;
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Order History"),
//       ),
//       body:  Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("assets/back.png"),
//           fit: BoxFit.cover,
//         ),
//       ),
      
//       child: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _fetchOrderHistory(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else {
//             List<Map<String, dynamic>> orderHistory = snapshot.data ?? [];

//             if (orderHistory.isEmpty) {
//               return Center(child: Text("No order history available."));
//             }

//             return ListView.builder(
//               itemCount: orderHistory.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> orderData = orderHistory[index];

                
//                 List<Map<String, dynamic>> cartItems = (orderData['cartItems'] as List<dynamic>)
//                     .map((item) => item as Map<String, dynamic>)
//                     .toList();

               
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Card(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ListTile(
//                           title: Text("Order ${index + 1}"),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Customer Name: ${orderData['customername']}"),
//                               Text("Receiver's Phone: ${orderData['receiversphone']}"),
//                               Text("Order Date: ${orderData['orderdate']}"),
//                               Text("Delivery Method: ${orderData['delivermethod']}"),
//                               Text("Address: ${orderData['address']}"),
                           
//                             ],
//                           ),
                          
                      
                    
//                         ),
                      
//                         for (var item in cartItems)
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ListTile(
//                                 title: Text("Item: ${item['name']}"),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Price: ${item['price']}"),
                                   
//                                     Image.network(
//                                       item['url'],
//                                       height: 100, 
//                                     ),
                                    
//                                   ],
//                                 ),

                                
//                               ),
//                             ],
//                           ),

//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.delete,
//                                     color: Colors.red[900],
//                                   ),
//                                   onPressed: () async {
//                                     try {
                                      
//                                       //await orderHistory.reference.delete();
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(
//                                           content: Text('Order deleted successfully!'),
//                                           backgroundColor: Colors.green,
//                                         ),
//                                       );
//                                     } catch (error) {
//                                       // Handle any errors that might occur during deletion
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(
//                                           content: Text('Error deleting order: ${error.toString()}'),
//                                           backgroundColor: Colors.green,
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       ),
//     );
//   }
// }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OrderHistoryPage extends StatefulWidget {
//   const OrderHistoryPage({Key? key});

//   @override
//   State<OrderHistoryPage> createState() => _OrderHistoryPageState();
// }

// class _OrderHistoryPageState extends State<OrderHistoryPage> {
//   late User? _currentUser;
//   TextEditingController searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 237, 157, 128),
//       appBar: AppBar(
//         title: Text(
//           'Past Orders',
//           style: TextStyle(fontSize: 30),
//         ),
//         backgroundColor: Color.fromARGB(255, 255, 141, 142),
//         foregroundColor: Colors.white,
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/t.jpg'), // Replace with your background image
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('CompletedOrders').snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error loading orders: ${snapshot.error}'));
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//                 return ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot orderDocument = snapshot.data!.docs[index];
//                     Map<String, dynamic> orderData = orderDocument.data() as Map<String, dynamic>;

//                     return Container(
//                       margin: const EdgeInsets.all(8.0),
//                       decoration: BoxDecoration(
//                         color: Color.fromARGB(255, 247, 218, 218),
//                         border: Border.all(
//                           color: Colors.black, // Set the border color
//                           width: 2.0, // Set the border width
//                         ),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: ListTile(
                        
//                        title: Text("Order ${index + 1}"),
//                         // title: Text(
//                         //   'Order for ${orderData['customername']}',
//                         //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         // ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Address: ${orderData['address']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
//                             Text('Order Date: ${orderData['orderdate']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
//                             Text('Delivery Method: ${orderData['delivermethod']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
//                             Text('Receiver\'s Phone: ${orderData['receiversphone']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
//                             Text('Customer Name: ${orderData['customername']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
//                             Text('Total Payment: ${orderData['totalCost']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
//                             SizedBox(height: 10),
//                             Text('Cart Items:', style: TextStyle(fontWeight: FontWeight.bold)),
//                             Column(
//                               children: (orderData['cartItems'] as List).map((item) {
//                                 return ListTile(
//                                   title: Text('Name: ${item['name']}'),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text('Price: ${item['price']}'),
//                                       Image.network(
//                                         item['url'],
//                                         width: 100,
//                                         height: 100,
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.delete,
//                                     color: Colors.red[900],
//                                   ),
//                                   onPressed: () async {
//                                     try {
//                                       await orderDocument.reference.delete();
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(
//                                           content: Text('Order deleted successfully!'),
//                                           backgroundColor: Colors.green,
//                                         ),
//                                       );
//                                     } catch (error) {
//                                       // Handle any errors that might occur during deletion
//                                       ScaffoldMessenger.of(context).showSnackBar(
//                                         SnackBar(
//                                           content: Text('Error deleting order: ${error.toString()}'),
//                                           backgroundColor: Colors.green,
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               } else {
//                 return Center(child: Text('No completed orders found'));
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<List<Map<String, dynamic>>> _fetchOrderHistory() async {
    List<Map<String, dynamic>> orderHistory = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("costomer_oders")
          .doc(_currentUser!.email)
          .collection("Finalcoutmeroders")
          .get();

        //    .collection("Final_Cheakoutoders")
        //   .doc(_currentUser!.email)
        //   .collection("FinalorderItems")
        //  .get();

      orderHistory = querySnapshot.docs.map((doc) {
        Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
        orderData['orderId'] = doc.id; // Add the orderId to the orderData map
       
        List<Map<String, dynamic>> cartItems = (orderData['cartItems'] as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();

        orderData['cartItems'] = cartItems;

        return orderData;
      }).toList();
    } catch (error) {
      print("Error fetching order history: $error");
    }

    return orderHistory;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchOrderHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              List<Map<String, dynamic>> orderHistory = snapshot.data ?? [];

              if (orderHistory.isEmpty) {
                return Center(child: Text("No order history available."));
              }

              return ListView.builder(
                itemCount: orderHistory.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> orderData = orderHistory[index];

                  List<Map<String, dynamic>> cartItems = (orderData['cartItems'] as List<dynamic>)
                      .map((item) => item as Map<String, dynamic>)
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("Order ${index + 1}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Customer Name: ${orderData['customername']}"),
                                Text("Receiver's Phone: ${orderData['receiversphone']}"),
                                Text("Order Date: ${orderData['orderdate']}"),
                                Text("Delivery Method: ${orderData['delivermethod']}"),
                                Text("Address: ${orderData['address']}"),
                              ],
                            ),
                          ),
                          for (var item in cartItems)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text("Item: ${item['name']}"),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Price: ${item['price']}"),
                                      Image.network(
                                        item['url'],
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     IconButton(
                          //       icon: Icon(
                          //         Icons.delete,
                          //         color: Colors.red[900],
                          //       ),
                          //       onPressed: () async {
                          //         try {
                          //           // Get the orderId for the current order
                          //           String orderId = orderData['orderId'];

                          //           // Get the document reference using the orderId
                          //           DocumentReference orderDocument = FirebaseFirestore.instance
                          //               .collection("costomer_oders")
                          //               .doc(_currentUser!.email)
                          //               .collection("Finalcoutmeroders")
                          //               .doc(orderId);

                          //           // Delete the order from Cloud Firestore
                          //           await orderDocument.delete();

                          //           // Remove the order from the local orderHistory list
                          //           setState(() {
                          //             orderHistory.removeAt(index);
                          //           });

                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(
                          //               content: Text('Order deleted successfully!'),
                          //               backgroundColor: Colors.green,
                          //             ),
                          //           );
                          //         } catch (error) {
                          //           // Handle any errors that might occur during deletion
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(
                          //               content: Text('Error deleting order: ${error.toString()}'),
                          //               backgroundColor: Colors.red,
                          //             ),
                          //           );
                          //         }
                          //       },
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
