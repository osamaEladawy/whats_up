import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

import '../../../../core/globel/widgets/next_button.dart';
import '../../../../core/theme/style.dart';
import '../manager/cerdential/credential_cubit.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  late final TextEditingController _pinController = TextEditingController();
  late String number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
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
              const SizedBox(height: 20),
              const Text(
                "Enter your OTP for the WhatsApp Clone Verification (so that you will be moved for the further steps to complete)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              _pinCodeWidget(),
              const Spacer(),
              NextButton(text: "Next", onPressed: _submitSmsCode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinCodeWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          PinCodeFields(
            controller: _pinController,
            length: 6,
            activeBorderColor: tabColor,
            onComplete: (String pinCode) {},
          ),
          const Text("Enter your 6 digit code")
        ],
      ),
    );
  }

  void _submitSmsCode() {
    print("otpCode ${_pinController.text}");
    if (_pinController.text.isNotEmpty) {
      BlocProvider.of<CredentialCubit>(context)
          .submitSmsCode(smsPinCode: _pinController.text);
      _pinController.clear();
    }
  }
}
