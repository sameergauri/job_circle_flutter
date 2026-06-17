import 'package:flutter/material.dart';
import 'package:job_circle/src/services/referal_and_apply/add_resume_and_apply_services.dart';

class WebJobApplyFormPage extends StatefulWidget {
  final String shareCode;
  const WebJobApplyFormPage({super.key, required this.shareCode});

  @override
  State<WebJobApplyFormPage> createState() => _WebJobApplyFormPageState();
}

class _WebJobApplyFormPageState extends State<WebJobApplyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = true;
  Map<String, dynamic>? _jobData;

  @override
  void initState() {
    super.initState();
    _fetchJobDetails();
  }

  // Share code se job metadata nikalne ke liye
  Future<void> _fetchJobDetails() async {
    try {
      final result = await AddResumeAndApplyService.validateShareCode(
        widget.shareCode,
      );
      if (result['success'] == true) {
        setState(() {
          _jobData = result;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_jobData == null)
      return const Scaffold(
        body: Center(child: Text("Invalid or Expired Job Link")),
      );

    return Scaffold(
      body: Center(
        child: Container(
          width: 450, // Web par mobile responsive container box style
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Applying for Job ID: ${_jobData!['jobId']}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Referred by User: ${_jobData!['sharerUserId']}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // 🎯 API Call: Yahan apni backend application submission API hit kar do
                        // Jisme jobId, sharerUserId, candidate name, aur email pass hoga.
                        print("Submitting Form to Backend...");
                      }
                    },
                    child: const Text("Submit Application"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
