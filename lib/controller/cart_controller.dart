import 'package:get/get.dart';
import '../helper/local_database_helper.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var loading = false.obs; // To track loading state

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final items = await LocalDatabase().getCartItems();
    cartItems.value = items;
  }

  Future<void> deleteCartItem(int id) async {
    loading.value = true; // Set loading to true
    await LocalDatabase().deleteCartItem(id);
    await fetchCartItems(); // Refresh the list
    loading.value = false; // Set loading to false
  }

  Future<void> updateCartItem(int id, String product, String category) async {
    loading.value = true; // Set loading to true
    await LocalDatabase().updateCartItem(id, product, category);
    await fetchCartItems(); // Refresh the list
    loading.value = false; // Set loading to false
  }
}
