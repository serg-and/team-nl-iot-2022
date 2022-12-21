import 'package:app/main.dart'; // Import main.dart file
import 'package:flutter/material.dart'; // Import Material Design package
import 'models.dart';

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key}); // Constructor for Settings class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Settings"),
        body: Container(
          child: _CreateTeam()
        )// Use CustomAppBar with "Settings" as title
    );
// End Scaffold
  }
}

class _CreateTeam extends StatelessWidget{
  const _CreateTeam({super.key});
  Widget build(BuildContext context){
    return Row(
      children: [
        Container(
            child: Text('Create New Team')
        ),
        Container(
            child: _CreateTeamButton()
        )
      ]
    );
  }
}

class _CreateTeamButton extends StatefulWidget{
  const _CreateTeamButton({super.key});

  @override
  State<_CreateTeamButton> createState() => _CreateTeamButtonState();
}

class _CreateTeamButtonState extends State<_CreateTeamButton>{
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Icon(
        Icons.add
      ),
      onPressed: () => {
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Create Team'),
              actions: [
                TextField()
              ],
            );
          }
        )
      },
    );
  }
}