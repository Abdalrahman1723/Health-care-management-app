import 'package:dartz/dartz.dart';
import 'package:quotes/core/error/failure.dart';
import 'package:quotes/features/random_quote/domain/entities/quote.dart';

// this is the abstract class that will be implemented in the data layer
abstract class QuoteRepository  {
  Future<Either<Failure,Quote>> getRandomQuote();
}