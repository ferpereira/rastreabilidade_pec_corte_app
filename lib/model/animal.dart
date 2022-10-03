import 'dart:ffi';

class Animal {
  String? animalId;
  String? descricao;
  String? dataNascimento;
  bool? status;

  Animal(
      String animalId, String descricao, String dataNascimento, bool status) {
    this.animalId = animalId;
    this.descricao = descricao;
    this.dataNascimento = dataNascimento;
    this.status = status;
  }

  Map<String, dynamic> toMap() => {
        'id': animalId,
        'descricao': descricao,
        'dataNascimento': dataNascimento,
        'status': status,
      };
}
