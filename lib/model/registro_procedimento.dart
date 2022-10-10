class RegisterProcedure {
  String  id = '';
  String? animalID; // idAnimal
  String? procedureID; // idProcedimento
  String? dateRegister; // dataRegistro

  RegisterProcedure(
      String id,
      String animalID,
      String procedureID,
      String dateRegister) {
    this.id = id;
    this.animalID = animalID;
    this.procedureID = procedureID;
    this.dateRegister = dateRegister;

  }

  Map<String, dynamic> toMap() => {
    'animalID': animalID,
    'procedureID': procedureID,
    'dateRegister': dateRegister,
  };
}
