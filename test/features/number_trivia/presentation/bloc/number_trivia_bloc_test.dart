import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';
import 'package:my_flutter_app/core/error/failure.dart';
import 'package:my_flutter_app/core/util/input_converter.dart';
import 'package:my_flutter_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:my_flutter_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:my_flutter_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:my_flutter_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'number_trivia_bloc_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateNiceMocks([
  MockSpec<InputConverter>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<GetConcreteNumberTrivia>(),
])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
  });

  NumberTriviaBloc buildBloc() => NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      );

  test('initialState should be Empty', () {
    final bloc = buildBloc();
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    // The event takes in a String
    const tNumberString = '1';
    // This is the successful output of the InputConverter
    final tNumberParsed = int.parse(tNumberString);
    // NumberTrivia instance is needed too, of course
    final tNumberTrivia = const NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      build: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        const StateError(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        const StateError(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        Loading(),
        const StateError(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return buildBloc();
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return buildBloc();
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        const StateError(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return buildBloc();
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        const StateError(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
