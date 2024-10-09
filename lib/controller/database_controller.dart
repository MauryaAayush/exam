import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddUsers extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void addUser(String product, String category, String price) {
    users
        .add({
      'Product': product,
      'Category': category,
      'Price': price,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  void deleteUser(String docId) {
    users.doc(docId).delete().then((_) {
      print('User Deleted');
    }).catchError((error) => print("Failed to delete user: $error"));
  }

  void updateUser(String docId, String product, String category, String price) {
    users.doc(docId).update({
      'Product': product,
      'Category': category,
      'Price': price,
    }).then((_) {
      print('User Updated');
    }).catchError((error) => print("Failed to update user: $error"));
  }
}
