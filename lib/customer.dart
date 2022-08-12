class Customer {
  int id;
  String? phoneNumber;
  String? name;
  String? surname;
  bool isApproved;

  Customer({required this.id, this.phoneNumber, this.name, this.surname, required this.isApproved});

  static Customer fromJson(Map<dynamic, dynamic> json) {
    return Customer(id: json['id'], phoneNumber: json['phoneNumber'],
    name: json['name'],
    isApproved: json['isApproved']?? false,
    surname: json['surname']);
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['isApproved'] = isApproved;
    data['surname'] = surname;
    return data;
  }
}