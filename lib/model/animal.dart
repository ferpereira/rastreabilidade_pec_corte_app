import 'dart:ffi';

class Animal {
  String? animalId;
  String? descricao;
  String? dataNascimento;
  bool status = false;

  Animal(String animalId, String descricao, String dataNascimento) {
    this.animalId = animalId;
    this.descricao = descricao;
    this.dataNascimento = dataNascimento;
  }
}
