import 'package:example/pages/user/user-page-state.dart';
import 'package:example/widgets/loading_spinner/loading_spinner.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidgetBase<UserPageState>{
  UserPage():super(()=>UserPageState());


  @override
  Widget build(BuildContext context){
    return this.state.isReady?
    Scaffold(
      appBar: AppBar(
        title: const Text("Profile",style: TextStyle(color: Colors.white,fontSize: 30),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(icon:const Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: ()=> this.state.goBack()),
        actions: [
          IconButton(onPressed: ()=>this.state.goToSettings(),
         icon: const Icon(Icons.settings, color: Colors.white,))],
      ),
      body: 
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(30.0),
                alignment: Alignment.topCenter,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: this.state.getImage(),
                      backgroundColor:const Color(0xFF387463),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt_rounded),
                        onPressed: () => this.state.editDp(),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.only(left: 50.0,right: 30.0),
                child: ListTile(
                  leading: const Icon(Icons.person_2),
                  title: this.state.isFirstNameEditable
                  ? TextFormField(
                    initialValue: this.state.firstName,
                    onChanged: (v) => this.state.firstName=v,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: "First Name"
                    ),
                  )
                  : Text(this.state.firstName,
                  style: const TextStyle(fontSize: 18),
                  ),
                  trailing: !this.state.isFirstNameEditable
                  ? IconButton(
                    onPressed: ()=> this.state.isFirstNameEditable = !this.state.isFirstNameEditable,
                     icon: const Icon(Icons.edit)
                     ):
                     IconButton(onPressed: () {
                      this.state.saveFirstName();
                      this.state.isFirstNameEditable= !this.state.isFirstNameEditable;
                     },
                      icon: const Icon(Icons.save))
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0,right: 30.0),
                child: ListTile(
                  leading: const Icon(Icons.person_2),
                  title: this.state.isLastNameEditable
                  ? TextFormField(
                    initialValue: this.state.lastName,
                    onChanged: (v)=> this.state.lastName=v,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: "Last Name"
                    ),
                  )
                  : Text(this.state.lastName??"",
                  style: const TextStyle(fontSize: 18),
                  ),
                  trailing: !this.state.isLastNameEditable
                  ? IconButton(
                    onPressed: ()=> this.state.isLastNameEditable= !this.state.isLastNameEditable,
                     icon: const Icon(Icons.edit)
                     ):
                     IconButton(onPressed: () {
                      this.state.saveLastName();
                      this.state.isLastNameEditable= !this.state.isLastNameEditable;
                     },
                      icon: const Icon(Icons.save))
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0,right: 30.0),
                child: ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(this.state.phone,
                  style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      
    )
    : this._buildLoadingScreen();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        child: SizedBox.expand(
          child: Container(
            alignment: Alignment.center,
            child: LoadingSpinner(),
          ),
        ),
      ),
    );
  }
}