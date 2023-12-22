import 'package:example/pages/sign-up/sign-up-page-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidgetBase<SignUpPageState>{
  
  SignUpPage(): super(() => SignUpPageState());


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text("Sign Up",style: const TextStyle(color: Colors.white,fontSize: 25),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: this.state.formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30.0),
              TextFormField(
                controller: this.state.firstNameController,
                onChanged: (v)=>this.state.firstName=v,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "First Name",
                  prefixIcon:  Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  errorText: this.state.errors.getError("firstName"),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: this.state.lastNameController,
                onChanged: (v)=> this.state.lastName=v,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  prefixIcon:  Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorText: this.state.errors.getError("lastName"),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: this.state.phoneController,
                onChanged: (v)=> this.state.phone=v,
                decoration: InputDecoration(
                  labelText: "Phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorText: this.state.errors.getError("phone"),
                  prefixIcon:  Icon(Icons.phone)),
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
                  prefixIcon:  Icon(Icons.remove_red_eye)),
              ),
              const SizedBox(height: 50.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green[500]),
               onPressed: this.state.hasErrors ? null : this.state.signUp,
               child: const Text("Sign Up", style: TextStyle(color: Colors.white),))
            ],
          ),
      ),
      ),
    ) ;
  }
}