class AddressModel {
  final int? id;
  final int userId;
  final String postalCode;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String estado;

  AddressModel({
    this.id,
    required this.userId,
    required this.postalCode,
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.estado,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'],
        userId: json['userId'],
        postalCode: json['postalCode'],
        street: json['street'],
        number: json['number'],
        complement: json['complement'],
        neighborhood: json['neighborhood'],
        city: json['city'],
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'userId': userId,
        'postalCode': postalCode,
        'street': street,
        'complement': complement,
        'neighborhood': neighborhood,
        'city': city,
        'estado': estado,
      };
}
