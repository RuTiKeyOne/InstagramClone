import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/core/bloc/cubit/profile_cubit.dart';
import 'package:instagram_clone/core/model/user.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileCubit profileCubit;
  const ProfileScreen({Key? key, required this.profileCubit}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    widget.profileCubit.init();
    super.initState();
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: _createProfileAppBar(context, state),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ProfileAvatar(user: state.user),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(0, "posts"),
                                    buildStatColumn(state.user.followers.length,
                                        "followers"),
                                    buildStatColumn(state.user.following.length,
                                        "following"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ProfileUsername(username: state.user.username),
                      ProfileBio(
                        bio: state.user.bio,
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _createProfileAppBar(BuildContext context, ProfileState state) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        state.user.username,
      ),
      centerTitle: false,
    );
  }
}

class ProfileBio extends StatelessWidget {
  final String bio;

  const ProfileBio({
    Key? key,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 1,
      ),
      child: Text(
        bio,
      ),
    );
  }
}

class ProfileUsername extends StatelessWidget {
  final String username;
  const ProfileUsername({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Text(
        username,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final User user;
  const ProfileAvatar({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: const Size.fromRadius(40),
        child: user.photoUrl.isNotEmpty
            ? CachedNetworkImage(
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).focusColor,
                ),
                imageUrl: user.photoUrl,
              )
            : Container(
                color: Theme.of(context).focusColor,
              ),
      ),
    );
  }
}