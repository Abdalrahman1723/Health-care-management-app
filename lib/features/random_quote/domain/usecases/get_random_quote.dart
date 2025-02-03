// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failure.dart';
import 'package:quotes/core/usecases/usecase.dart';
import 'package:quotes/features/random_quote/domain/entities/quote.dart';
import 'package:quotes/features/random_quote/domain/repositories/quote_repository.dart';

class GetRandomQuote implements UseCase<Quote, NoParams> {

  final QuoteRepository repository;

  GetRandomQuote({required this.repository});

  @override
  Future<Either<Failure, Quote>> call() => repository.getRandomQuote();
}