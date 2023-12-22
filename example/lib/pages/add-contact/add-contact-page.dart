import 'package:example/pages/add-contact/add-contact-page-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidgetBase<AddContactPageState>{

  AddContactPage():super(()=>AddContactPageState());

  @override
  Widget build(BuildContext context){
    return 
      Padding(
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
              const SizedBox(height: 50.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green[500]),
               onPressed: this.state.hasErrors ? null : (){
                this.state.save();
                if(!this.state.hasErrors){
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Contact saved successfully!", 
                    style: TextStyle(color: Colors.white),), duration: Duration(seconds: 2),backgroundColor: Colors.green,)
                  );
                }
               },
               child: const Text("Save", style: TextStyle(color: Colors.white),))
            ],
          ),
        ),);
  }
}