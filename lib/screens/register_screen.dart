import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:hawkerbro/provider/auth_provider.dart';
import 'package:hawkerbro/widgets/custom_button.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "65",
    countryCode: "SG",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Singapore",
    example: "Singapore",
    displayName: "Singapore",
    displayNameNoCountryCode: "SG",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          iconSize: 20.0,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/register.jpg",
              height: 200,
            ),
            const Text(
              'Hi There!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5.0),
            const Text(
              'Please enter your phone number',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              cursorColor: Colors.black,
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: "Phone Number",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                  ),
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 13.0, 8.0, 15.0),
                  child: InkWell(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        countryListTheme: const CountryListThemeData(
                          bottomSheetHeight: 480,
                        ),
                        onSelect: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                        },
                      );
                    },
                    child: Text(
                      "${selectedCountry.flagEmoji}  +${selectedCountry.phoneCode}",
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CustomButton(
                text: "Send OTP",
                onPressed: () => sendPhoneNumber(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = _phoneNumberController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
