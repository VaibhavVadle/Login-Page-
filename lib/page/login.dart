
import 'package:authentication/page/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

class login extends StatefulWidget {
  const login({Key? key,}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  var email = "";
  var password = "";

  final auth = FirebaseAuth.instance;

  Future openDialog()=> showDialog(
    context: context,
    builder: (context) => const Padding(
      padding: EdgeInsets.all(25.0),
      child: AlertDialog(
        title: Text('LOGIN Succesfully',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),),
      ),
    ),
  );
  Future closeDialog()=> showDialog(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(25.0),
      child: AlertDialog(
        title: Text('Invalid Inputs',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),),
      ),
    ),
  );
  createuser() async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));

  }
  userLogin() async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }


  final _myFormKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller  = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
            elevation: 2.0,
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.blue[800],

              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'User Login',
                    style: TextStyle(
                      color: Colors.blue[800],

                    ),

                  ),
                ),
              ],
            )
        ),
      ),
      body:Container(

        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,



        child: Stack(
            children: <Widget>[
              Positioned(
                child: SingleChildScrollView(
                  child: Form(
                    key: _myFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:<Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 20.0),
                          child: TextFormField(

                            controller: emailcontroller,
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

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText:"Password",
                                hintText: "Enter your Password",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blueAccent,
                                    width: 1.0,),
                                  borderRadius : BorderRadius.circular(5.0),
                                )

                            ),


                          ),
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue[800],
                              elevation: 6,
                              padding: EdgeInsets.symmetric(vertical: 18,horizontal: 160.0)
                          ),
                            onPressed:(){
                              setState(() {
                                email = emailcontroller.text;
                                password = passwordcontroller.text;
                              });
                              createuser();
                            },
                            child: Text('SignUp')),




                      ],


                    ),

                  ),


                ),
                
              ),

              Positioned(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton.icon(
                        icon: Icon(Icons.login),
                        label: Text('Login'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue[800],
                            elevation: 6,
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 150.0)
                        ),
                        onPressed: (){
                          if (_myFormKey.currentState!.validate()) {
                            setState(() {
                              email = emailcontroller.text;
                              password = passwordcontroller.text;
                            });
                            userLogin();
                            // Navigator.pushReplacement(context,
                            //   MaterialPageRoute(builder: (context) => HomeScreen(
                            //       phone: numbercontroller.text,
                            //       password:passwordcontroller.text
                            //
                            //   )),
                            // );
                          }
                          else{
                            closeDialog();
                          }
                        }
                    ),
                  ),
                ),
              ),
              
            ]
        ),

      ) ,
    );
  }
}
