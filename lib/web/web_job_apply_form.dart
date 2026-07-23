// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/model/referal_model/add_resume_model.dart';
import 'package:job_circle/src/model/user_profile/refer_cv_parse_model.dart';
import 'package:job_circle/src/services/referal_and_apply/add_resume_and_apply_services.dart';
import 'package:job_circle/web/web_apply_service.dart';
import 'package:job_circle/web/web_screening_question_page.dart';
import 'package:url_launcher/url_launcher.dart';

class WebJobApplyFormPage extends StatefulWidget {
  final String shareCode;
  const WebJobApplyFormPage({super.key, required this.shareCode});

  @override
  State<WebJobApplyFormPage> createState() => _WebJobApplyFormPageState();
}

class _WebJobApplyFormPageState extends State<WebJobApplyFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();

  // Page state
  bool _isLoading = true;
  bool _isUploading = false;
  bool _isSubmitting = false;
  bool _submitted = false;
  bool _showForm = false;

  Map<String, dynamic>? _jobData;
  String? _uploadedFileName;
  String? _cvFileName;

  // Form dropdowns / date
  String? _selectedGender;
  String? _selectedEducation;
  String? _selectedExperience;
  DateTime? _selectedDob;

  static const _genders = ['Male', 'Female'];
  static const _educations = ['Graduate', 'Under Graduate'];
  static const _experiences = ['Experienced', 'Fresher'];

  // ─── Colors ────────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFF4F6FB);
  static const _cardBg = Colors.white;
  static const _fieldBg = Color(0xFFF8F9FA);
  static const _successGreen = Color(0xFF2E7D32);
  static const _successGreenBg = Color(0xFFE8F5E9);

  // ─── Reset ─────────────────────────────────────────────────────────────────
  void _resetForm() {
    _firstNameCtrl.clear();
    _lastNameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _altPhoneCtrl.clear();
    setState(() {
      _submitted = false;
      _showForm = false;
      _uploadedFileName = null;
      _cvFileName = null;
      _selectedGender = null;
      _selectedEducation = null;
      _selectedExperience = null;
      _selectedDob = null;
    });
  }

  // ─── Init ──────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _fetchJobDetails();
  }

  Future<void> _fetchJobDetails() async {
    if (widget.shareCode.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
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
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  // ─── CV pick → parse → upload ──────────────────────────────────────────────
  Future<void> _pickAndProcessCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final Uint8List? bytes = file.bytes;
    if (bytes == null) return;

    setState(() {
      _isUploading = true;
      _cvFileName = file.name;
    });

    // 1. Parse CV to auto-fill form fields
    try {
      final parsed = await WebApplyService.parseCVFromBytes(
        bytes: bytes,
        fileName: file.name,
      );
      _fillFormFromParsed(parsed);
    } catch (_) {
      // parsing failed — form stays blank but upload can still proceed
    }

    // 2. Upload CV for storage
    final uploadedName = await WebApplyService.uploadCVFromBytes(
      bytes: bytes,
      fileName: file.name,
    );

    setState(() {
      _uploadedFileName = uploadedName;
      _isUploading = false;
      _showForm = true;
    });
  }

  void _fillFormFromParsed(ReferResumeParseModel p) {
    if (p.firstName?.isNotEmpty == true) _firstNameCtrl.text = p.firstName!;
    if (p.lastName?.isNotEmpty == true) _lastNameCtrl.text = p.lastName!;
    if (p.email?.isNotEmpty == true) _emailCtrl.text = p.email!;
    if (p.contactNumber?.isNotEmpty == true) _phoneCtrl.text = p.contactNumber!;
    if (p.alternateNumber?.isNotEmpty == true)
      _altPhoneCtrl.text = p.alternateNumber!;

    final g = p.gender?.toLowerCase().trim();
    if (g == 'male') _selectedGender = 'Male';
    if (g == 'female') _selectedGender = 'Female';
    if (g == 'other') _selectedGender = 'Other';

    if (p.educationLevel?.isNotEmpty == true)
      _selectedEducation = p.educationLevel;
    if (p.experienceLevel?.isNotEmpty == true)
      _selectedExperience = p.experienceLevel;
  }

  // ─── Submit ────────────────────────────────────────────────────────────────
  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final jobId = (_jobData!['jobId'] as num?)?.toInt() ?? 0;
      final sharerUserId = (_jobData!['sharerUserId'] as num?)?.toInt() ?? 0;
      final role = (_jobData!['job']['roleName']);
      final process = (_jobData!['job']['process']);
      final companyid = (_jobData!['job']['companyId']);
      final natureofwork = (_jobData!['job']['functionalOfArea']);

      final model = ReferAddResumeModel(
        uid: sharerUserId,
        jobId: jobId,
        applicantName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        contactNo: int.tryParse(_phoneCtrl.text.trim()),
        alternateNo: int.tryParse(_altPhoneCtrl.text.trim()),
        gender: _selectedGender,
        dob: _selectedDob,
        qualification: _selectedEducation,
        level: role,
        process: process,
        shortListFor: companyid,
        naturofwork: natureofwork,
        resume: _uploadedFileName ?? '',
        isExperienced:
            (_selectedExperience != null &&
                _selectedExperience!.toLowerCase() != 'fresher')
            ? 1
            : 0,
        payoutMode: 'DEFAULT',
      );

      // Check if job has screening questions
      debugPrint('[WebForm] Fetching screening questions for jobId=$jobId');
      final questions = await WebApplyService.fetchScreeningQuestions(jobId);
      debugPrint('[WebForm] questions.length=${questions.length}');

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (questions.isNotEmpty) {
        // Navigate to screening flow
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebScreeningQuestionPage(
              questions: questions,
              candidateData: model,
              sharerUserId: sharerUserId,
              onSubmitComplete: _resetForm,
            ),
          ),
        );
      } else {
        // No screening — submit directly
        setState(() => _isSubmitting = true);
        final res = await AddResumeAndApplyService.referAndAddResume(
          jsonData: model,
          refId: sharerUserId,
        );
        if (!mounted) return;
        if (res == '200') {
          setState(() {
            _submitted = true;
            _isSubmitting = false;
          });
        } else if (res == 'DUPLICATE') {
          setState(() => _isSubmitting = false);
          _snack('CV is already in the pipeline for this job.', isError: true);
        } else {
          setState(() => _isSubmitting = false);
          _snack('Submission failed. Please try again.', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _snack('Error: $e', isError: true);
      }
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Constants.red : Constants.darkBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _loadingScreen();
    if (_jobData == null) return _errorScreen();
    if (_submitted) return _successScreen();

    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
              child: Column(
                children: [
                  if (_jobData!['job']['jobStatus'] == "ACTIVE") ...[
                    _buildCVSection(),
                  ],
                  if (_jobData!['job']['jobStatus'] != "ACTIVE") ...[
                    _builIfJobIsInactive(),
                  ],
                  if (_showForm) ...[
                    const SizedBox(height: 20),
                    _buildForm(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                  ],
                  const SizedBox(height: 40),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* // ── Branding ───────────────────────────────────────────────────────────────
  Widget _buildBranding() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Constants.darkBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(CustomAssetUrl.jclogoicon),
            ),
            const SizedBox(width: 10),
            const Text(
              'Job Circle',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Constants.darkBlue,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Your next opportunity is one step away',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    );
  } */

  /*  // ── Job info card (styled like refernow card) ──────────────────────────────
  Widget _buildJobCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Constants.yelloLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You've been referred!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Constants.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.work_outline_rounded,
                      size: 15,
                      color: Constants.darkBlue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Job ID: ${_jobData!['jobId']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Constants.darkBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 15,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Referred by User #${_jobData!['sharerUserId']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.65),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Constants.orange,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'T&C apply',
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } */

  // ── If job is inactive ──────────────────────────────────────────────────────
  Widget _builIfJobIsInactive() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          // Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.work_off_rounded,
              color: Constants.orange,
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          // Heading
          const Text(
            'This Job Is No Longer Active',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          // Body message
          Text(
            'We\'re sorry for the inconvenience. The position you were looking to apply for is currently inactive. This could be because the role has been filled or temporarily put on hold. Please check back later or explore similar opportunities on our app.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          // Divider
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 20),
          // Note
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Constants.darkBlue.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Constants.darkBlue.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Constants.darkBlue,
                  size: 18,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Looking for a job? Thousands of active openings are waiting for you on the Job Circle app.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Constants.darkBlue,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Play Store button
          GestureDetector(
            onTap: () async {
              final uri = Uri.parse(
                'https://play.google.com/store/apps/details?id=com.job_circle_flutter',
              );
              if (await canLaunchUrl(uri)) launchUrl(uri);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Constants.darkBlue, Color(0xFF1565C0)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Constants.darkBlue.withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Find Similar Jobs on Play Store',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── CV upload section ──────────────────────────────────────────────────────
  Widget _buildCVSection() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _iconBadge(Icons.upload_file_rounded, Constants.darkBlue),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Your CV',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'We\'ll auto-fill your details instantly',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          if (_isUploading) ...[
            // Uploading indicator
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: Constants.darkBlue,
                    strokeWidth: 2.5,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Uploading & reading your CV…',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
          ] else if (_showForm) ...[
            // Uploaded success chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _successGreenBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _successGreen.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: _successGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _cvFileName ?? 'CV Uploaded Successfully',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _successGreen,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: _pickAndProcessCV,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Change',
                      style: TextStyle(
                        color: Constants.darkBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Upload drop zone
            GestureDetector(
              onTap: _pickAndProcessCV,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: Constants.yelloLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Constants.orange.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Constants.darkBlue,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Click to upload your CV',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Constants.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PDF only  •  Max 5 MB',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Candidate details form ─────────────────────────────────────────────────
  Widget _buildForm() {
    final cvWasUploaded = _showForm && _cvFileName != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card header bar ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Constants.darkBlue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Your Details',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (cvWasUploaded) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 11,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Auto-filled',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Fields ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Personal info group ---
                  _sectionLabel('Personal Information'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          _firstNameCtrl,
                          'First Name *',
                          Icons.badge_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          _lastNameCtrl,
                          'Last Name',
                          Icons.badge_outlined,
                          required: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _field(
                    _emailCtrl,
                    'Email Address',
                    Icons.email_outlined,
                    required: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v != null && v.isNotEmpty && !v.contains('@')
                        ? 'Enter a valid email'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          _phoneCtrl,
                          'Phone Number',
                          Icons.phone_outlined,
                          readOnly: true,
                          required: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _field(
                          _altPhoneCtrl,
                          'Alt. Phone',
                          Icons.phone_outlined,
                          required: false,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),

                  // --- About you group ---
                  const SizedBox(height: 20),
                  _sectionLabel('About You'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _dropdown(
                          label: 'Gender',
                          icon: Icons.wc_outlined,
                          value: _genders.contains(_selectedGender)
                              ? _selectedGender
                              : null,
                          items: _genders,
                          onChanged: (v) => setState(() => _selectedGender = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _datePicker()),
                    ],
                  ),

                  // --- Background group ---
                  const SizedBox(height: 20),
                  _sectionLabel('Background'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _dropdown(
                          label: 'Education',
                          icon: Icons.school_outlined,
                          value: _educations.contains(_selectedEducation)
                              ? _selectedEducation
                              : null,
                          items: _educations,
                          onChanged: (v) =>
                              setState(() => _selectedEducation = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dropdown(
                          label: 'Experience',
                          icon: Icons.work_history_outlined,
                          value: _experiences.contains(_selectedExperience)
                              ? _selectedExperience
                              : null,
                          items: _experiences,
                          onChanged: (v) =>
                              setState(() => _selectedExperience = v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Row(
    children: [
      Container(
        width: 3,
        height: 14,
        decoration: BoxDecoration(
          color: Constants.orange,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    ],
  );

  // ── Submit button ──────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isSubmitting ? null : _submitApplication,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isSubmitting
                ? [Colors.grey.shade400, Colors.grey.shade400]
                : [Constants.darkBlue, const Color(0xFF1565C0)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isSubmitting
              ? []
              : [
                  BoxShadow(
                    color: Constants.darkBlue.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isSubmitting)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else ...[
              const Icon(Icons.send_rounded, color: Colors.white, size: 17),
              const SizedBox(width: 8),
              const Text(
                'Submit Application',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      '© Job Circle 2026 · All rights reserved',
      style: TextStyle(fontSize: 11, color: Colors.black),
    );
  }

  // ── State screens ──────────────────────────────────────────────────────────
  Widget _loadingScreen() => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Constants.darkBlue),
          const SizedBox(height: 16),
          Text(
            'Loading job details…',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    ),
  );

  Widget _errorScreen() => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Constants.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.link_off_rounded,
                color: Constants.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Invalid or Expired Link',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'This referral link is no longer valid.\nContact the person who shared it.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );

  Widget _successScreen() => PopScope(
    canPop: false,
    onPopInvokedWithResult: (_, _) => _resetForm(),
    child: Scaffold(
      backgroundColor: _bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: _successGreenBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: _successGreen,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Application Submitted!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'We\'ve received your application.\nSomeone will get in touch with you soon.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Constants.yelloLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Powered by Job Circle',
                  style: TextStyle(
                    color: Constants.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // ── Reusable helpers ───────────────────────────────────────────────────────

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: _cardBg,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );

  Widget _iconBadge(IconData icon, Color color) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(icon, color: color, size: 18),
  );

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool required = true,
    bool readOnly = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: TextStyle(
        color: readOnly ? Colors.grey.shade500 : Colors.black87,
        fontSize: 13,
      ),
      validator:
          validator ??
          (v) =>
              required && (v == null || v.trim().isEmpty) ? 'Required' : null,
      decoration: _inputDeco(label, icon, readOnly: readOnly),
    );
  }

  Widget _dropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: _inputDeco(label, icon),
      isExpanded: true,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _datePicker() {
    final hasValue = _selectedDob != null;
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDob ?? DateTime(1995),
          firstDate: DateTime(1950),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
          builder: (ctx, child) => Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: Constants.darkBlue),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _selectedDob = picked);
      },
      child: InputDecorator(
        decoration: _inputDeco('Date of Birth', Icons.calendar_today_outlined),
        isEmpty: !hasValue,
        child: Text(
          hasValue
              ? '${_selectedDob!.day.toString().padLeft(2, '0')}/'
                    '${_selectedDob!.month.toString().padLeft(2, '0')}/'
                    '${_selectedDob!.year}'
              : '',
          style: TextStyle(
            fontSize: 13,
            color: hasValue ? Colors.black87 : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(
    String label,
    IconData icon, {
    bool readOnly = false,
  }) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
    prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade400),
    /* suffixIcon: readOnly
        ? Icon(
            Icons.lock_outline_rounded,
            size: 14,
            color: Colors.grey.shade400,
          )
        : null, */
    filled: true,
    fillColor: readOnly ? const Color(0xFFEEEFF1) : _fieldBg,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Constants.darkBlue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Constants.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Constants.red, width: 1.5),
    ),
  );

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _altPhoneCtrl.dispose();
    super.dispose();
  }
}
