import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/core/widgets/blur_background.dart';
import 'package:ortapazar/feature/ortapazar/presentation/favorite/cubit/favorite_cubit.dart';
import 'package:photo_view/photo_view.dart';

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
          return Stack(
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
    cubit.init();
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
              state.news[index].image.isNotEmpty
                  ? state.news[index].image
                  : "https://wallpaperaccess.com/full/1958270.jpg",
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
                                child: const Icon(
                                  Icons.bookmark,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  cubit.changeSavedNews(index);
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
