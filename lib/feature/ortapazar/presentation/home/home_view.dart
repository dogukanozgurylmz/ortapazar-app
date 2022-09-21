import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/core/widgets/blur_background.dart';
import 'package:ortapazar/feature/ortapazar/data/datasource/ortapazar_auth.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/text_style_constant.dart';
import '../../../../main.dart';
import 'cubit/home_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return FirebaseAuth.instance.currentUser == null
              ? const SizedBox.shrink()
              : Scaffold(
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
                                          MediaQuery.of(context).size.height *
                                              0.3,
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
                                return _buildFeedScreen(
                                  state,
                                  cubit,
                                  index,
                                  context,
                                );
                              },
                            ),
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Colors.white.withOpacity(0.15),
                                    Colors.white.withOpacity(0),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, top: 35),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  child: const Icon(
                                    Icons.refresh,
                                    size: 30,
                                  ),
                                  onTap: () async => await cubit.refresh(),
                                ),
                              ),
                            ),
                          ],
                        ),
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
            image: state.news[index].image.isNotEmpty
                ? NetworkImage(
                    state.news[index].image,
                  )
                : const AssetImage("assets/images/ortapazar_icon.png")
                    as ImageProvider,
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
                            width: 250,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    cubit.userControl(state.news[index].userId),
                                    style: TextStyleConstant.CURRENT_USER,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                              state.isSavedNews
                                  ? const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(),
                                    )
                                  : GestureDetector(
                                      child: state.savedNews
                                              .where((element) =>
                                                  element.newsId ==
                                                      state.news[index].id &&
                                                  element.userId ==
                                                      OrtapazarAuth()
                                                          .firebaseAuth
                                                          .currentUser!
                                                          .uid)
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
