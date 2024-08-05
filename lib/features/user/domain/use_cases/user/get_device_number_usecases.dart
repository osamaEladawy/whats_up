
import '../../entities/contact_entity.dart';
import '../../repositories/user_repository.dart';

class GetDeviceNumberUseCases{
  final UserRepository repository;

  GetDeviceNumberUseCases({required this.repository});

  Future<List<ContactEntity>>call()async{
    return repository.getDeviceNumber();
  }
}