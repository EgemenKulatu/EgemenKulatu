class Customer {
  int? id;
  String? phoneNumber;
  String? name;
  String? surname;

  Customer({this.id, this.phoneNumber, this.name, this.surname});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    name = json['name'];
    surname = json['surname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['surname'] = surname;
    return data;
  }
}