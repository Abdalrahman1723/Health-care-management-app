import 'package:equatable/equatable.dart';

// Equatable is used to compare objects of the same type
//the link to the package: https://pub.dev/packages/equatable
class Quote extends Equatable {
  final String author;
  final int id;
  final String content;
  final String permalink;

  const Quote(
      {required this.author,
      required this.id,
      required this.content,
      required this.permalink});

  @override
  List<Object?> get props => [author, id, content, permalink];
}
