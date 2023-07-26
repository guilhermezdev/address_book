import 'package:address_book/common/loading_widget.dart';
import 'package:address_book/domain/address_model.dart';
import 'package:address_book/domain/user_model.dart';
import 'package:address_book/features/auth/view/auth/auth_cubit.dart';
import 'package:address_book/features/auth/view/auth/auth_state.dart';
import 'package:address_book/features/home/view/blocs/address_list/address_list_cubit.dart';
import 'package:address_book/features/home/view/blocs/address_list/address_list_state.dart';
import 'package:address_book/features/home/view/blocs/manipulate_address/manipulate_address_cubit.dart';
import 'package:address_book/features/home/view/blocs/manipulate_address/manipulate_address_state.dart';
import 'package:address_book/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserModel user;

  late final AddressListCubit addressListCubit;

  late final ManipulateAddressCubit manipulateAddressCubit;

  @override
  void initState() {
    super.initState();
    user = (context.read<AuthCubit>().state as Authenticated).user;
    addressListCubit = AddressListCubit();
    addressListCubit.loadAddressList(user.id!);

    manipulateAddressCubit = ManipulateAddressCubit();
  }

  void onTap(AddressModel address) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () async {
              Navigator.of(context).pop();
              final response =
                  await router.push('/edit-address', extra: address);
              if (response == true) {
                addressListCubit.loadAddressList(user.id!);
              }
            },
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              manipulateAddressCubit.removeAddress(address.id!);
              Navigator.of(context).pop();
            },
            leading: const Icon(Icons.delete_outline),
            title: const Text('Remove'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Addresses'),
          leading: Container(),
          leadingWidth: 0.0,
          actions: [
            IconButton(
              onPressed: () {
                router.push('/profile');
              },
              icon: const Icon(
                Icons.person_outline,
              ),
            )
          ],
        ),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              router.pushReplacement('/login');
            }
          },
          child: BlocListener<ManipulateAddressCubit, ManipulateAddressState>(
            bloc: manipulateAddressCubit,
            listener: (context, state) {
              if (state is ManipulateAddressRemoveSuccess) {
                addressListCubit.loadAddressList(user.id!);
              }
            },
            child: BlocBuilder<AddressListCubit, AddressListState>(
              bloc: addressListCubit,
              builder: (context, state) {
                if (state is AddressListFail) {
                  return Center(
                    child: Text(state.error),
                  );
                }

                if (state is AddressListSuccess) {
                  final addresses = state.addresses;

                  if (addresses.isEmpty) {
                    return const Center(
                      child: Text('No address found!'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: addresses.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 4.0),
                      itemBuilder: (context, index) {
                        final address = addresses[index];

                        if (index == addresses.length - 1) {
                          return Column(
                            children: [
                              AddressCard(address, () => onTap(address)),
                              const SizedBox(height: 40.0)
                            ],
                          );
                        }
                        return AddressCard(address, () => onTap(address));
                      },
                    ),
                  );
                }

                return const Center(
                  child: LoadingWidget(),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff221C1C),
          onPressed: () async {
            final response = await router.push('/new-address');
            if (response == true) {
              addressListCubit.loadAddressList(user.id!);
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final AddressModel address;

  const AddressCard(this.address, this.onTap, {super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          title: Text(address.rua),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${address.neighborhood}, ${address.city} - ${address.estado}'),
              if (address.complement.isNotEmpty) Text(address.complement),
            ],
          ),
          trailing: const Icon(Icons.more_vert_outlined),
        ),
      ),
    );
  }
}
