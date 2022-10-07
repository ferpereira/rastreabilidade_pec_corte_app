import 'dart:ffi';

class Animal {
  String  id = '';
  String? description;
  String? sisbovEarring;
  String? birthDate;
  String? flock;
  String? breed;
  String? leatherColor;
  String? sex;
  String? slaughterRecord;
  bool? status = true ;

  Animal(
          String id,
          String description,
          String sisbovEarring,
          String birthDate,
          String flock,
          String breed,
          String leatherColor,
          String sex,
          String slaughterRecord,
          bool status) {
    this.id = id;
    this.description = description;
    this.sisbovEarring = sisbovEarring;
    this.birthDate = birthDate;
    this.flock = flock;
    this.breed = breed;
    this.leatherColor = leatherColor;
    this.sex = sex;
    this.slaughterRecord = slaughterRecord;
    this.status = status;
  }

  Map<String, dynamic> toMap() => {
        'description': description,
        'sisbovEarring': sisbovEarring,
        'birthDate': birthDate,
        'flock': flock,
        'breed': breed,
        'leatherColor': leatherColor,
        'sex': sex,
        'slaughterRecord': slaughterRecord,
        'status': status,
      };
}
