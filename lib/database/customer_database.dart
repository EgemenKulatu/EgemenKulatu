import '../customer.dart';
import 'hive_manager.dart';

class CustomerDatabase {
  CustomerDatabase({required this.sharedPreferencesManager});
  final SharedPreferencesManager sharedPreferencesManager;

  Customer? getCustomer(String phoneNumber) {
    var customerResult = sharedPreferencesManager.read('customerInformation');
    if (customerResult == null) {
      return null;
    } else {
      var customerResponse = List<Customer>.from(customerResult.map((model)=>Customer.fromJson(model)));
      Customer.fromJson(customerResult);
      return customerResult;
    }
  }
}
