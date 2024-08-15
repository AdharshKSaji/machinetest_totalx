
import 'package:flutter/material.dart';
import 'package:machinetest_totalx/View/UserList/UserListViewModel.dart';
import 'package:provider/provider.dart';

void showAddUserDialog(BuildContext context) {
  final viewModel = Provider.of<UserListViewModel>(context, listen: false);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ChangeNotifierProvider.value(
        value: viewModel,
        child: AlertDialog(
          title: const Text("Add New User"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Consumer<UserListViewModel>(
                    builder: (context, value, child) =>
                        GestureDetector(
                      onTap: value.pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:  const AssetImage(
                                'assets/images/image.png'),
                        
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) =>
                      viewModel.updateName(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) =>
                      viewModel.updateAge(value),
                ),
                const SizedBox(height: 24),
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                    ElevatedButton(onPressed: () {
                      
                    },style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                     child: Text("Cancel")),
                     ElevatedButton(
                        onPressed: () async {
                          await viewModel.addUser();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        child: const Text(
                          "Add User",
                          style: TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                   ],
                 ),
                
              ],
            ),
          ),
        ),
      );
    },
  );
}
