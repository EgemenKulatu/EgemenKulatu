import 'dart:math';

import 'package:flutter/cupertino.dart';

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

  Future<CustomerResponseDTO> addCustomer(Customer customer) async {
    var customerList = getCustomerList();
    var customerIsExists=customerList.firstWhereOrNull((element) => element.phoneNumber==customer.phoneNumber);
    if(customerIsExists!=null){return CustomerResponseDTO(isSuccess: false,meessage: 'Bu telefona ait kayıt vardır');

    }
    customer.id = lastCustomerId(customerList);
    customer.approveCode = 1000 + Random().nextInt(8999);
    customer.isApproved=false;
    print(customer.approveCode.toString());
    customerList.add(customer);
    await saveCustomerList(customerList);
    var registeredCustomer = getCustomer(customer.phoneNumber);
    return CustomerResponseDTO(isSuccess: true,meessage: 'Başarılı şekilde kaydedildi',customer: registeredCustomer);
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

  Future<CustomerResponseDTO> approveCustomer(
    int approveCode,
    String phoneNumber,
  ) async {
    var approvedCustomer = getCustomer(phoneNumber);
    if (approvedCustomer != null) {
      if (approvedCustomer.approveCode == approveCode) {
        approvedCustomer.isApproved = true;
        await updateCustomer(approvedCustomer);
        return CustomerResponseDTO(
            customer: approvedCustomer,
            meessage: 'onaylama başarılı',
            isSuccess: true);
      }
      return CustomerResponseDTO(
          customer: approvedCustomer,
          meessage: 'onaylama kodu hatalı',
          isSuccess: false);
    }
    return CustomerResponseDTO(
        customer: approvedCustomer,
        meessage: 'onaylanacak müşteri bulunamadı',
        isSuccess: false);
  }

  Future saveCustomerList(List<Customer> customerList) async {
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

class CustomerResponseDTO {
  CustomerResponseDTO(
      {required this.meessage, this.customer, required this.isSuccess});

  String meessage;
  bool isSuccess;
  Customer? customer;
}
