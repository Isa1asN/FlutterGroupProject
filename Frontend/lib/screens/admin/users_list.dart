import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/blocs/progress/progress_bloc.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';

import '../common/generic_dialogue.dart';
import '../../models/user.dart';

class UserList extends StatefulWidget {
  const UserList({
    Key? key,
  }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  int indexAt = 0;
  List<User> users = [];
  @override
  Widget build(BuildContext context) {
    String token = context.read<CustomBloc>().state.token!;
    String role = context.read<CustomBloc>().state.role!;
    String userId = context.read<CustomBloc>().state.userId!;
    return BlocConsumer<ProgressBloc, ProgressState?>(
        listener: (context, state) {
      if (state is AdminPageState) {
        setState(() {
          users = state.users;
        });
      }
      if (state is RoleChangedState) {
        context.read<ProgressBloc>().add(LoadProgressAction(
              token: token,
              role: role,
              userId: userId,
            ));
      }
    }, builder: (context, state) {
      if (users.isEmpty) {
        context.read<ProgressBloc>().add(LoadProgressAction(
              token: token,
              role: role,
              userId: userId,
            ));
      }
      if (state is RoleChangedState) {
        print("...................changed...........................");

        return UsersListCommon(token);
      }
      print("the state is $state ..................");
      return UsersListCommon(token);
    });
  }

  Scaffold UsersListCommon(String token) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
      ),
      body: users.isEmpty
          ? Container(
              // mainAxisAlignment: MainAxisAlignment.center,
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  shadowColor: kPrimaryUnselectedTab,
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      backgroundColor: kPrimaryExerciseList,
                    ),
                    title: Text(users[index].firstName),
                    subtitle: Text(users[index].role),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserDetails(user: users[index])));
                    },
                    trailing: SizedBox(
                      width: 110,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            indexAt = index;
                          });
                          context.read<ProgressBloc>().add(PromoteUserAction(
                              token: token,
                              user: users[index],
                              content: "Error occured while promoting user",
                              title: "Promotion error",
                              context: context,
                              suser: showGenericDialog,
                              optionsBuilder: () => {"ok": true}));
                        },
                        child: Text(
                          users[index].role == "learner" ? "promote" : "demote",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class UserDetails extends StatelessWidget {
  User user;
  UserDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Column(
        children: [
          Text(user.firstName),
          Text(user.email),
          Text(user.role),
        ],
      ),
    );
  }
}
