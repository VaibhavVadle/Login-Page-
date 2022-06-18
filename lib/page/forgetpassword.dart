import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  var mail = "";

  final _myFormKey = GlobalKey<FormState>();
  final mailcontroller = TextEditingController();


  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        centerTitle: true,
      ),
      body: Form(
        key: _myFormKey,
          child:Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text('Reset link will be sent to your email id',
                style: TextStyle(
                  fontSize: 18
                ),),
              ),
              SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                child: TextFormField(

                  controller: mailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email address'
                      : null,


                  decoration: InputDecoration(
                      labelText:"Email",
                      hintText: "Enter your Email address",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 1.0,),
                        borderRadius : BorderRadius.circular(5.0),
                      )

                  ),

                ),

              ),
              ElevatedButton(
                  child: Text('Send Email'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue[800],
                      elevation: 6,
                      padding: EdgeInsets.symmetric(vertical: 18,horizontal: 50.0)
                  ),
                  onPressed:() {
                    if(_myFormKey.currentState!.validate()){
                    setState ( () {
                      mail = mailcontroller.text;
                    });
                    resetPassword();
                    Navigator.pop(context);
                    }

                  },
    )

            ],
          ),
      ),

    );
  }
}
