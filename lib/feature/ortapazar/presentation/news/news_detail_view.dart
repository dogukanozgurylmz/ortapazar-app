import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ortapazar/core/constants/text_style_constant.dart';
import 'package:ortapazar/feature/ortapazar/domain/entities/news_entity.dart';
import 'package:ortapazar/feature/ortapazar/presentation/news/cubit/news_detail_cubit.dart';

class NewsDetailView extends StatelessWidget {
  final NewsEntity newsEntity;

  const NewsDetailView({super.key, required this.newsEntity});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit(),
      child: BlocBuilder<NewsCubit, NewsDetailState>(
        builder: (context, state) {
          final cubit = context.read<NewsCubit>();
          return Scaffold(
              appBar: _buildAppBar(state, context),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: newsEntity.image,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(newsEntity.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        newsEntity.title,
                        style: TextStyleConstant.NEWS_TITLE,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        newsEntity.content,
                        style: TextStyleConstant.NEWS_CONTENT,
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  AppBar _buildAppBar(NewsDetailState state, BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        newsEntity.title,
        style: TextStyleConstant.APP_BAR_STYLE,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.of(context).pop(),
      ),
      leadingWidth: 40,
      backgroundColor: const Color(0xff2BA700),
      elevation: 0,
    );
  }
}
