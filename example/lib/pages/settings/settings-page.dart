import 'package:example/pages/settings/settings-page-state.dart';
import 'package:example/widgets/loading_spinner/loading_spinner.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidgetBase<SettingsPageState>{
  SettingsPage():super(()=>SettingsPageState());

  @override
  Widget build(BuildContext context){
    return this.state.isReady?
    Scaffold(
      appBar: AppBar(
        title: const Text("Settings",style: TextStyle(color: Colors.white,fontSize: 30),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: IconButton(icon:const Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: ()=> this.state.goBack())
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            const Row(
              children: [
                Text("Display",style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),),
              ],
            ),
            const SizedBox(height: 20,),
             Row(
              children: [
                Expanded(child: Text("Theme",style: TextStyle(fontSize: 20))),
                ValueListenableBuilder<bool>(valueListenable: this.state.themeNotifier, 
                builder: (context, isDarkMode,_){
                  return Switch(
                    value: this.state.isDarkMode,
                    activeColor: this.state.isDarkMode? Colors.white:Colors.black12,
                    onChanged: (bool value)=> this.state.toggleTheme());
                })
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:4.0),
              child: Row(
                children: [
                  Text(this.state.isDarkMode?"Dark":"Light",style: TextStyle(fontSize: 20),)
                ],
              ),
            ),
            SizedBox(height: 40,),
            Row(
              children: [
                Text("About",style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text("User",style: TextStyle(fontSize: 20))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(this.state.userName,style: TextStyle(fontSize: 20)),
                )
              ],
            ),
             SizedBox(height: 40,),
            Row(
              children: [
                Text("Status",style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text("Online",style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
             SizedBox(height: 40,),
            Row(
              children: [
                Text("Privacy Policy",style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
              ],
            ),
             SizedBox(height: 8.0,),
            Row(
              children: [
                Expanded(child: Text("Our Privacy Policy has been crafted to provide clarity on how we gather, utilize, and protect your data when you engage with our messaging services. Your trust is of utmost importance to us, and we are committed to ensuring that your information is handled with the utmost care and in accordance with the highest standards of privacy and security.",style: TextStyle(fontSize: 16, color: Colors.grey))),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                TextButton(onPressed: this.state.logout, child: Text("Log out", style: TextStyle(fontSize: 20, color: Colors.red),)),
              ],
            ),
          ],
        ),
      )
    ): this._buildLoadingScreen();
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