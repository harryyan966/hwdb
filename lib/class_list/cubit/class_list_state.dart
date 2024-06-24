part of 'class_list_cubit.dart';

@immutable
class ClassListState extends Equatable {
  final PageStatus status;
  final List<ClassInfo> classes;
  final bool hasMore;
  final String keyword;

  const ClassListState({
    this.status = PageStatus.good,
    this.classes = const [],
    this.hasMore = true,
    this.keyword = '',
  });

  ClassListState copyWith({
    PageStatus? status,
    List<ClassInfo>? classes,
    bool? hasMore,
    String? keyword,
  }) {
    return ClassListState(
      status: status ?? this.status,
      classes: classes ?? this.classes,
      hasMore: hasMore ?? this.hasMore,
      keyword: keyword ?? this.keyword,
    );
  }

  @override
  List<Object> get props => [status, classes, hasMore, keyword];
}
