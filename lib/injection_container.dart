import 'package:core/core.dart' as core;
import 'package:feature_number_trivia/feature_number_trivia.dart'
    as feature_number_trivia;

Future<void> init() async {
  //! Features - Number Trivia
  await feature_number_trivia.init();

  ///////////////////////////////////////////////////////////////////
  //! core
  await core.init();
}
