import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/feature/ortapazar/presentation/my_news/cubit/my_news_cubit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/text_style_constant.dart';
import '../../../../main.dart';

class MyNewsView extends StatelessWidget {
  const MyNewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyNewsCubit>(),
      child: BlocBuilder<MyNewsCubit, MyNewsState>(
        builder: (context, state) {
          final cubit = context.read<MyNewsCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Haberlerim",
                style: TextStyleConstant.APP_BAR_STYLE,
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              leadingWidth: 30,
              backgroundColor: const Color(0xff65BD47),
              elevation: 0,
              toolbarHeight: 50,
            ),
            body: state.isLoading
                ? SafeArea(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: PageView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Card(
                              elevation: 1.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.myNews.length,
                    itemBuilder: (context, index) {
                      return !state.isLoading
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: _buildFeedScreen(
                                      state, cubit, index, context),
                                ),
                              ],
                            )
                          : const CircularProgressIndicator();
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFeedScreen(
    MyNewsState state,
    MyNewsCubit cubit,
    int index,
    BuildContext context,
  ) {
    return Container(
      // height: 250,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xffF4F4F4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: -7,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                state.myNews[index].title,
                style: TextStyleConstant.MY_NEWS_TITLE,
                overflow: TextOverflow.clip,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  child: Image.network(
                    state.myNews[index].image,
                    fit: BoxFit.cover,
                    height: 200,
                    width: 125,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 130,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        state.myNews[index].content,
                        style: TextStyleConstant.MY_NEWS_CONTENT,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const SizedBox(height: 20),
                    state.myNews[index].isConfirm
                        ? _buildApprovedOrWaiting(
                            context,
                            backgroundColor: const Color(0xff65BD47),
                            text: "Onaylandı",
                          )
                        : _buildApprovedOrWaiting(
                            context,
                            backgroundColor: const Color(0xffFF8A00),
                            text: "Bekleniyor...",
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildApprovedOrWaiting(
    BuildContext context, {
    required Color backgroundColor,
    required String text,
  }) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  final MyNewsState state;
  final int index;
  const PhotoScreen({Key? key, required this.state, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(imageProvider: NetworkImage(state.news[index].image));
  }
}
