import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

import '../../../../views/home/home_page.dart';
import '../../../app/const/app_const.dart';
import '../../../app/globel/functions/validate.dart';
import '../../../app/globel/widgets/next_button.dart';
import '../../../theme/style.dart';
import '../manager/auth/auth_cubit.dart';
import '../manager/cerdential/credential_cubit.dart';
import 'initial_profile_page.dart';
import 'verify_code.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  static Country _selectedFilteredDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode("20");
  String _countryCode = _selectedFilteredDialogCountry.phoneCode;
  final _myKey = GlobalKey<FormState>();
  bool? isValid;
  String _phoneNumber = '';



  void _submitVerifyPhoneNumber() {
    if (_phoneController.text.isNotEmpty) {
      _phoneNumber="+$_countryCode${_phoneController.text}";
      print("phoneNumber $_phoneNumber");
      BlocProvider.of<CredentialCubit>(context).submitVerifyPhoneNumber(
        phoneNumber: _phoneNumber,
      );
    } else {
      toast("Enter your phone number");
    }
  }

  void _openFilteredCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (_) => Theme(
        data: Theme.of(context).copyWith(
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
            setState(() {
              _selectedFilteredDialogCountry = country;
              _countryCode = country.phoneCode;
            });
          },
          itemBuilder: _buildDialogItem,
        ),
      ),
    );
  }

  Widget _buildDialogItem(Country country) {
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

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialListenerState) {
        if(credentialListenerState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if(credentialListenerState is CredentialFailure) {
          toast("Something went wrong");
        }
      },
      builder: (context, credentialBuilderState) {
        if(credentialBuilderState is CredentialLoading) {
          return const Center(child: CircularProgressIndicator(color: tabColor,),);
        }
        if(credentialBuilderState is CredentialPhoneAuthSmsCodeReceived) {
          return const VerifyCode();
        }
        if(credentialBuilderState is CredentialPhoneAuthProfileInfo) {
          return InitialProfilePage(phoneNumber: _phoneNumber,);
        }
        if(credentialBuilderState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context,AuthState authState){
              if(authState is Authenticated) {
                return HomePage(uid: authState.userUid,);
              }
              return _bodyWidget();
            },
          );
        }
        return _bodyWidget();
      },

    );
  }

  Widget _bodyWidget() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Verify Your phone number",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: tabColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("""
    WhatsApp clone will send you sms message
    (carrier charges may apply) to verify your phone 
    number Enter the country code and the  phone number
                            """),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: _openFilteredCountryPickerDialog,
                title: _buildDialogItem(_selectedFilteredDialogCountry),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: tabColor),
                        ),
                      ),
                      child: Text(_selectedFilteredDialogCountry.phoneCode),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: isValid == false ? 65 : 40,
                        margin: const EdgeInsets.only(top: 1.5),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: tabColor),
                          ),
                        ),
                        child: Form(
                          key: _myKey,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (String? value) {
                              return validateInput(value!, 11, 11);
                            },
                            controller: _phoneController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              border: isValid == false
                                  ? const OutlineInputBorder()
                                  : InputBorder.none,
                              hintText: "phone Number",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              NextButton(text: "Next", onPressed: _submitVerifyPhoneNumber),
            ],
          ),
        ),
      ),
    );
  }

}
