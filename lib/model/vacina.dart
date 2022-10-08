class Vaccine {
  String  id = '';
  String? description; // descrição
  String? dateFabrication; // data Fabricação
  String? dateValidity; // data de validade
  String? laboratory; // precedimento
  bool? status = true ;

  Vaccine(
      String id,
      String description,
      String dateFabrication,
      String dateEnd,
      List<String> idFlock,
      String procedure,
      bool status) {
    this.id = id;
    this.description = description;
    this.dateFabrication = dateFabrication;
    this.dateValidity = dateValidity;
    this.laboratory = laboratory;
    this.status = status;

  }

  Map<String, dynamic> toMap() => {
    'description': description,
    'dateFabrication': dateFabrication,
    'dateValidity': dateValidity,
    'laboratory': laboratory,
    'status': status,
  };
}
