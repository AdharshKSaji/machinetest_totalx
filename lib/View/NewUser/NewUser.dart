import 'dart:io';

import 'package:flutter/material.dart';
import 'package:machinetest_totalx/View/NewUser/NewUserViewModel.dart';
import 'package:provider/provider.dart';


class NewUserScreen extends StatelessWidget {
  const NewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add A New User'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UserViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => viewModel.pickImage(),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: viewModel.image != null
                            ? FileImage(File(viewModel.image!.path))
                            : null,
                        child: viewModel.image == null
                            ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[700])
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => viewModel.setName(value),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => viewModel.setAge(value),
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Cancel'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            
                            
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
