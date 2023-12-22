import 'package:example/pages/login/login-page-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidgetBase<LoginPageState>
{

  LoginPage():super(() => LoginPageState());


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("Log In",style: const TextStyle(color: Colors.white,fontSize: 25),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: this.state.formKey,
          child: ListView(
            children: [
              Image.network("https://cdn.pixabay.com/photo/2016/04/27/20/39/whatsapp-1357489_1280.jpg", height: 300,fit: BoxFit.cover,),
              const SizedBox(height: 30.0),
              TextFormField(
                controller: this.state.phoneController,
                onChanged: (v)=> this.state.phone=v,
                decoration: InputDecoration(
                  labelText: "Phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorText: this.state.errors.getError("phone"),
                  ),
                  keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: this.state.passwordController,
                obscureText: true,
                onChanged: (v)=> this.state.password=v,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorText: this.state.errors.getError("password"),
                  ),
              ),
              
              Visibility(
                visible: this.state.isErrorTextNeeded,
                child: Text("Authentication Failed", 
                style: TextStyle(color: Colors.red),)),
                const SizedBox(height: 40.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green[500]),
               onPressed: this.state.hasErrors ? null : this.state.login,
               child: const Text("Log In", style: TextStyle(color: Colors.white),),
               )
            ],
          ),
      ),
          )
    );
  }
}