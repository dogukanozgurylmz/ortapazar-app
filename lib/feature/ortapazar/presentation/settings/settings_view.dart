import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/core/constants/text_style_constant.dart';
import 'package:ortapazar/feature/ortapazar/presentation/settings/cubit/settings_cubit.dart';
import 'package:ortapazar/feature/ortapazar/presentation/splash/splash_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Ayarlar",
                style: TextStyleConstant.APP_BAR_STYLE,
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              leadingWidth: 30,
              backgroundColor: const Color(0xff5BBAE3),
              elevation: 0,
              toolbarHeight: 50,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _settingsCategory(
                    context,
                    iconBackgroundColor: const Color(0xff5BBAE3),
                    icon: const Icon(
                      Icons.manage_accounts,
                      color: Colors.white,
                      size: 30,
                    ),
                    name: "Kullanıcı ayarlar",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Text("Kullanıcı ayarlar"),
                      ));
                    },
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      await cubit.signOut();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SplashView(),
                      ));
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.output_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Çıkış yap",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row _settingsCategory(BuildContext context,
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
            fontSize: 20,
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
