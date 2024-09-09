import 'dart:io';

import 'package:flutter/material.dart';
import 'package:emanagement_mobile/Models/Helpers/select_list_helper.dart';
import 'package:emanagement_mobile/Models/Desktop/user_view_model.dart';
import 'package:emanagement_mobile/Services/Helpers/helpers.dart';
import 'package:emanagement_mobile/Services/user_service.dart';
import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Presentation/Desktop/users_desktop.dart';
import 'package:image_picker/image_picker.dart';

import '../../Components/top_app_bar.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  UserViewModel userViewModel = UserViewModel();
  List<SelectListHelper> contractTypes = [];
  List<SelectListHelper> shifts = [];
  List<SelectListHelper> positions = [];
  List<SelectListHelper> cities = [];
  List<SelectListHelper> roles = [];

  ApiService apiService = ApiService();
  UserService userService = UserService();

  File? _profileImage; // Variable to hold the selected image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchDropdownData() async {
    try {
      final contractTypesData = await apiService.fetchContractTypes();
      final shiftsData = await apiService.fetchShifts();
      final positionsData = await apiService.fetchPositions();
      final citiesData = await apiService.fetchCities();
      final rolesData = await apiService.fetchRoles();

      setState(() {
        contractTypes = contractTypesData;
        shifts = shiftsData;
        positions = positionsData;
        cities = citiesData;
        roles = rolesData;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, {required bool isDateOfBirth}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isDateOfBirth ? userViewModel.dateOfBirth ?? DateTime.now() : userViewModel.contractExpireDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isDateOfBirth) {
          userViewModel.dateOfBirth = pickedDate;
        } else {
          userViewModel.contractExpireDate = pickedDate;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_profileImage != null) {
        final imagePath = 'assets/profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _profileImage!.copy(imagePath);
        
        userViewModel.imageUrl = imagePath;
      }
      await userService.createUser(userViewModel);
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UsersDesktopWidget()),
        (route) => false, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;
    final double inputWidth = isDesktop ? 500 : double.infinity;

    return Scaffold(
      appBar: eManagementTopAppBarPage(title: "Add Employee"),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Image picker icon
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _profileImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey[700],
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: isDesktop ? 16 : 0),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          ),
                          onSaved: (value) => userViewModel.firstName = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: isDesktop ? 16 : 0),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          ),
                          onSaved: (value) => userViewModel.lastName = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a last name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          ),
                          onSaved: (value) => userViewModel.email = value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: isDesktop ? 16 : 0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, isDateOfBirth: true),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Date of Birth',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              ),
                              controller: TextEditingController(
                                text: userViewModel.dateOfBirth != null
                                    ? '${userViewModel.dateOfBirth!.toLocal().toString().split(' ')[0]}'
                                    : '',
                              ),
                              validator: (value) {
                                if (userViewModel.dateOfBirth == null) {
                                  return 'Please select a date of birth';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: inputWidth,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      ),
                      obscureText: true,
                      onSaved: (value) => userViewModel.password = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: inputWidth,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      ),
                      onSaved: (value) => userViewModel.phoneNumber = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          ),
                          value: userViewModel.roleId,
                          items: roles
                              .map(
                                (role) => DropdownMenuItem<int>(
                                  value: role.id,
                                  child: Text(role.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              userViewModel.roleId = value;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a role' : null,
                        ),
                      ),
                      SizedBox(width: isDesktop ? 16 : 0),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Position',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          ),
                          value: userViewModel.positionId,
                          items: positions
                              .map(
                                (position) => DropdownMenuItem<int>(
                                  value: position.id,
                                  child: Text(position.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              userViewModel.positionId = value;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a position' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          ),
                          value: userViewModel.cityId,
                          items: cities
                              .map(
                                (city) => DropdownMenuItem<int>(
                                  value: city.id,
                                  child: Text(city.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              userViewModel.cityId = value;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a residence' : null,
                        ),
                      ),
                      SizedBox(width: isDesktop ? 16 : 0),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Contract Type',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          ),
                          value: userViewModel.contractTypeId,
                          items: contractTypes
                              .map(
                                (contractType) => DropdownMenuItem<int>(
                                  value: contractType.id,
                                  child: Text(contractType.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              userViewModel.contractTypeId = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: isDesktop ? 16 : 0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, isDateOfBirth: false),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Contract Expiration Date',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              ),
                              controller: TextEditingController(
                                text: userViewModel.contractExpireDate != null
                                    ? '${userViewModel.contractExpireDate!.toLocal().toString().split(' ')[0]}'
                                    : '',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isDesktop ? 16 : 0),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Shift',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          ),
                          value: userViewModel.shiftId,
                          items: shifts
                              .map(
                                (shift) => DropdownMenuItem<int>(
                                  value: shift.id,
                                  child: Text(shift.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              userViewModel.shiftId = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: inputWidth,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
