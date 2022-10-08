class Flock {
  String  id = '';
  String? description; // descrição
  String? maximumAmount; // quantidade máxima
  String? farm; //fazenda
  String? herdDate; //data rebanho
  bool? status = true ;

  Flock(
      String id,
      String description,
      String maximumAmount,
      String farm,
      String herdDate,
      bool status) {
    this.id = id;
    this.description = description;
    this.maximumAmount = maximumAmount;
    this.farm = farm;
    this.herdDate = herdDate;
    this.status = status;
  }

  Map<String, dynamic> toMap() => {
    'description': description,
    'maximumAmount': maximumAmount,
    'farm': farm,
    'herdDate': herdDate,
    'status': status,
  };
}
