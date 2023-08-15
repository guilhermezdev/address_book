class ViaCepModel {
  final String? postalCode;
  final String? street;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? state;

  ViaCepModel({
    required this.postalCode,
    required this.street,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  factory ViaCepModel.fromJson(Map<String, dynamic> json) => ViaCepModel(
        postalCode: json['cep'],
        street: json['logradouro'],
        complement: json['complemento'],
        neighborhood: json['bairro'],
        city: json['localidade'],
        state: json['uf'],
      );
}
