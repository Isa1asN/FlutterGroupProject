import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lastlearn/screens/auth_screen/login/login_screen.dart';
import 'package:lastlearn/screens/common/constants.dart';
import 'package:lastlearn/screens/profile/change_email.dart';
import 'package:lastlearn/screens/profile/delete_account.dart';
import 'package:lastlearn/screens/common/generic_dialogue.dart';
import 'package:lastlearn/blocs/profile/profile_bloc.dart';
import 'package:lastlearn/repository/local_db.dart';
import 'package:lastlearn/blocs/sign%20in/signin_bloc.dart';

import '../../models/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DeleteAccountPop deleteAcc = DeleteAccountPop();
  int _currentIndex = 0;
  List<User> user = [];
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    String token = context.read<CustomBloc>().state.token!;
    String userId = context.read<CustomBloc>().state.userId!;
    return BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is ProfileEmptyState) {
        context.read<ProfileBloc>().add(LoadUser(
              token: token,
              userId: userId,
              content: "Error occured while loading profile info",
              context: context,
              optionsBuilder: () => {"ok": true},
              sword: showGenericDialog,
              title: "Loading Error",
            ));
      }
      if (state is UserLoadedState) {
        setState(() {
          user.add(state.user);
        });
      }
    }, builder: (context, state) {
      if (user.isEmpty) {
        context.read<ProfileBloc>().add(LoadUser(
              token: token,
              userId: userId,
              content: "Error occured while loading profile info",
              context: context,
              optionsBuilder: () => {"ok": true},
              sword: showGenericDialog,
              title: "Loading Error",
            ));
      }
      if (state is ProfileEmptyState) {
        context.read<ProfileBloc>().add(LoadUser(
              token: token,
              userId: userId,
              content: "Error occured while loading profile info",
              context: context,
              optionsBuilder: () => {"ok": true},
              sword: showGenericDialog,
              title: "Loading Error",
            ));
        return ProfileContent(context);
      }
      if (state is ChangeEmailState) {
        context.read<ProfileBloc>().add(LoadUser(
              token: token,
              userId: userId,
              content: "Error occured while loading profile info",
              context: context,
              optionsBuilder: () => {"ok": true},
              sword: showGenericDialog,
              title: "Loading Error",
            ));
        return ProfileContent(context);
      }
      if (state is LogedoutState) {
        context.read<CustomBloc>().add(RestoreState());
        context.read<ProfileBloc>().add(RestoreProfile());
      }
      if (state is AccountDeletedState) {
        context.read<CustomBloc>().add(RestoreState());
        context.read<ProfileBloc>().add(RestoreProfile());
      }
      return ProfileContent(context);
    });
  }

  Scaffold ProfileContent(BuildContext context) {
    final router = GoRouter.of(context);
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: user.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 80,
                      backgroundColor: kPrimaryOutlineBorder,
                      backgroundImage: AssetImage(
                          'assets/images/profile.png'), // Replace with your own image
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${user[0].firstName} ${user[0].lastName}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      user[0].email,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('First Name'),
                      subtitle: Text(user[0].firstName),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Last Name'),
                      subtitle: Text(user[0].lastName),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.work),
                      title: Text('Role'),
                      subtitle: Text(user[0].role),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Material(
                              child: ChangeEmailPage(email: user[0].email),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Change email'),
                        subtitle: Text(user[0].email),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        context.read<CustomBloc>().state.token = "";
                        context.read<ProfileBloc>().add(LogoutEvent());
                      },
                      child: const ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                deleteAcc.deleteAccount(context));
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.delete_sweep_rounded,
                          color: Colors.red,
                        ),
                        title: Text('Delete Account'),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
