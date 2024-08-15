import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:machinetest_totalx/View/UserList/AlertDialoge.dart';
import 'package:machinetest_totalx/View/UserList/BottomSheet.dart';
import 'package:machinetest_totalx/View/UserList/UserListViewModel.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  String _searchQuery = '';
  String _selectedSortOption = 'all';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserListViewModel(),
      child: Consumer<UserListViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(backgroundColor: Color.fromARGB(255, 228, 241, 247),
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.location_on, color: Colors.white),
                onPressed: () {},
              ),
              title: const Text(
                "Nilambur",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Column(
              children: [
                _buildSearchAndSortRow(context),
                Expanded(
                  child: _buildUserList(viewModel),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showAddUserDialog(context),
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }

  Widget _buildSearchAndSortRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search users',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
            ),
            child: IconButton(
              icon: const Icon(Icons.sort, color: Colors.white),
              onPressed: () => _showSortBottomSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(UserListViewModel viewModel) {
    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final users = snapshot.data!.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((user) {
              final name = user['name']?.toLowerCase() ?? '';
              return name.contains(_searchQuery);
            })
            .toList();

        if (_selectedSortOption == 'name') {
          users.sort((a, b) {
            final nameA = a['name'] ?? '';
            final nameB = b['name'] ?? '';
            return nameA.compareTo(nameB);
          });
        } else if (_selectedSortOption == 'age') {
          users.sort((a, b) {
            final ageA = a['age'] ?? 0;
            final ageB = b['age'] ?? 0;
            return ageA.compareTo(ageB);
          });
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Material(
              elevation: 3,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatarUrl'] ?? ''),
                    child: user['avatarUrl'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(user['name'] ?? 'Unknown'),
                  subtitle: Text('Age: ${user['age'] ?? 'N/A'}'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSortBottomSheet(BuildContext context) async {
    await showSortBottomSheet(
      context,
      _selectedSortOption,
      (option) {
        setState(() {
          _selectedSortOption = option;
        });
      },
    );
  }
}
