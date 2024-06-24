import 'package:bloc/bloc.dart';
import 'package:client_tools/client_tools.dart';
import 'package:tools/tools.dart';

part 'class_list_state.dart';

class ClassListCubit extends Cubit<ClassListState> {
  ClassListCubit({
    required HwdbHttpClient httpClient,
  })  : _httpClient = httpClient,
        super(const ClassListState());

  final HwdbHttpClient _httpClient;

  static const kLoadCount = 20;

  /// Load one more page of classes on the ui.
  Future<void> loadMoreClasses() async {
    // Ensure the page is not loading.
    if (state.status.isLoading) {
      return;
    }

    // Ensure there are more classes left.
    if (!state.hasMore) {
      return;
    }

    emit(state.copyWith(status: PageStatus.loading));

    // Get one page worth of classes.
    final res = await _httpClient.get('classes', {
      'start': state.classes.length,
      'count': kLoadCount,
      'keyword': state.keyword,
    });

    // If the classes are got
    if (Events.gotClasses.matches(res['event'])) {
      final newClasses = ConversionTools.toJsonTypeList(res['data']['classes'], ClassInfo.fromJson);
      final hasMore = res['data']['hasMore'];

      emit(state.copyWith(
        status: PageStatus.good,
        classes: [...state.classes, ...newClasses],
        hasMore: hasMore,
      ));
    }

    // If an error is thrown
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Search classes with a modified set of query.
  Future<void> searchClasses(String keyword) async {
    if (state.status.isLoading) {
      return;
    }

    emit(state.copyWith(status: PageStatus.loading));

    // Get classes with new query filters.
    final res = await _httpClient.get('classes', {
      'count': kLoadCount,
      'keyword': keyword,
    });

    // If the classes are returned
    if (Events.gotClasses.matches(res['event'])) {
      final data = res['data'];
      final classes = ConversionTools.toJsonTypeList(data['classes'], ClassInfo.fromJson);
      final hasMore = data['hasMore'];

      emit(state.copyWith(
        status: PageStatus.good,
        classes: classes,
        hasMore: hasMore,
      ));
    }

    // If an error is thrown
    else {
      emit(state.copyWith(status: PageStatus.bad));
      throw Exception(res.pretty());
    }
  }

  /// Refresh the class list.
  Future<void> refreshClasses() async {
    await searchClasses(state.keyword);
  }
}
