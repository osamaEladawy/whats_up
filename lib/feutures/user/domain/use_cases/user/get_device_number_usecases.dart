import 'package:whats_app/feutures/user/domain/repositories/user_repository.dart';

import '../../entities/contact_entity.dart';

class GetDeviceNumberUseCases{
  final UserRepository repository;

  GetDeviceNumberUseCases({required this.repository});

  Future<List<ContactEntity>>call()async{
    return repository.getDeviceNumber();
  }
}