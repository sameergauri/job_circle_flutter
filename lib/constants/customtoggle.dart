import 'package:flutter/material.dart';
import 'package:job_circle/screens/jobs/cc.dart';

import '../models/changeStatusModel.dart';
import '../models/fetch_applied_job_model.dart';
import '../service/job_post_api_service.dart';

class ToggleButton extends StatefulWidget {
  final bool initialValue;
//  final Function(bool) onChanged;
  final Applicant item;
  final int id;

  const ToggleButton(
      {super.key,
      required this.initialValue,
   //   required this.onChanged,
      required this.item,
      required this.id});

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
 // late bool _isToggleOn;

  @override
  void initState() {
    super.initState();
 //   _isToggleOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /* setState(() {
          _isToggleOn = !_isToggleOn;
          widget.onChanged(_isToggleOn);
        }); */
        String subStatus = widget.item.sub_code == "IB5:1"
            ? "On-Site Interview"
            : "Virtual Interview";
        ChangeStatusModel changeStatusModel = ChangeStatusModel(
          status: widget.item.status_code,
          sourceId: widget.item.sourceId,
          subStatus: subStatus,
        );
        Map<String, dynamic> jsonData = changeStatusModel.toJson();

        try {
          JobPostApiService.changeStatus(jsonData, widget.id.toInt());
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const CC()));
        } catch (e) {
          print('Error: $e');
          // Handle error...
        }
      },
      child: Container(
        width: 30.0,
        height: 15.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: widget.initialValue ? Colors.green : Colors.grey,
        ),
        child: Stack(
          alignment: widget.initialValue ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            Container(
              width: 15.0,
              height: 15.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
