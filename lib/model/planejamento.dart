class Planning {
  String  id = '';
  String? description; // descrição
  String? dateBegin; // dataInicio
  String? dateEnd; // dataFim
  List<String> idFlock = []; //rebanhos
  String? procedure; // precedimento
  bool? status = true ;

  Planning(
      String id,
      String description,
      String dateBegin,
      String dateEnd,
      List<String> idFlock,
      String procedure,
      bool status) {
    this.id = id;
    this.description = description;
    this.dateBegin = dateBegin;
    this.dateEnd = dateEnd;
    this.idFlock = idFlock;
    this.procedure = procedure;
    this.status = status;

  }

  Map<String, dynamic> toMap() => {
    'description': description,
    'dateBegin': dateBegin,
    'dateEnd': dateEnd,
    'idFlock': idFlock,
    'procedure': procedure,
    'status': status,
  };
}
