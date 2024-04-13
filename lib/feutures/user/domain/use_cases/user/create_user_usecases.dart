import 'package:whats_app/feutures/user/domain/entities/user_entity.dart';
import 'package:whats_app/feutures/user/domain/repositories/user_repository.dart';

class CreateUserUseCases{
  final UserRepository repository;

  CreateUserUseCases({required this.repository});

  Future<void>call (UserEntity userEntity)async{
    return  repository.createUserEntity(userEntity);
  }
}