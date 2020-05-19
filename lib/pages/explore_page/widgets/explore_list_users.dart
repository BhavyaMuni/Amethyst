import 'package:amethyst_app/models/user_model.dart';
import 'package:amethyst_app/pages/explore_page/widgets/user_container.dart';
import 'package:amethyst_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreListWidget extends StatelessWidget {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    List<User> allUsers = Provider.of<List<User>>(context);
    User user = Provider.of<User>(context);
    List sortedUsersUids = _dbService.getSortedUserList(user, allUsers);
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              cacheExtent: double.infinity,
              itemBuilder: (ctx, val) {
                return StreamBuilder(
                  stream: _dbService.streamUser(sortedUsersUids[val]),
                  builder: (BuildContext context, AsyncSnapshot snap) {
                    if (!snap.hasData ||
                        snap.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      return UserContainer(
                        name: snap.data.name,
                        uid: snap.data.uid,
                        instruments: snap.data.instruments,
                        genres: snap.data.genres,
                        photoUrl: snap.data.photoUrl,
                        bio: snap.data.bio,
                      );
                    }
                  },
                );
              },
              itemCount: sortedUsersUids.length,
            ),
          ),
        ],
      ),
    );
  }
}
