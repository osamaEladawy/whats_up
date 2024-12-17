import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_up/core/const/app_const.dart';
import 'package:whats_up/core/theme/style.dart';
import 'package:whats_up/my_app.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/credential/sign_in_with_phone_number_usecases.dart';
import '../../../domain/use_cases/credential/verify_phone_number_usecases.dart';
import '../../../domain/use_cases/user/create_user_usecases.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInWithPhoneNumberUseCases signInUseCases;
  final VerifyPhoneNumberUseCases verifyWithPhoneNumberUseCases;
  final CreateUserUseCases createUserUseCases;

  CredentialCubit(
      {required this.createUserUseCases,
      required this.signInUseCases,
      required this.verifyWithPhoneNumberUseCases})
      : super(CredentialInitial());

  static final CredentialCubit _credentialCubit =
      BlocProvider.of(navigatorKey.currentContext!);
  static CredentialCubit get instance => _credentialCubit;

  TextEditingController phoneController = TextEditingController();
  Country selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode("20");
  late String countryCode = selectedFilteredDialogCountry.phoneCode;
  final myKey = GlobalKey<FormState>();
  bool? isValid;
  String phoneNumber = '';

  Future<void> submitVerifyPhoneNumber({required String phoneNumber}) async {
    try {
      await verifyWithPhoneNumberUseCases.call(phoneNumber);
      emit(CredentialPhoneAuthSmsCodeReceived());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> submitSmsCode({required String smsPinCode}) async {
    try {
      await signInUseCases.call(smsPinCode);
      emit(CredentialPhoneAuthProfileInfo());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> submitProfileInfo({required UserEntity userEntity}) async {
    try {
      await createUserUseCases.call(userEntity);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  void mySubmitVerifyPhoneNumber() {
    if (phoneController.text.isNotEmpty) {
      phoneNumber = "+$countryCode${phoneController.text}";
      print("phoneNumber $phoneNumber");
      submitVerifyPhoneNumber(phoneNumber: phoneNumber);
      // BlocProvider.of<CredentialCubit>(navigatorKey.currentContext!)
      //     .submitVerifyPhoneNumber(
      //   phoneNumber: phoneNumber,
      // );
    } else {
      toast("Enter your phone number");
    }
  }

  void openFilteredCountryPickerDialog() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => Theme(
        data: Theme.of(navigatorKey.currentContext!).copyWith(
          primaryColor: tabColor,
        ),
        child: CountryPickerDialog(
          titlePadding: const EdgeInsets.all(8.0),
          searchCursorColor: tabColor,
          searchInputDecoration: const InputDecoration(
            hintText: "Search",
          ),
          isSearchable: true,
          title: const Text("Select your phone code"),
          onValuePicked: (Country country) {
            // setState(() {
            selectedFilteredDialogCountry = country;
            emit(SelectCountry());
            countryCode = country.phoneCode;
            emit(SelectCountryCode());
            // });
          },
          itemBuilder:(country){
            return buildDialogItem(country);
          } ,
        ),
      ),
    );
  }

  Widget  buildDialogItem(Country country) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: tabColor, width: 1.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Text(" +${country.phoneCode}"),
          Expanded(
            child: Text(
              " ${country.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
