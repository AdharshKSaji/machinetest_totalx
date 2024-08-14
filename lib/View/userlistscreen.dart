import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  List<DocumentSnapshot> _users = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _documentLimit = 10;
  DocumentSnapshot? _lastDocument;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    _loadMoreUsers();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadMoreUsers();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreUsers() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .limit(_documentLimit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _lastDocument = querySnapshot.docs.last;
        _users.addAll(querySnapshot.docs);
        if (querySnapshot.docs.length < _documentLimit) {
          _hasMore = false;
        }
      });
    } else {
      setState(() {
        _hasMore = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _addUser() {
    // Implement functionality to add a new user to Firebase
    print("Add user button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.white),
            SizedBox(width: 4),
            Text(
              "Nilambur",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 8),
            Text("User list"),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _users.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _users.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  Map<String, dynamic> userData =
                      _users[index].data() as Map<String, dynamic>;
                  String userName = userData["name"] ?? "No Name";
                  String userAge = userData["age"] ?? "No Age";
                  String avatarUrl = userData["avatarUrl"] ??
                      "https://i.pinimg.com/236x/b9/28/7a/b9287a7cdeb0344253c8816f286af2c1.jpg";

                  if (userName.toLowerCase().contains(searchText)) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(avatarUrl),
                            ),
                            SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userName),
                                Text(userAge),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }
}
