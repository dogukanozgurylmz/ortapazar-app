import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/core/constants/text_style_constant.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/ortapazar_auth.dart';
import 'package:ortapazar/feature/ortapazar/presentation/favorite/favorite_view.dart';
import 'package:ortapazar/feature/ortapazar/presentation/my_news/my_news_view.dart';
import 'package:ortapazar/feature/ortapazar/presentation/settings/settings_view.dart';
import 'package:ortapazar/main.dart';

import '../admin_panel/news_confirm/news_confirm_view.dart';
import 'cubit/profile_cubit.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrtapazarAuth().firebaseAuth.currentUser == null
        ? const SizedBox.shrink()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Profil",
                style: TextStyleConstant.APP_BAR_STYLE,
              ),
              backgroundColor: const Color(0xff1C6D00),
              elevation: 0,
              toolbarHeight: 50,
            ),
            body: BlocProvider(
              create: (context) => getIt<ProfileCubit>(),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final cubit = context.read<ProfileCubit>();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                image: DecorationImage(
                                  image: state.user.photoUrl.isNotEmpty
                                      ? NetworkImage(state.user.photoUrl)
                                      : const AssetImage(
                                              "assets/images/ortapazar_icon.png")
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xff1C6D00)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            state.user.displayName,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w100,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 50),
                          _profileCategory(
                            context,
                            iconBackgroundColor: const Color(0xff65BD47),
                            icon: const Icon(
                              Icons.newspaper,
                              color: Colors.white,
                            ),
                            name: "Haberlerim",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const MyNewsView(),
                              ));
                            },
                          ),
                          const SizedBox(height: 30),
                          _profileCategory(
                            context,
                            iconBackgroundColor: const Color(0xff5B79E3),
                            icon: const Icon(
                              Icons.bookmark,
                              color: Colors.white,
                            ),
                            name: "Kaydettiklerim",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const FavoriteView(),
                              ));
                            },
                          ),
                          const SizedBox(height: 30),
                          _profileCategory(
                            context,
                            iconBackgroundColor: const Color(0xff5BBAE3),
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            name: "Ayarlar",
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SettingsView(),
                              ));
                            },
                          ),
                          const SizedBox(height: 30),
                          OrtapazarAuth().firebaseAuth.currentUser!.uid ==
                                  "hMaWuyEB7aTd4aPsStJzcojhb3O2"
                              ? Column(
                                  children: [
                                    _profileCategory(
                                      context,
                                      iconBackgroundColor:
                                          const Color(0xff555555),
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                      name: "Admin Haber Onay??",
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const NewsConfirmView(),
                                        ));
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  Row _profileCategory(BuildContext context,
      {required Color iconBackgroundColor,
      required Icon icon,
      required String name,
      required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: icon,
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w100,
            color: Colors.grey[800],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[700],
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}
