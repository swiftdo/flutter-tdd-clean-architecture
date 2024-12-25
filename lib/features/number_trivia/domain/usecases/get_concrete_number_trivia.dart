import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/core/error/failure.dart';
import 'package:my_flutter_app/core/usecases/usecase.dart';

import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  execute({required int number}) async {}

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}
