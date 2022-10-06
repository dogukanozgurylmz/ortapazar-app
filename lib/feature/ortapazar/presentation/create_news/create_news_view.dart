import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ortapazar/feature/ortapazar/presentation/create_news/cubit/create_news_cubit.dart';
import 'package:ortapazar/widgets/form_title_widget.dart';

import '../../../../core/constants/text_style_constant.dart';
import '../../../../main.dart';

class CreateNewsView extends StatelessWidget {
  const CreateNewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocProvider(
        create: (context) => getIt<CreateNewsCubit>(),
        child: BlocBuilder<CreateNewsCubit, CreateNewsState>(
          builder: (context, state) {
            var cubit = context.read<CreateNewsCubit>();
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  state.file.path.isNotEmpty
                      ? ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Image.file(
                            state.file,
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.5,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          cubit.getImage(ImageSource.camera);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color(0xffD9D9D9),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Fotoğraf çek",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          cubit.getImage(ImageSource.gallery);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: const Color(0xffD9D9D9),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "Galeriden ekle",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const FormTitleWidget(title: "Haberin Başlığı"),
                          TextFormField(
                            controller: cubit.newsTitleController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 15,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 0.2,
                                  color: Color(0xffD9D9D9),
                                ),
                              ),
                              hintText: "Haberin Başlığı",
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const FormTitleWidget(title: "Haberin İçeriği"),
                          TextFormField(
                            controller: cubit.newsContentController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 15,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 0.2,
                                  color: Color(0xffD9D9D9),
                                ),
                              ),
                              hintText: "Haberin İçeriği",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  state.isLoading
                      ? const CircularProgressIndicator()
                      : InkWell(
                          onTap: () async {
                            await cubit.addNews();
                          },
                          child: Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: const Color(0xffD9D9D9),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Center(
                              child: Text(
                                "Ekle",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                        ),
                  state.isLoadAd
                      ? Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: AdWidget(ad: cubit.bannerAd),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Haber Ekle",
        style: TextStyleConstant.APP_BAR_STYLE,
      ),
      toolbarHeight: 45,
      backgroundColor: const Color(0xff1C6D00),
      elevation: 0,
    );
  }
}
