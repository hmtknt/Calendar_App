import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events_2023/Controller/Provider/add_event_provider.dart';
import 'package:flutter_events_2023/Controller/Provider/authentication_provider.dart';
import 'package:flutter_events_2023/View/Components/build_buttons.dart';
import 'package:flutter_events_2023/View/theme/extention.dart';
import 'package:flutter_events_2023/View/theme/light_color.dart';
import 'package:flutter_events_2023/View/theme/text_styles.dart';
import 'package:flutter_events_2023/View/widgets/text_field.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddEvent extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? selectedDate;
  const AddEvent({Key? key, required this.firstDate, required this.lastDate, this.selectedDate}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late DateTime _selectedDate;
  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _dateController.text = "${widget.selectedDate ?? DateTime.now()}";
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Add Event",
          style: TextStyles.bodySm.black.bold,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          InputDatePickerFormField(
            fieldLabelText: "Enter Event Title",
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            initialDate: _selectedDate,
            onDateSubmitted: (date) {
              print(date);
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 20),
          RoundedTextField(
            controller: _titleController,
            hint: 'Enter Event Title',
            color: Colors.transparent,
            borderColor: Colors.transparent,
            pIcon: const Icon(Icons.title),
          ),
          const SizedBox(height: 20),
          RoundedTextField(
            maxLine: 5, // Allows for multiline input
            keyBoardType: TextInputType.multiline,
            controller: _descController,
            hint: 'Enter Description',
            color: Colors.transparent,
            borderColor: Colors.transparent,
            pIcon: const Icon(Icons.description),
          ),
          const SizedBox(height: 20),
          SizedBox(
              height: 60,
              width: double.infinity,
              child: Consumer<AddEventProvider>(builder: (context, AddEventProvider addEventProvider, _) {
                return buildRegisterButton(() async {
                  await addEventProvider.addEvent(
                      context, sp.uid.toString(), sp.imageUrl, sp.name, sp.phone, _titleController.text, _descController.text, _selectedDate);
                },
                    addEventProvider.loading
                        ? const SpinKitThreeBounce(
                            color: LightColor.white,
                            size: 30.0,
                          )
                        : Text("Add Event", style: GoogleFonts.poppins(color: LightColor.white, fontSize: 16, fontWeight: FontWeight.w600)));
              })),
        ],
      ),
    );
  }

  void _addEvent() async {
    final title = _titleController.text;
    final description = _descController.text;
    if (title.isEmpty) {
      print('title cannot be empty');
      return;
    }
    await FirebaseFirestore.instance.collection('events').add({
      "title": title,
      "description": description,
      "date": Timestamp.fromDate(_selectedDate),
    });
    if (mounted) {
      Navigator.pop<bool>(context, true);
    }
  }
}
