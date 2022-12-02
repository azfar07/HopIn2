import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserRide.dart';

enum Gender {
  male,
  female,
  nonBinary,
}

class UserModel {
  String name;
  Gender gender;
  String id;
  String phone;
  String email;
  String carInfo;
  double rating;
  //
  //Constructor
  UserModel({
    this.name,
    this.gender,
    this.phone,
    this.id,
    this.email,
    this.carInfo,
    this.rating,
    List<ReviewModel> reviewsList,
    List ridesList,
  });

  String getUrlFromNameHash({Gender genderInput}) {
    int id = this.name.hashCode % 100;
    switch (genderInput) {
      case Gender.male:
        return 'https://randomuser.me/api/portraits/men/64.jpg';
        break;
      case Gender.female:
        return 'https://randomuser.me/api/portraits/women/93.jpg';
        break;
      case Gender.nonBinary:
        return 'https://randomuser.me/api/portraits/lego/1.jpg';
        break;
      default:
        return 'https://randomuser.me/api/portraits/lego/1.jpg';
      //  return 'data:image/jpeg;base64,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';
    }
  }

  @override
  String toString() {
    return 'UserModel(name: $name, gender: $gender, phone: $phone, email: $email, carInfo: $carInfo, rating: $rating,)';
  }

  UserModel copyWith({
    String name,
    Gender gender,
    String phone,
    String email,
    String carInfo,
    double rating,
  }) {
    return UserModel(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      carInfo: carInfo ?? this.carInfo,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender?.toString(),
      'phone': phone,
      'email': email,
      'carInfo': carInfo,
      'rating': rating,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    Gender gender;
    if (map['gender'] == 'Gender.male') {
      gender = Gender.male;
    } else if (map['gender'] == 'Gender.female') {
      gender = Gender.female;
    } else if (map['gender'] == 'Gender.nonBinary') {
      gender = Gender.nonBinary;
    } else {
      gender = null;
    }

    return UserModel(
      name: map['name'],
      gender: gender,
      phone: map['phone'],
      email: map['email'],
      carInfo: map['carInfo'],
      rating: map['rating'],
    );
  }

  String toJson() => json.encode(toMap());

  static UserModel fromJson(String source) => fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserModel &&
        o.name == name &&
        o.gender == gender &&
        o.phone == phone &&
        o.email == email &&
        o.carInfo == carInfo &&
        o.rating == rating;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        gender.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        carInfo.hashCode ^
        rating.hashCode;
  }
}

class users {
  static String name = 'loading';
  static Gender gender;
  static String email = 'loading';
  static String phone = 'loading';
  static String carinfo = 'loading';
  static double rating;
}
