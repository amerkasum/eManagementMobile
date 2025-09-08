import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:emanagement_mobile/Models/Desktop/edit_user_view_model.dart';
import 'package:emanagement_mobile/Models/Helpers/select_list_helper.dart';
import 'package:emanagement_mobile/Services/Helpers/helpers.dart';
import 'package:emanagement_mobile/Services/user_service.dart';
import 'package:emanagement_mobile/Components/bottom_navigation_bar.dart';
import 'package:emanagement_mobile/Presentation/Desktop/users_desktop.dart';
import '../../Components/top_app_bar.dart';

class EditUserForm extends StatefulWidget {
  final int userId;
  const EditUserForm({Key? key, required this.userId}) : super(key: key);

  @override
  _EditUserFormState createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dobController = TextEditingController();
  final _contractExpireController = TextEditingController();

  EditUserViewModel editUserViewModel = EditUserViewModel(id: 0);

  List<SelectListHelper> contractTypes = [];
  List<SelectListHelper> shifts = [];
  List<SelectListHelper> positions = [];
  List<SelectListHelper> cities = [];
  List<SelectListHelper> roles = [];

  File? _profileImage;

  final UserService userService = UserService();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    await _fetchDropdownData();
    await _loadUserData();
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
      print("Error fetching dropdown data: $e");
    }
  }

  Future<void> _loadUserData() async {
    try {
      final user = await userService.getUserById(widget.userId);

      setState(() {
        editUserViewModel = user;
      
        _firstNameController.text = user.firstName ?? '';
        _lastNameController.text = user.lastName ?? '';
        _emailController.text = user.email ?? '';
        _phoneNumberController.text = user.phoneNumber ?? '';
        _dobController.text = user.dateOfBirth != null
            ? user.dateOfBirth!.toLocal().toString().split(' ')[0]
            : '';
        _contractExpireController.text = user.contractExpireDate != null
            ? user.contractExpireDate!.toLocal().toString().split(' ')[0]
            : '';
      
        // Set dropdowns
        editUserViewModel.roleId = user.roleId;
        editUserViewModel.cityId = user.cityId;
        editUserViewModel.shiftId = user.shiftId;
        editUserViewModel.positionId = user.positionId;
        editUserViewModel.contractTypeId = user.contractTypeId;
        editUserViewModel.imageUrl = user.imageUrl;
      });

    } catch (e) {
      print("Failed to load user data: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isDob) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDob
          ? editUserViewModel.dateOfBirth ?? DateTime.now()
          : editUserViewModel.contractExpireDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isDob) {
          editUserViewModel.dateOfBirth = picked;
          _dobController.text = picked.toLocal().toString().split(' ')[0];
        } else {
          editUserViewModel.contractExpireDate = picked;
          _contractExpireController.text = picked.toLocal().toString().split(' ')[0];
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    editUserViewModel.firstName = _firstNameController.text;
    editUserViewModel.lastName = _lastNameController.text;
    editUserViewModel.email = _emailController.text;
    editUserViewModel.phoneNumber = _phoneNumberController.text;

    editUserViewModel.roleId = editUserViewModel.roleId;
    editUserViewModel.cityId = editUserViewModel.cityId;
    editUserViewModel.shiftId = editUserViewModel.shiftId;
    editUserViewModel.positionId = editUserViewModel.positionId;
    editUserViewModel.contractTypeId = editUserViewModel.contractTypeId;
    editUserViewModel.dateOfBirth = editUserViewModel.dateOfBirth;
    editUserViewModel.contractExpireDate = editUserViewModel.contractExpireDate;

    if (_profileImage != null) {
      final path = 'assets/profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _profileImage!.copy(path);
      editUserViewModel.imageUrl = path;
    }

    try {
      await userService.editUser(editUserViewModel);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User updated successfully."),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const UsersDesktopWidget()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _dobController.dispose();
    _contractExpireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: eManagementTopAppBarPage(title: 'Edit Employee'),
      bottomNavigationBar: eManagementBottomNavigationBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: editUserViewModel.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              editUserViewModel.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 40,
                          ),
                  ),

                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) =>
                          value == null || !value.contains('@') ? 'Invalid email' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dobController,
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _contractExpireController,
                          decoration: const InputDecoration(
                            labelText: 'Contract Expire Date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDropdown("Role", roles, editUserViewModel.roleId, (val) {
                setState(() => editUserViewModel.roleId = val);
              }),
              const SizedBox(height: 16),
              _buildDropdown("City", cities, editUserViewModel.cityId, (val) {
                setState(() => editUserViewModel.cityId = val);
              }),
              const SizedBox(height: 16),
              _buildDropdown("Shift", shifts, editUserViewModel.shiftId, (val) {
                setState(() => editUserViewModel.shiftId = val);
              }),
              const SizedBox(height: 16),
              _buildDropdown("Position", positions, editUserViewModel.positionId, (val) {
                setState(() => editUserViewModel.positionId = val);
              }),
              const SizedBox(height: 16),
              _buildDropdown("Contract Type", contractTypes, editUserViewModel.contractTypeId, (val) {
                setState(() => editUserViewModel.contractTypeId = val);
              }),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  foregroundColor: Colors.white, // Text (and icon) color
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
                  child: Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<SelectListHelper> items,
    int? selectedValue,
    void Function(int?) onChanged,
  ) {
    return DropdownButtonFormField<int>(
      value: selectedValue,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((item) => DropdownMenuItem(
                value: item.id,
                child: Text(item.name ?? ''),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }
}
