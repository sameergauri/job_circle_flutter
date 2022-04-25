import 'package:flutter/material.dart';
import 'package:job_circle/components/bottom_dialog.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/screens/otp.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isManual = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      BottomDialog()
          .showBottomDialog(context, _buildDialogContent(context), false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 160.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).primaryColor, spreadRadius: 3),
                  ],
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: const [
                        Text(
                          'MADE IN INDIA',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                              color: Colors.black87),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '@ All rights reserved - 2022-23',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              decoration: TextDecoration.none,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                height: 170,
                child: Image.asset("assets/images/job-logo.png"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Material(
          child: Column(
            children: [
              // const SizedBox(height: 16),
              // _buildImage(),

              const SizedBox(height: 10),
              _buildContinueText(),
              const SizedBox(height: 16),
              _buildEmapleText(),
              const SizedBox(height: 30),
              if (isManual == true) _buildManualForm(),
              if (isManual == true) const SizedBox(height: 16),
              if (isManual == false) _buildContinueButton(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const image =
        'https://user-images.githubusercontent.com/47568606/134579553-da578a80-b842-4ab9-ab0b-41f945fbc2a7.png';
    return SizedBox(
      height: 88,
      child: Image.network(image, fit: BoxFit.cover),
    );
  }

  Widget _buildContinueText() {
    return const Text(
      'Hey, Pratik Naik',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildEmapleText() {
    return const Text(
      'To get started, please verify mobile number',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField() {
    const iconSize = 40.0;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.4)),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: const Center(
              child: Text('Е'),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'elisa.g.beckett@gmail.com',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('**********'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Column(
      children: [
        ThemeButton(
          text: "+919004390874",
          disabled: false,
          onPressed: () => {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const OTPScreen()))
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ThemeButton(
          onPressed: () {
            setState(() {
              isManual = true;
            });
            Navigator.of(context, rootNavigator: true).pop();
            BottomDialog()
                .showBottomDialog(context, _buildDialogContent(context), false);
          },
          text: 'Enter Manually',
          isText: true,
        )
      ],
    );
  }

  Widget _buildManualForm() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            label: Text("Your mobile number"),
            prefix: Text(
              "+91",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            border: OutlineInputBorder(),
            hintText: 'Enter a search term',
          ),
        ),
        const SizedBox(height: 20),
        ThemeButton(
          text: "Confirm",
          onPressed: () {
            setState(() {
              isManual = true;
            });
            Navigator.of(context, rootNavigator: true).pop();
            BottomDialog()
                .showBottomDialog(context, _buildDialogContent(context), false);
          },
        ),
      ],
    );
  }
}
