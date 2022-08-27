import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ortapazar/feature/ortapazar/presentation/create_news/cubit/create_news_cubit.dart';
import 'package:ortapazar/widgets/form_textfield_widget.dart';
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
                      ? Image.file(
                          state.file,
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.5,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () => cubit.getImage(ImageSource.camera),
                        child: const Text("Fotoğraf çek"),
                      ),
                      MaterialButton(
                        onPressed: () => cubit.getImage(ImageSource.gallery),
                        child: const Text("Galeriden ekle"),
                      ),
                    ],
                  ),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const FormTitleWidget(title: "Haberin Başlığı"),
                          FormTextFieldWidget(
                            hintText: "Haberin Başlığı",
                            controller: cubit.newsTitleController,
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
                              ),
                              hintText: "Haberin İçeriği",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => cubit.addNews(),
                    child: const Text("ekle"),
                  ),
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
