import 'package:flutter/material.dart';
import 'package:cognicare/database/database_helper.dart';

class PatientProfileScreen extends StatefulWidget {
  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _caretakerNameController = TextEditingController();
  final TextEditingController _caretakerPhoneController = TextEditingController();
  final TextEditingController _familyMembersController = TextEditingController();

  String _selectedLevel = "Mild";
  List<Map<String, dynamic>> _patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() async {
    final patients = await DatabaseHelper.instance.getPatients();
    setState(() {
      _patients = patients;
    });
  }

  void _addOrUpdatePatient({int? id}) async {
    final String name = _nameController.text.trim();
    final int age = int.tryParse(_ageController.text) ?? 0;
    final String address = _addressController.text.trim();
    final String caretakerName = _caretakerNameController.text.trim();
    final String caretakerPhone = _caretakerPhoneController.text.trim();
    final String familyMembers = _familyMembersController.text.trim();

    if (name.isEmpty || age <= 0 || address.isEmpty || caretakerName.isEmpty || caretakerPhone.isEmpty) {
      _showErrorDialog("All fields are required and age must be greater than 0.");
      return;
    }

    final patientData = {
      'name': name,
      'age': age,
      'address': address,
      'caretaker_name': caretakerName,
      'caretaker_phone': caretakerPhone,
      'family_members': familyMembers,
      'cognitive_level': _selectedLevel,
    };

    if (id == null) {
      await DatabaseHelper.instance.insertPatient(patientData);
    } else {
      await DatabaseHelper.instance.updatePatient(id, patientData);
    }

    _clearFields();
    _loadPatients();
    Navigator.pop(context);
  }

  void _editPatient(Map<String, dynamic> patient) {
    _nameController.text = patient['name'];
    _ageController.text = patient['age'].toString();
    _addressController.text = patient['address'];
    _caretakerNameController.text = patient['caretaker_name'];
    _caretakerPhoneController.text = patient['caretaker_phone'];
    _familyMembersController.text = patient['family_members'];
    _selectedLevel = patient['cognitive_level'];

    _showPatientForm(patientId: patient['id']);
  }

  void _clearFields() {
    _nameController.clear();
    _ageController.clear();
    _addressController.clear();
    _caretakerNameController.clear();
    _caretakerPhoneController.clear();
    _familyMembersController.clear();
  }

  void _showPatientForm({int? patientId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
                  TextField(controller: _ageController, decoration: InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
                  TextField(controller: _addressController, decoration: InputDecoration(labelText: "Address")),
                  TextField(controller: _caretakerNameController, decoration: InputDecoration(labelText: "Caretaker Name")),
                  TextField(controller: _caretakerPhoneController, decoration: InputDecoration(labelText: "Caretaker Phone"), keyboardType: TextInputType.phone),
                  TextField(controller: _familyMembersController, decoration: InputDecoration(labelText: "Family Members")),

                  ListTile(
                    title: Text("Cognitive Level"),
                    trailing: DropdownButton<String>(
                      value: _selectedLevel,
                      items: ["Mild", "Moderate", "Severe"]
                          .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          _selectedLevel = value!;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _addOrUpdatePatient(id: patientId),
                    child: Text(patientId == null ? "Add Patient" : "Update Patient"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patient Profiles")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _clearFields();
          _showPatientForm();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _patients.length,
        itemBuilder: (context, index) {
          final patient = _patients[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(patient['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Age: ${patient['age']}"),
                  Text("Address: ${patient['address']}"),
                  Text("Caretaker: ${patient['caretaker_name']}"),
                  Text("Caretaker Phone: ${patient['caretaker_phone']}"),
                  Text("Family Members: ${patient['family_members']}"),
                  Text("Cognitive Level: ${patient['cognitive_level']}"),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editPatient(patient),
              ),
            ),
          );
        },
      ),
    );
  }
}
