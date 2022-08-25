import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_detail_state.dart';

class NewsCubit extends Cubit<NewsDetailState> {
  // NewsModel newsModel;
  // late FirebaseFirestore firestore;
  // late Stream<QuerySnapshot> newsStream;
  NewsCubit() : super(NewsDetailState()) {
    init();
  }

  init() {
    // firestore = FirebaseFirestore.instance;
    // newsStream = firestore.collection('news').snapshots();
    // getNewsById();
  }

  Future<void> getNewsById() async {
    // emit(state.copyWith(dataLoading: false, newsModel: newsModel));
  }
}
