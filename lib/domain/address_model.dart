class AddressModel {
  final int? id;
  final int userId;
  final String postalCode;
  final String rua;
  final String complement;
  final String neighborhood;
  final String city;
  final String estado;

  AddressModel({
    this.id,
    required this.userId,
    required this.postalCode,
    required this.rua,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.estado,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'],
        userId: json['userId'],
        postalCode: json['postalCode'],
        rua: json['rua'],
        complement: json['complement'],
        neighborhood: json['neighborhood'],
        city: json['city'],
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'userId': userId,
        'postalCode': postalCode,
        'rua': rua,
        'complement': complement,
        'neighborhood': neighborhood,
        'city': city,
        'estado': estado,
      };
}
