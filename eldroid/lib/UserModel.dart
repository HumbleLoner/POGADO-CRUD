// ignore_for_file: file_names, unnecessary_new

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? birthdate;
  String? password;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.secondName,
      this.birthdate,
      this.password});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        birthdate: map['birthdate'],
        password: map['password']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'birthdate': birthdate,
      'password': password
    };
  }
}

//---------------------------------------------

class itemModel {
  String? uid;
  String? itemName;
  String? quantity;
  String? price;

  itemModel({this.uid, this.itemName, this.quantity, this.price});

  // receiving data from server
  factory itemModel.fromMap(map) {
    return itemModel(
        uid: map['uid'],
        itemName: map['itemName'],
        quantity: map['quantity'],
        price: map['price']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
    };
  }
}
