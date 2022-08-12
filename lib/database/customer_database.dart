import '../customer.dart';
import 'hive_manager.dart';
import 'package:collection/collection.dart' show IterableExtension;

class CustomerDatabase {
  CustomerDatabase({required this.sharedPreferencesManager});
  final SharedPreferencesManager sharedPreferencesManager;
  final String customerKeyName = 'customerInformation';

  Customer? getCustomer(String phoneNumber) {
    var customerResult = getCustomerList();

    var customer = customerResult
        .firstWhereOrNull((element) => element.phoneNumber == phoneNumber);
    return customer;
  }

  Future addCustomer(Customer customer) async {
    var customerList = getCustomerList();
    customer.id = lastCustomerId(customerList);
    customerList.add(customer);
await saveCustomerList(customerList);
  }

  Future updateCustomer(Customer customer) async {
    var customerList = getCustomerList();
    var updatedCustomer = customerList.firstWhereOrNull(
        (element) => element.phoneNumber == customer.phoneNumber);
    if (updatedCustomer == null) return;
    var updatedCustomerIndex = customerList
        .indexWhere((element) => element.phoneNumber == customer.phoneNumber);
    customerList[updatedCustomerIndex].name = customer.name;
    customerList[updatedCustomerIndex].surname = customer.surname;
    customerList[updatedCustomerIndex].phoneNumber = customer.phoneNumber;
    await saveCustomerList(customerList);
  }
  Future saveCustomerList(List<Customer> customerList)async{
var customerListIterable =
        List<dynamic>.from(customerList.map((e) => e.toJson()));
    await sharedPreferencesManager.add(customerListIterable, customerKeyName);
  }

  int lastCustomerId(List<Customer> customerList) {
    if (customerList.isEmpty) return 1;
    var lastCustomer = customerList
        .reduce((current, next) => (current.id) > (next.id) ? current : next);
    return lastCustomer.id + 1;
  }

  List<Customer> getCustomerList() {
    var customerResult = sharedPreferencesManager.read(customerKeyName);
    if (customerResult == null) {
      return [];
    } else {
      return List<Customer>.from(
          customerResult.map((model) => Customer.fromJson(model)));
    }
  }
}
