import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ortapazar/feature/ortapazar/presentation/create_news/cubit/create_news_cubit.dart';
import 'package:ortapazar/widgets/form_textfield_widget.dart';
import 'package:ortapazar/widgets/form_title_widget.dart';

import '../../../../main.dart';

class CreateNewsView extends StatefulWidget {
  const CreateNewsView({Key? key}) : super(key: key);

  @override
  State<CreateNewsView> createState() => _CreateNewsViewState();
}

class _CreateNewsViewState extends State<CreateNewsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BlocProvider(
        create: (context) => getIt<CreateNewsCubit>(),
        child: BlocBuilder<CreateNewsCubit, CreateNewsState>(
          builder: (context, state) {
            var cubit = context.read<CreateNewsCubit>();
            return SingleChildScrollView(
              child: Column(
                children: [
                  state.file.path.isNotEmpty
                      ? Image.file(
                          state.file,
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : const FlutterLogo(),
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xffF3F3F3),
      elevation: 0,
      leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          )),
      title: const Text(
        "Haber Gönder",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 32,
        ),
      ),
    );
  }
}
