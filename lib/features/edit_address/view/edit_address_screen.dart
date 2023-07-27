import 'package:address_book/domain/address_model.dart';
import 'package:address_book/domain/user_model.dart';
import 'package:address_book/domain/viacep_model.dart';
import 'package:address_book/features/auth/view/auth/auth_cubit.dart';
import 'package:address_book/features/auth/view/auth/auth_state.dart';
import 'package:address_book/features/home/view/blocs/manipulate_address/manipulate_address_cubit.dart';
import 'package:address_book/features/home/view/blocs/manipulate_address/manipulate_address_state.dart';
import 'package:address_book/features/home/view/blocs/viacep/viacep_cubit.dart';
import 'package:address_book/features/home/view/blocs/viacep/viacep_state.dart';
import 'package:address_book/router.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({
    super.key,
    required this.address,
  });

  final AddressModel address;

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  late final TextEditingController _postalCodeController;
  late final TextEditingController _streetController;
  late final TextEditingController _numberController;
  late final TextEditingController _cityController;
  late final TextEditingController _complementController;
  late final TextEditingController _neighborhoodController;

  late String estado;

  final _formKey = GlobalKey<FormState>();

  late final UserModel user;

  late final ManipulateAddressCubit manipulateAddressCubit;

  late final ViaCepCubit viaCepCubit;

  late final MaskTextInputFormatter postalCodeMask;

  final estados = [
    {"nome": "Acre", "sigla": "AC"},
    {"nome": "Alagoas", "sigla": "AL"},
    {"nome": "Amapá", "sigla": "AP"},
    {"nome": "Amazonas", "sigla": "AM"},
    {"nome": "Bahia", "sigla": "BA"},
    {"nome": "Ceará", "sigla": "CE"},
    {"nome": "Distrito Federal", "sigla": "DF"},
    {"nome": "Espírito Santo", "sigla": "ES"},
    {"nome": "Goiás", "sigla": "GO"},
    {"nome": "Maranhão", "sigla": "MA"},
    {"nome": "Mato Grosso", "sigla": "MT"},
    {"nome": "Mato Grosso do Sul", "sigla": "MS"},
    {"nome": "Minas Gerais", "sigla": "MG"},
    {"nome": "Pará", "sigla": "PA"},
    {"nome": "Paraíba", "sigla": "PB"},
    {"nome": "Paraná", "sigla": "PR"},
    {"nome": "Pernambuco", "sigla": "PE"},
    {"nome": "Piauí", "sigla": "PI"},
    {"nome": "Rio de Janeiro", "sigla": "RJ"},
    {"nome": "Rio Grande do Norte", "sigla": "RN"},
    {"nome": "Rio Grande do Sul", "sigla": "RS"},
    {"nome": "Rondônia", "sigla": "RO"},
    {"nome": "Roraima", "sigla": "RR"},
    {"nome": "Santa Catarina", "sigla": "SC"},
    {"nome": "São Paulo", "sigla": "SP"},
    {"nome": "Sergipe", "sigla": "SE"},
    {"nome": "Tocantins", "sigla": "TO"}
  ];

  @override
  void initState() {
    super.initState();

    _postalCodeController =
        TextEditingController(text: widget.address.postalCode);
    _streetController = TextEditingController(text: widget.address.street);
    _numberController = TextEditingController(text: widget.address.number);
    _cityController = TextEditingController(text: widget.address.city);
    _complementController =
        TextEditingController(text: widget.address.complement);
    _neighborhoodController =
        TextEditingController(text: widget.address.neighborhood);

    estado = widget.address.estado;

    user = (context.read<AuthCubit>().state as Authenticated).user;

    manipulateAddressCubit = ManipulateAddressCubit();

    viaCepCubit = ViaCepCubit();

    postalCodeMask = MaskTextInputFormatter(
        mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  }

  void updateAddress(ViaCepModel viaCepModel) {
    final newEstado = estados.firstWhereOrNull(
      (element) {
        return element['sigla'] == viaCepModel.state;
      },
    );

    setState(() {
      if (viaCepModel.street?.isNotEmpty ?? false) {
        _streetController.text = viaCepModel.street!;
      }
      if (viaCepModel.city?.isNotEmpty ?? false) {
        _cityController.text = viaCepModel.city!;
      }
      if (viaCepModel.complement?.isNotEmpty ?? false) {
        _complementController.text = viaCepModel.complement!;
      }
      if (viaCepModel.neighborhood?.isNotEmpty ?? false) {
        _neighborhoodController.text = viaCepModel.neighborhood!;
      }
      if (newEstado != null) {
        estado = newEstado['sigla']!;
      }
    });
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Address')),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<ManipulateAddressCubit, ManipulateAddressState>(
                    bloc: manipulateAddressCubit,
                    listener: (context, state) {
                      if (state is ManipulateAddressEditSuccess) {
                        router.pop(true);
                        const snackbar =
                            SnackBar(content: Text('Address updated'));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }
                    },
                  ),
                  BlocListener<ViaCepCubit, ViaCepState>(
                    bloc: viaCepCubit,
                    listener: (context, state) {
                      if (state is ViaCepSuccess) {
                        updateAddress(state.viapostalCode);
                      } else if (state is ViaCepFail) {
                        final snackbar = SnackBar(content: Text(state.error));
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }
                    },
                  ),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: '🇧🇷 Brazil',
                      hint: const Text('Country'),
                      decoration: const InputDecoration(labelText: 'Country'),
                      onChanged: (String? value) {},
                      items: const [
                        DropdownMenuItem<String>(
                          value: '🇧🇷 Brazil',
                          child: Text(
                            '🇧🇷 Brazil',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _postalCodeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(labelText: 'postalCode'),
                      inputFormatters: [postalCodeMask],
                      onChanged: (value) {
                        if (value.length == 9) {
                          final realValue = postalCodeMask.getUnmaskedText();
                          viaCepCubit.searchpostalCode(realValue);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required field';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TextFormField(
                            controller: _streetController,
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.next,
                            decoration:
                                const InputDecoration(labelText: 'Street'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required field';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextFormField(
                            controller: _numberController,
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.next,
                            decoration:
                                const InputDecoration(labelText: 'Number'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required field';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _neighborhoodController,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(labelText: 'neighborhood'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required field';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _complementController,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(labelText: 'complement'),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'city'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required field';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: estado,
                      hint: const Text('State'),
                      decoration: const InputDecoration(labelText: 'State'),
                      onChanged: (String? value) {
                        setState(() {
                          estado = value!;
                        });
                      },
                      items: estados.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> estado) {
                          return DropdownMenuItem<String>(
                            value: estado['sigla'],
                            child: Text(
                              estado['nome'],
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 64.0),
                    ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        final validate = _formKey.currentState!.validate();

                        if (validate) {
                          final newAddress = AddressModel(
                            id: widget.address.id,
                            userId: user.id!,
                            postalCode: _postalCodeController.text.trim(),
                            street: _streetController.text.trim(),
                            number: _numberController.text.trim(),
                            complement: _complementController.text.trim(),
                            neighborhood: _neighborhoodController.text.trim(),
                            city: _cityController.text.trim(),
                            estado: estado,
                          );
                          manipulateAddressCubit.updateAddress(newAddress);
                        }
                      },
                      child: const Text('Update address'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
