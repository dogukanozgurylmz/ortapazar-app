import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/feature/ortapazar/presentation/admin_panel/news_confirm/cubit/news_confirm_cubit.dart';
import 'package:ortapazar/main.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/constants/text_style_constant.dart';

class NewsConfirmView extends StatelessWidget {
  const NewsConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NewsConfirmCubit>(),
      child: BlocBuilder<NewsConfirmCubit, NewsConfirmState>(
        builder: (context, state) {
          final cubit = context.read<NewsConfirmCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Profil",
                style: TextStyleConstant.APP_BAR_STYLE,
              ),
              backgroundColor: const Color(0xff555555),
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
                    itemCount: state.news.length,
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
    NewsConfirmState state,
    NewsConfirmCubit cubit,
    int index,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        showModal(
          context,
          title: state.news[index].title,
          content: state.news[index].content,
          url: state.news[index].image,
          userName: cubit.userControl(state.news[index].userId),
        );
      },
      child: Container(
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
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.news[index].title,
                  style: TextStyleConstant.MY_NEWS_TITLE,
                  overflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.news[index].content,
                  style: TextStyleConstant.MY_NEWS_CONTENT,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cubit.userControl(state.news[index].userId),
                    style: TextStyleConstant.MY_NEWS_TITLE,
                    overflow: TextOverflow.clip,
                  ),
                  !state.isConfirm
                      ? Switch(
                          value: state.news[index].isConfirm,
                          onChanged: (value) async {
                            await cubit.changeIsConfirm(
                                value, state.news[index]);
                          },
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showModal(
    BuildContext context, {
    required String title,
    required String content,
    required String url,
    required String userName,
  }) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        useRootNavigator: true,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Image.network(
                            url,
                            height: MediaQuery.of(context).size.height * 1,
                            width: MediaQuery.of(context).size.width * 1,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            userName,
                            style: TextStyleConstant.MY_NEWS_TITLE,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            title,
                            style: TextStyleConstant.MY_NEWS_TITLE,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            content,
                            style: TextStyleConstant.MY_NEWS_CONTENT,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 3,
                  indent: MediaQuery.of(context).size.width * 0.4,
                  endIndent: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
            ),
          );
        });
  }
}
