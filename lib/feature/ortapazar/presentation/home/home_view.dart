import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/core/widgets/blur_background.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/constants/text_style_constant.dart';
import '../../../../main.dart';
import 'cubit/home_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                physics: const PageScrollPhysics(),
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  return state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildFeedScreen(
                          state,
                          cubit,
                          index,
                          context,
                        );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeedScreen(
    HomeState state,
    HomeCubit cubit,
    int index,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () async => {
        await cubit.init(),
      },
      onLongPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PhotoScreen(
              state: state,
              index: index,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              state.news[index].image,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BlurBackgroundWidget(
                    blur: 5,
                    opacity: 0.5,
                    borderRadius: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 105,
                            height: 20,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    state.news[index].title,
                                    style: TextStyleConstant.NEWS_TITLE,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                child: state.savedNews
                                        .where((element) =>
                                            element.newsId ==
                                            state.news[index].id)
                                        .isEmpty
                                    ? const Icon(
                                        Icons.bookmark_border,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.bookmark,
                                        color: Colors.white,
                                      ),
                                onTap: () {
                                  cubit.changeSavedNews(index);
                                  cubit.init();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: state.news[index].content.length > 200 ? 250 : null,
              child: BlurBackgroundWidget(
                blur: 5,
                opacity: 0.5,
                borderRadius: 15,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      state.news[index].content,
                      style: TextStyleConstant.NEWS_CONTENT,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
    HomeState state,
    int index,
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: PhotoView(
          imageProvider: NetworkImage(state.news[index].image),
        ),
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  final HomeState state;
  final int index;
  const PhotoScreen({Key? key, required this.state, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(imageProvider: NetworkImage(state.news[index].image));
  }
}
