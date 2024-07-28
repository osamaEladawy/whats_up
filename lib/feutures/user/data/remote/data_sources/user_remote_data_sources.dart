import '../../../domain/entities/contact_entity.dart';
import '../../../domain/entities/user_entity.dart';

abstract class UserRemoteDataSource{

  Future<void>verifyPhoneNumber(String phoneNumber);
  Future<void>signInWithPhoneNumber(String smsPinCode);

  Future<bool>isSignIn();
  Future<void>signOut();
  Future<String>getCurrentUid();
  Future<void>createUserEntity(UserEntity userEntity);
  Future<void>updateUserEntity(UserEntity userEntity);

  Stream<List<UserEntity>>getAllUsers();
  Stream<List<UserEntity>>getSingleUserUid(String userUid);

  Future<List<ContactEntity>>getDeviceNumber();

}