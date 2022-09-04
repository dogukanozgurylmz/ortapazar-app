import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/core/widgets/blur_background.dart';
import 'package:ortapazar/feature/ortapazar/presentation/favorite/cubit/favorite_cubit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/text_style_constant.dart';
import '../../../../main.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FavoriteCubit>(),
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          final cubit = context.read<FavoriteCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Kaydettiklerim",
                style: TextStyleConstant.APP_BAR_STYLE,
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              leadingWidth: 30,
              backgroundColor: const Color(0xff5B79E3),
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
                : Stack(
                    children: [
                      PageView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const PageScrollPhysics(),
                        itemCount: state.news.length,
                        itemBuilder: (context, index) {
                          return !state.isLoading
                              ? _buildFeedScreen(state, cubit, index, context)
                              : const CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFeedScreen(
    FavoriteState state,
    FavoriteCubit cubit,
    int index,
    BuildContext context,
  ) {
    return GestureDetector(
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
                            height: 20,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    state.news[index].currentUser,
                                    style: TextStyleConstant.CURRENT_USER,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
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
                                onTap: () async {
                                  await cubit.changeSavedNews(index);
                                  await cubit.refresh();
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
    FavoriteState state,
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
  final FavoriteState state;
  final int index;
  const PhotoScreen({Key? key, required this.state, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhotoView(imageProvider: NetworkImage(state.news[index].image));
  }
}
