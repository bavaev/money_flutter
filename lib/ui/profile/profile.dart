import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_accounting/app.dart';
import 'package:personal_accounting/business/bloc/auth/auth_bloc.dart';
import 'package:personal_accounting/business/bloc/image/image_bloc.dart';
import 'package:personal_accounting/ui/components/confirm_delete.dart';
import 'package:personal_accounting/ui/widgets/bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:personal_accounting/business/models/user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserApp? user;

  @override
  void didChangeDependencies() {
    user = context.read<AuthBloc>().state.props[0] as UserApp;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        centerTitle: true,
        title: Text(
          'Профиль',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ImageBloc, ImageState>(
              builder: (context, state) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFD0D0D0),
                      radius: 50,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              BlocProvider.of<ImageBloc>(context).add(GetImage());
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: state is ImageInitial
                                  ? const Icon(
                                      Icons.camera_alt,
                                      color: Color(0xFFABABAB),
                                      size: 32,
                                    )
                                  : state is GetImageGallery
                                      ? ClipOval(
                                          child: Image.file(
                                            File(state.image!.path),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : state is UploadAwait
                                          ? const CircularProgressIndicator()
                                          : BlocBuilder<AuthBloc, AuthState>(
                                              builder: (context, state) {
                                                if (state is AuthAuthentificated) {
                                                  return state.avatarUrl != null
                                                      ? ClipOval(
                                                          child: CachedNetworkImage(
                                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                                            imageUrl: state.avatarUrl!,
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        )
                                                      : const Icon(
                                                          Icons.camera_alt,
                                                          color: Color(0xFFABABAB),
                                                          size: 32,
                                                        );
                                                }
                                                return Container();
                                              },
                                            ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: state is GetImageGallery,
                      child: TextButton(
                        onPressed: () {
                          if (state is GetImageGallery) {
                            BlocProvider.of<ImageBloc>(context).add(ImageUpload(user!.id, state.image as XFile));
                          }
                        },
                        child: const FittedBox(child: Text('Сохранить')),
                      ),
                    ),
                  ],
                );
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            state is AuthAuthentificated ? state.user!.email.toString() : '',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        TextButton(
                          onPressed: () {
                            showConfirmDeleteDialog(
                              context: context,
                              type: 'deleteAllData',
                            );
                          },
                          child: const FittedBox(child: Text('Очистить данные')),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthSignout());
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyApp()), (route) => false);
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(const Size(180, 50)),
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF9053EB)),
                          ),
                          child: state is AuthAuthentificated ? const FittedBox(child: Text('Выйти')) : const CircularProgressIndicator(),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
