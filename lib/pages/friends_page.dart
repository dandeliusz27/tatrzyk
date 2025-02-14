import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hikehub/models/profile.dart';
import 'package:hikehub/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  late final Stream stream;
  late final TabController tabController;
  late User? user;
  List<Profile> followers = [];
  List<Profile> followed = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = RepositoryProvider.of<AuthRepository>(context).getCurrentUser();
    tabController = TabController(length: 3, vsync: this);
    stream = Supabase.instance.client
        .from("profile")
        .stream(primaryKey: ['id'])
        .neq("id", user!.id)
        .map(
            (data) => data.map((profile) => Profile.fromMap(profile)).toList());
  }

  Future<List<Profile>> getFollowed() async {
    final data = await Supabase.instance.client
        .from("followers")
        .select("followed_id(*)")
        .eq("follower_id", user!.id);
    return followed =
        data.map((x) => Profile.fromMap(x["followed_id"])).toList();
  }

  Future<List<Profile>> getFollowers() async {
    final data = await Supabase.instance.client
        .from("followers")
        .select("follower_id(*)")
        .eq("followed_id", user!.id);
    return followers =
        data.map((x) => Profile.fromMap(x["follower_id"])).toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  Future<bool> checkMutualFollow(String user1Id, String user2Id) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('followers')
        .select('follower_id, followed_id')
        .or('and(follower_id.eq.$user1Id,followed_id.eq.$user2Id),and(follower_id.eq.$user2Id,followed_id.eq.$user1Id)');

    return response.length == 2; // Both relationships must exist
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Znajomi"),
        bottom: TabBar(controller: tabController, tabs: [
          Tab(
            text: "wszyscy",
          ),
          Tab(
            text: "obserwowani",
          ),
          Tab(
            text: "obserwatorzy",
          ),
        ]),
      ),
      body: SafeArea(
          child: TabBarView(controller: tabController, children: [
        StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Profile> profiles = snapshot.data;
                return ListView.builder(
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 60,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 211, 211, 211),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(360),
                                color:
                                    const Color.fromARGB(255, 254, 244, 215)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                              "${profiles[index].firstName!} ${profiles[index].lastName!}"),
                          Expanded(child: Container()),
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  await Supabase.instance.client
                                      .from('followers')
                                      .insert(
                                          {"followed_id": profiles[index].id});
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              child: Text("Obserwuj"))
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        FutureBuilder(
            future: getFollowed(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Profile> profiles = followed;
                return RefreshIndicator(
                  onRefresh: getFollowed,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 60,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 211, 211, 211),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color:
                                      const Color.fromARGB(255, 254, 244, 215)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                "${profiles[index].firstName!} ${profiles[index].lastName!}"),
                            Expanded(child: Container()),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        FutureBuilder(
            future: getFollowers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Profile> profiles = followers;
                return RefreshIndicator(
                  onRefresh: getFollowers,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 60,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 211, 211, 211),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color:
                                      const Color.fromARGB(255, 254, 244, 215)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                "${profiles[index].firstName!} ${profiles[index].lastName!}"),
                            Expanded(child: Container()),
                            // if ()
                            //   ElevatedButton(
                            //       onPressed: () async {},
                            //       child: Text("Obserwujesz"))
                            // else
                            //   ElevatedButton(
                            //       onPressed: () async {
                            //         try {
                            //           await Supabase.instance.client
                            //               .from('followers')
                            //               .insert({
                            //             "followed_id": profiles[index].id
                            //           });
                            //         } catch (e) {
                            //           print(e.toString());
                            //         }
                            //       },
                            //       child: Text("Obserwuj"))
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ])),
    );
  }
}
