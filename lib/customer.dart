class Customer {
  int id;
  String phoneNumber;
  String? name;
  String? surname;
  bool isApproved;

  Customer({required this.id,required this.phoneNumber, this.name, this.surname, required this.isApproved,this.approveCode});

  static Customer fromJson(Map<dynamic, dynamic> json) {
    return Customer(id: json['id'], phoneNumber: json['phoneNumber'],
    name: json['name'],
    isApproved: json['isApproved']?? false,
    approveCode: json['approveCode']??0,
    surname: json['surname']);
    
  }

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['approveCode']=approveCode;
    data['isApproved'] = isApproved;
    data['surname'] = surname;
    return data;
  }
  int? approveCode;
}