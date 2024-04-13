import 'package:whats_app/feutures/user/domain/repositories/user_repository.dart';

import '../../entities/user_entity.dart';

class GetSingleUserUseCases{
  final UserRepository repository;

  GetSingleUserUseCases({required this.repository});

  Future<Stream<List<UserEntity>>>call (String userUid)async{
    return repository.getSingleUserUid(userUid);
  }
}