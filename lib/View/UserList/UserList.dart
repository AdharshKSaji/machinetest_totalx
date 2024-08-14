// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:machinetest_totalx/View/UserList/UserListViewModel.dart';
// import 'package:provider/provider.dart';

// class UserListScreen extends StatefulWidget {
//   const UserListScreen({super.key});

//   @override
//   _UserListScreenState createState() => _UserListScreenState();
// }

// class _UserListScreenState extends State<UserListScreen> {
//   File? _imageFile;
//   String _searchQuery = '';

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (BuildContext context) => UserListViewModel(),
//       builder: (context, child) => Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           leading: IconButton(
//             icon: const Icon(Icons.location_on, color: Colors.white),
//             onPressed: () {
//               // Handle location button pressed
//             },
//           ),
//           title: const Text(
//             "Nilambur",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         body: Column(
//           children: [
//             // Row containing the search bar and vertical button
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   // Search bar
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.search),
//                         hintText: 'Search users',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           _searchQuery = value.toLowerCase();
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // Vertical button
//                   IconButton(
//                     icon: Icon(Icons.more_vert),
//                     onPressed: () {
//                       // Handle vertical button press
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             // Expanded to take remaining space
//             Expanded(
//               child: Consumer<UserListViewModel>(
//                 builder: (context, viewModel, child) {
//                   return StreamBuilder<QuerySnapshot>(
//                     stream: viewModel.getUsersStream(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       if (snapshot.hasError) {
//                         return Center(child: Text('Error: ${snapshot.error}'));
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return Center(child: Text('No users found.'));
//                       }

//                       final users = snapshot.data!.docs
//                           .where((doc) {
//                             final user = doc.data() as Map<String, dynamic>;
//                             final name = user['name'].toLowerCase();
//                             return name.contains(_searchQuery);
//                           }).toList();

//                       return ListView.builder(
//                         itemCount: users.length,
//                         itemBuilder: (context, index) {
//                           final user = users[index].data() as Map<String, dynamic>;
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: NetworkImage(user['avatarUrl']),
//                             ),
//                             title: Text(user['name']),
//                             subtitle: Text('Age: ${user['age']}'),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => _showAddUserScreen(context),
//           backgroundColor: Colors.black,
//           child: const Icon(Icons.add, color: Colors.white, size: 30),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       ),
//     );
//   }

//   void _showAddUserScreen(BuildContext context) {
//     final viewModel = Provider.of<UserListViewModel>(context, listen: false);

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Add New User"),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: GestureDetector(
//                     onTap: _pickImage,
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: _imageFile != null
//                           ? FileImage(_imageFile!)
//                           : AssetImage('assets/default_avatar.png') as ImageProvider,
//                       child: _imageFile == null
//                           ? Icon(Icons.camera_alt, color: Colors.grey[800], size: 30)
//                           : null,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: "Name",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onChanged: (value) => viewModel.updateName(value),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: "Age",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onChanged: (value) => viewModel.updateAge(value),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: "Avatar URL",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onChanged: (value) => viewModel.updateAvatarUrl(value),
//                 ),
//                 const SizedBox(height: 24),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       try {
//                         await viewModel.addUser();
//                         Navigator.pop(context);
//                       } catch (e) {
//                         // Handle the error (e.g., show a snackbar or alert)
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Failed to add user: $e')),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     ),
//                     child: const Text(
//                       "Add User",
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
