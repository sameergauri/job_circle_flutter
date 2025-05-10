// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:awesome_calendar/awesome_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_circle/constants/custom_suggestion_textfield.dart';
import 'package:job_circle/constants/custom_suggestion_textfield_for_new.dart';
import 'package:job_circle/models/add_resume_model.dart';
import 'package:job_circle/models/fetch_applied_job_model.dart';
import 'package:job_circle/models/sub_status_model.dart';
import 'package:job_circle/screens/Manager/Lead_detail/customCompanyformanager.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';

import 'package:job_circle/service/job_post_api_service.dart';

import '../../../common/utils.dart';
import '../../../constants/gobal.dart';
import '../../../service/FileUploadService.dart';
import '../../../themes/colors.dart';

class ManagerLeadForm extends ConsumerStatefulWidget {
  final Applicant? leads;
  const ManagerLeadForm({
    super.key,
    this.leads,
  });

  @override
  ConsumerState<ManagerLeadForm> createState() => _ManagerLeadFormState();
}

class _ManagerLeadFormState extends ConsumerState<ManagerLeadForm> {
  TextEditingController companyController = TextEditingController();
  TextEditingController processController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController functionalAreaController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController joiningStatusController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController alternateNoController = TextEditingController();
  TextEditingController dojController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController eduController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController resumeController = TextEditingController();
  TextEditingController spocController = TextEditingController();
  TextEditingController dosController = TextEditingController();
  TextEditingController interviewStatusController = TextEditingController();
  TextEditingController interviewRoundController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController clientresumeIdController = TextEditingController();
  TextEditingController refferalController = TextEditingController();
  TextEditingController subController = TextEditingController();
  TextEditingController sourceNameController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController documentStatusController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();
  TextEditingController empIdController = TextEditingController();
  TextEditingController lastWorkingDate = TextEditingController();
  TextEditingController subSourceController = TextEditingController();
  TextEditingController resumeId = TextEditingController();
  TextEditingController modeOfDocument = TextEditingController();
  TextEditingController commercialGender = TextEditingController();
  TextEditingController companyWorkStatus = TextEditingController();

/*   FocusNode companyFocusNode = FocusNode();
  FocusNode processFocusNode = FocusNode();
  FocusNode roleFocusNode = FocusNode();
  FocusNode functionalAreaFocusNode = FocusNode();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode joiningStatusFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();
  FocusNode contactNoFocusNode = FocusNode();
  FocusNode alternateNoFocusNode = FocusNode();
  FocusNode dojFocusNode = FocusNode();
  FocusNode expFocusNode = FocusNode();
  FocusNode eduFocusNode = FocusNode();
  FocusNode remarkFocusNode = FocusNode();
  FocusNode resumeFocusNode = FocusNode();
  FocusNode spocFocusNode = FocusNode();
  FocusNode dosFocusNode = FocusNode();
  FocusNode interviewStatusFocusNode = FocusNode();
  FocusNode interviewRoundFocusNode = FocusNode();
  FocusNode notesFocusNode = FocusNode();
  FocusNode clientresumeIdFocusNode = FocusNode();
  FocusNode refferalFocusNode = FocusNode();
  FocusNode subFocusNode = FocusNode();
  FocusNode sourceNameFocusNode = FocusNode();
  FocusNode salaryFocusNode = FocusNode();
  FocusNode documentStatusFocusNode = FocusNode();
  FocusNode documentListFocusNode = FocusNode();
  FocusNode feedbackFocusNode = FocusNode();
  FocusNode empIdFocusNode = FocusNode(); */

  bool isCompany = false;
  bool isProcess = false;
  bool isRole = false;
  bool isFunctionalArea = false;
  bool isFirstname = false;
  bool isFeedback = false;
  bool isLastname = false;
  bool isJoiningStatus = false;
  bool isStatus = false;
  bool isContactNo = false;
  bool isAlternateNo = false;
  bool isDoj = false;
  bool isExp = false;
  bool isEdu = false;
  bool isRemark = false;
  // bool isResume = false;
  bool isSpoc = false;
  bool isDos = false;
  bool isInterviewStatus = false;
  bool isInterviewRound = false;
  bool isNotes = false;
  bool isClientresumeId = false;
  bool isRefferal = false;
  bool isSub = false;
  bool isSourceName = false;
  bool isSalary = false;
  bool isUnder = false;
  bool isGraduate = false;
  bool isFresher = false;
  bool isDropdownOpen = false;
  bool isValueSelected = false;
  bool isDropOpen = false;
  bool isDocDrop = false;
  bool isValueDoc = false;
  bool isValue = false;
  bool isUser = false;
  bool isEdit4 = false;
  bool isEdit1 = false;
  bool isEdit2 = false;
  bool isEdit3 = false;
  bool isResumeId = false;
  // bool isSourceSelected = false;
  bool isSourceDropOpen = false;
  bool isComp = false;
  bool isresumeId = false;
  bool resumeidfilled = false;
  bool isEditResume = false;
  bool isEditProcess = false;
  bool isEditRole = false;
  bool isEditFun = false;
  bool isCommercialMale = false;
  bool isCommercialFemale = false;
  bool isCompanyExp = false;
  bool isCompanyFresher = false;

  int? leadId;
  int? sourceId;
  int? company_id;
  int? uId;
  int? rId;
  String? shortListId;
  int? jobId;
  int? uid;

  String? parentId, processId, isEmp, isGender, isWorkPay;
  String? roleId;
  int? newJobID;
  String? genderId;
  String? workId;
  String? selectedValue;
  String selectedSubstatus = '';
  int? selectedSubStatusId;
  String selectValue = '';
  String sourceValue = '';
  String selectedDocument = '';
  String selectDocument = '';
  String documentValue = '';
  String? icon_data;
  int? selectedSpocId;
  int? selectedStatusId;
  int? selectedJoiningId;
  int? selectedSourceId;
  String? status_id;
  String? hrStatusId;
  String? subStatusId;
  String? join_code;
  String? resumeID;
  String? processResumeID;

  var content = [];
  var sourceName = [];

  List<String> interviewRounds = [];
  List<String> interviewDropRounds = [];
  List<String> interviewDropDownRounds = [];
  var subStatusList = [];

  List<String> documentStatus = ["Not Submitted", "Under Review", "Submitted"];

  DateTime initialDate = DateTime.now();
  DateTime lastAllowedDate = DateTime.now().add(const Duration(days: 4 * 31));
  DateTime? singleSelect;
  DateTime? lwtSelect;

  String? parentID, jobTitle, pId;

  void handleSelectedID(String id) {
    // Process the selected ID as needed
    print('Selected ID: $id');
    setState(() {
      parentId = id;
    });
    // Perform any other actions with the ID
  }

  void getStatusId(String id) {
    setState(() {
      status_id = id;

      if ((status_id == '14' && widget.leads!.hr_status_id == 13) ||
          ((status_id == '11' || status_id == '12') &&
              (widget.leads!.hr_status_id != null &&
                  widget.leads!.hr_status_id! >= 13 &&
                  widget.leads!.hr_status_id! <= 19))) {
        selectedValue = '';
      }
    });
    _handleStatusIdChange();
  }

  void getHrStatusId(String id) {
    setState(() {
      hrStatusId = id;
    });
    getLeadsSubStatus(int.tryParse(id)!.toInt());
  }

  void getHrSubStatusId(String id) {
    setState(() {
      subStatusId = id;
    });
  }

  void getJoiningCode(String code) {
    setState(() {
      join_code = code;
    });
  }

  void getResumeID(String id) {
    setState(() {
      resumeID = id;
      resumeController.clear();
    });
  }

  void getIsWork(String id) {
    setState(() {
      workId = id;
    });
  }

  void getIsGender(String id) {
    setState(() {
      genderId = id;
    });
  }

  void getIsEmp(String id) {
    setState(() {
      isEmp = id;
    });
  }

  String? spocLastName, spocFirsName;
  int? spoc;
  String? firstInterviewRound;
  String? cJobId;

  void getSpocLastName(String lname) {
    setState(() {
      spocLastName = lname;
    });
  }

  void getSpocFirstName(String fname) {
    setState(() {
      spocFirsName = fname;
    });
  }

  void getSpoc(int spc) {
    setState(() {
      selectedSpocId = spc;
    });
  }

  void getInterviewRounds(List<String> spc) {
    setState(() {
      // firstInterviewRound = spc;
      interviewDropRounds = spc;
    });
  }

  void getJobId(String spc) {
    setState(() {
      cJobId = spc;
    });
  }

  void getCompanyId(int id) {
    setState(() {
      company_id = id;
      if (isEdit4 == false) {
        isEdit1 = false;
        isEdit2 = false;
        isEdit3 = false;
        processController.clear();
      }
      if (roleController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(roleFocusNode);
      } else if (roleController.text.isNotEmpty &&
          processController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(processFocusNode);
      } else if (processController.text.isNotEmpty &&
          functionalAreaController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(functionalAreaFocusNode);
      }
    });
  }

  void getValueOfJobtitle(String getJobTitle) async {
    setState(() {
      jobTitle = getJobTitle;
      if (companyController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(companyFocusNode);
      } else if (processController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(processFocusNode);
      } else if (processController.text.isNotEmpty &&
          functionalAreaController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(functionalAreaFocusNode);
      }
    });
  }

  String? pro;
  void getValuOfProcess(String gteProcess) {
    setState(() {
      pro = gteProcess;
      if (companyController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(companyFocusNode);
      } else if (roleController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(roleFocusNode);
      } else {
        // FocusScope.of(context).requestFocus(functionalAreaFocusNode);
      }
    });
  }

  void getNatureOfWorkId(String ids) {
    setState(() {
      NatureOfWorkID = int.parse(ids);
      if (companyController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(companyFocusNode);
      } else if (roleController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(roleFocusNode);
      } else if (processController.text.isEmpty) {
        // FocusScope.of(context).requestFocus(processFocusNode);
      }
    });
  }

  void getFunctionalAreaIdCust(int id) {
    setState(() {
      newJobID = id;
    });
  }

  int? NatureOfWorkID;
  List<String> checkboxData = [];
  List<String> checkboxDataState = [];

  // List<String> data = [];

  List<int> uniqueValues = [];

  DateTime subtractMonths(DateTime date, int monthsToSubtract) {
    int year = date.year;
    int month = date.month - monthsToSubtract;

    while (month <= 0) {
      month += 12;
      year--;
    }

    // Find the number of days in the target month
    int daysInMonth = DateTime(year, month + 1, 0).day;

    // Adjust the day if it's greater than the number of days in the target month
    int day = date.day;
    if (day > daysInMonth) {
      day = daysInMonth;
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second,
        date.millisecond, date.microsecond);
  }

  DateTime addMonths(DateTime date, int monthsToAdd) {
    int year = date.year;
    int month = date.month + monthsToAdd;

    // Adjust the year if the month goes beyond December
    year += month ~/ 12;
    month = month % 12;

    // Adjust the year and month if month is 0 (January)
    if (month == 0) {
      month = 12;
      year--;
    }

    // Find the number of days in the target month
    int daysInMonth = DateTime(year, month + 1, 0).day;

    // Adjust the day if it's greater than the number of days in the target month
    int day = date.day;
    if (day > daysInMonth) {
      day = daysInMonth;
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second,
        date.millisecond, date.microsecond);
  }

  Future<void> singleSelectPicker() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AwesomeCalendarDialog(
          initialDate: initialDate,
          startDate: initialDate,
          endDate: lastAllowedDate,
          selectionMode: SelectionMode.single,
          cancelBtnText: "Cancel",
          confirmBtnText: "Submit",
        );
      },
    );
    if (picked != null) {
      setState(() {
        singleSelect = picked;
        dojController.text = formatDate(picked);
      });
    } else {
      dojController.clear();
    }
  }

  void loadSpoc() async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host}/users/v1/userRoleBy/${widget.leads!.spoc}/3';

      var response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);

      if (response.statusCode == 200) {
        var dataResult = Utils.parseResponse(response).resultData;

        SpocModel userRole = SpocModel.fromJson(dataResult);

        // Set the desired value in spocController.text
        setState(() {
          spocController.text =
              "${userRole.firstName} ${userRole.lastName} - ${userRole.role}";
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void loadUserByRole() async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host}/users/v1/UserByRole?page=1&size=100';

      var response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);

      if (response.statusCode == 200) {
        var dataResult = Utils.parseResponse(response).resultData;
        content = dataResult['content'] as List<dynamic>;

        setState(() {});
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void loadSingleSource() async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host}/users/v1/userRoleBy/${widget.leads!.sourceId}/3';

      var response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);

      if (response.statusCode == 200) {
        var dataResult = Utils.parseResponse(response).resultData;

        SpocModel sourceRole = SpocModel.fromJson(dataResult);

        // Set the desired value in spocController.text
        setState(() {
          sourceNameController.text =
              "${sourceRole.firstName} ${sourceRole.lastName}";
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void getLeadsSubStatus(int hrSubStatusId) async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host}/sub_status/v1/{id}/subStatus?id=$hrSubStatusId&page=1&size=50';

      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          subStatusList = (data['resultData']['content'] as List<dynamic>)
              .map((item) => SubStatusModel.fromJson(item))
              .toList();
        });
      } else {
        throw Exception('Failed to load sub-status data');
      }
    } catch (e) {}
  }

  void loadSource() async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host}/users/v1/byUserType/3?page=1&size=100';

      var response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);

      if (response.statusCode == 200) {
        var sourceResult = Utils.parseResponse(response).resultData;
        sourceName = sourceResult['content'] as List<dynamic>;

        setState(() {});
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  @override
  void initState() {
    super.initState();
    getLeadsSubStatus(widget.leads!.hr_status_id!.toInt());

    if (widget.leads != null) {
      setState(() {
        leadId = widget.leads!.id;
        companyController.text = widget.leads!.companyName.toString();
        isComp = true;
        company_id = int.tryParse(widget.leads!.short_list_for.toString());
        shortListId = widget.leads!.short_list_for.toString();
        resumeId.text = widget.leads!.client_resume_id.toString() ?? "";
        processController.text = widget.leads!.process.toString();
        roleController.text = widget.leads!.lead_level.toString();
        functionalAreaController.text = widget.leads!.natureOfWork.toString();
        firstNameController.text = widget.leads!.applicantName.toString();
        lastNameController.text = widget.leads!.last_name.toString();
        contactNoController.text = widget.leads!.contactNo.toString();
        alternateNoController.text = (widget.leads!.alternateNo.toString());

        if (alternateNoController.text == "null") {
          alternateNoController.clear();
        }
        //
        statusController.text = widget.leads!.status.toString();
        hrStatusId = widget.leads!.hr_status_id.toString();
        icon_data = widget.leads!.resume.toString();
        feedbackController.text = widget.leads!.remark.toString();
        //
        //
        newJobID = widget.leads!.jobId;
        selectedSubStatusId = widget.leads!.status_id;
        subController.text = widget.leads!.sub_status.toString();
        dojController.text = widget.leads?.doj != null
            ? DateFormat('dd MMM yyyy')
                .format(DateTime.parse(widget.leads!.doj.toString()))
            : '';

        //
        if (widget.leads!.empCID == 1) {
          empIdController.text = widget.leads!.emp_id.toString();
        }
        if (widget.leads!.is_work_pay == 1 || widget.leads!.is_ctc_pay == 1) {
          salaryController.text = widget.leads!.salary.toString();
        }
        if (widget.leads!.is_exp == 1) {
          isCompanyExp = true;
        } else if (widget.leads!.is_exp == 0) {
          isCompanyFresher = true;
        }

        //
        //
        //TODO:: To Display resume id textfield..
        if (widget.leads!.client_resume_id != null &&
            widget.leads!.client_resume_id != "") {
          resumeID = "1";
        }
        //TODO:: For cummercial gender which is for select only..
        if (widget.leads!.gender == 'Male') {
          isCommercialMale = true;
        } else if (widget.leads!.gender == 'Female') {
          isCommercialFemale = true;
        }
        //
        //
        //TODO:: For experience level..
        if (widget.leads!.isExperienced == "Experience") {
          isExp = true;
        } else if (widget.leads!.isExperienced == "Fresher") {
          isFresher = true;
        }
        //
        //
        //TODO:: For educational level
        if (widget.leads!.qualification == "Graduate") {
          isGraduate = true;
        } else if (widget.leads!.qualification == "Under-Graduate" ||
            widget.leads!.qualification == "Under Graduate") {
          isUnder = true;
        }
      });

      //
      //
      //
      /*   setState(() {
        isComp = true;
        /*  isProcess = false;
        isRole = false;
        isFunctionalArea = false; */
       
      }); */

      if (widget.leads!.status == null) {
        statusController.text = '';
      }

      //  selectedSubStatusId = widget.leads.sub
      if (widget.leads!.sub_status == null) {
        subController.text = '';
      }

      uid = widget.leads?.uid ?? 0;

      selectedValue = widget.leads!.interview_rounds.toString();

      // dosController.text = widget.leads!.dos.toString();

      eduController.text = widget.leads!.qualification.toString();
      remarkController.text = widget.leads!.remark.toString();
      if (widget.leads!.remark == null) {
        remarkController.text = '';
      }

      /*  resumeController.text = widget.leads!.resume.toString();
      resumeId.text = widget.leads!.clientResumeId.toString();
      if (widget.leads!.clientResumeId == null ||
          widget.leads!.clientResumeId == '') {
        resumeId.text = '';
        isResumeId = false;
      } else {
        isResumeId = true;
      } */
      empIdController.text = widget.leads!.emp_id.toString();
      if (widget.leads!.emp_id == null) {
        empIdController.text = '';
      }
      interviewStatusController.text =
          widget.leads!.interview_rounds.toString();
      if (widget.leads!.interview_rounds == null ||
          widget.leads!.interview_rounds == '') {
        interviewStatusController.text = '';
      }
      subSourceController.text = widget.leads!.sub_source.toString();
      if (widget.leads!.sub_source == null) {
        subSourceController.text = '';
      }
      documentStatusController.text = widget.leads!.document_status.toString();
      if (widget.leads!.document_status == null) {
        documentStatusController.text = '';
      }
      modeOfDocument.text =
          widget.leads!.mode_document == 1 ? 'Online' : 'Offline';

      salaryController.text = widget.leads!.salary.toString();
      {
        if (widget.leads!.salary == null) {
          salaryController.text = '';
        }
      }
      /*   refferalController.text = widget.leads!.referralSource.toString();
      if (widget.leads!.referralSource == null) {
        refferalController.text = '';
      } */

      isEmp = widget.leads!.empCID.toString();
    }
    loadUserByRole();
    loadSpoc();
    loadSingleSource();
    loadSource();
  }

  void _handleStatusIdChange() {
    setState(() {
      getLeadsSubStatus(int.parse(status_id.toString()));
    });
  }

  void onTextField1Tap1(TextEditingController tappedController) {
    processController.clear();
    roleController.clear();
    functionalAreaController.clear();
    setState(() {
      isEdit4 = false;
      isEdit2 = false;
      isEdit1 = false;
    });
  }

  void onTextField1Tap2(TextEditingController tappedController) {
    roleController.clear();
    functionalAreaController.clear();
    setState(() {
      isEdit2 = false;
      isEdit1 = false;
    });
  }

  void onTextField1Tap3(TextEditingController tappedController) {
    functionalAreaController.clear();
    setState(() {
      isEdit2 = false;
    });
  }

  void onTextField1Tap4(TextEditingController tappedController) {}

  String? same;
  List<dynamic> suggestions = [];
  Future<List> getSuggestions(String pattern) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/company/v1/all?pageNumber=1&pageSize=100'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse the response and return the filtered suggestions
      suggestions = data['resultData']['content']
          .map((e) => e['name'].toString())
          .where((name) =>
              name.toString().toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to retrieve suggestions');
    }
  }

  @override
  void dispose() {
    // companyFocusNode.dispose();
    // processFocusNode.dispose();
    // roleFocusNode.dispose();
    // functionalAreaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    interviewDropDownRounds = interviewDropRounds
        .map((round) =>
            round.replaceAll('[', '').replaceAll(']', '').replaceAll('"', ''))
        .expand((formattedRound) => formattedRound.split(', '))
        .toList();

    interviewRounds = interviewDropRounds.isNotEmpty
        ? interviewDropDownRounds
        : widget.leads!.inteviewrounds!
            .map((round) => round
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', ''))
            .expand((formattedRound) => formattedRound.split(', '))
            .toList();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.leads == null ? "Add Leads" : "Edit Leads",
                style: GoogleFonts.varela(
                  fontSize: 18.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        bottomNavigationBar: InkWell(
          onTap: () {
            save();
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
                color: Constants.themeBgColor,
                borderRadius: BorderRadius.circular(15)),
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Save",
                  style: GoogleFonts.varela(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 10, left: 16, right: 16, bottom: 300),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                          controller: firstNameController,
                          isRef: widget.leads!.is_ref == 0 ? false : true,
                          hint: "Rahul",
                          label: "First Name",
                          isNumber: false,
                          icon: const Icon(Icons.person)),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: lastNameController,
                          isRef: widget.leads!.is_ref == 0 ? false : true,
                          hint: "Sharma",
                          label: "Last Name",
                          isNumber: false,
                          icon: const Icon(Icons.person)),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: contactNoController,
                          isRef: widget.leads!.is_ref == 0 ? false : true,
                          hint: "9172******",
                          label: "Primary Number",
                          isNumber: true,
                          isEdit: uid != 0 ? true : false,
                          icon: const Icon(Icons.phone_android)),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: alternateNoController,
                          isRef: widget.leads!.is_ref == 0 ? false : true,
                          hint: "9137******",
                          label: "Alternate Number",
                          isNumber: true,
                          icon: const Icon(Icons.phone_android)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customContainerMale(
                              isMale: false,
                              onPressed: () {
                                setState(() {
                                  isUnder = true;
                                  isGraduate = false;
                                });
                              },
                              isSelect: isUnder,
                              title: "Under Graduate",
                              img:
                                  "https://cdn-icons-png.flaticon.com/128/1344/1344761.png"),
                          customContainerMale(
                              isMale: false,
                              onPressed: () {
                                setState(() {
                                  isUnder = false;
                                  isGraduate = true;
                                });
                              },
                              isSelect: isGraduate,
                              title: "Graduate",
                              img:
                                  "https://cdn-icons-png.flaticon.com/128/1344/1344761.png"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customContainerMale(
                              isMale: false,
                              onPressed: () {
                                setState(() {
                                  isExp = true;
                                  isFresher = false;
                                });
                              },
                              isSelect: isExp,
                              title: "Experience",
                              img:
                                  "https://cdn-icons-png.flaticon.com/128/3281/3281289.png"),
                          customContainerMale(
                              isMale: false,
                              onPressed: () {
                                setState(() {
                                  isExp = false;
                                  isFresher = true;
                                });
                              },
                              isSelect: isFresher,
                              title: "Fresher",
                              img:
                                  "https://cdn-icons-png.flaticon.com/128/5155/5155956.png"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isComp
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  isComp = false;
                                  companyController.clear();
                                  processController.clear();
                                  roleController.clear();
                                  functionalAreaController.clear();
                                  isEdit4 = false;
                                  isEdit3 = false;
                                  isEdit2 = false;
                                  isProcess = true;
                                  isRole = true;
                                  isFunctionalArea = true;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Company",
                                    style: GoogleFonts.varela(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.sp,
                                  ),
                                  Container(
                                      width: double.maxFinite,
                                      // height: MediaQuery.of(context).size.height / 26.h,
                                      margin: const EdgeInsets.only(
                                          right: 5, bottom: 5),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        // ignore: use_full_hex_values_for_flutter_colors
                                        color: Constants.borderColor,

                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(companyController.text,
                                              style: GoogleFonts.varela(
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 15.sp)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Image.asset(
                                            "assets/images/pencil.png",
                                            height: 15.sp,
                                          )
                                        ],
                                      )),
                                ],
                              ))
                          : CustomCompanyForManagerLeadForm(
                              title: "Client Name",
                              controller: companyController,
                              onChanged: (p0) {
                                isEdit4 = p0;
                                setState(() {
                                  isComp = true;
                                });
                              },
                              getEmpID: (p0) {
                                setState(() {
                                  isEmp = p0.toString();
                                });
                              },
                              getGender: (p0) {
                                setState(() {
                                  isGender = p0.toString();
                                });
                              },
                              getSalary: (p0) {
                                setState(() {
                                  isSalary =
                                      p0.toString() == "1" ? true : false;
                                });
                              },
                              contextIn: context,
                              onSubmit: getCompanyId,
                              onGetResumeId: getResumeID,
                            ),
                      if ((resumeID == "1" &&
                          resumeID != null &&
                          isProcess &&
                          isEdit4))
                        resumeidfilled == false
                            ? Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              24,
                                      child: TextFormField(
                                        onTap: () {
                                          setState(() {
                                            processController.clear();
                                            roleController.clear();
                                            functionalAreaController.clear();
                                          });
                                        },
                                        onChanged: (p0) {
                                          resumeidfilled = true;
                                        },
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: resumeId,
                                        style: GoogleFonts.varela(
                                            color: Constants.subtitleclr,
                                            fontSize: 14.sp),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.restaurant_menu_outlined,
                                            color: Constants.themeBgColor,
                                          ),
                                          prefixIconColor:
                                              Constants.themeBgColor,
                                          contentPadding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 10,
                                            right: 10,
                                          ),
                                          counterText: '',
                                          labelText: 'Resume ID',
                                          labelStyle: GoogleFonts.sourceSansPro(
                                            color: Constants.themeBgColor,
                                            fontSize: 14.sp,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: const BorderSide(
                                              color: Color(0xffff0eceb),
                                            ),
                                          ),
                                          focusColor: const Color(0xffff0eceb),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: const BorderSide(
                                              color: Constants.themeBgColor,
                                            ),
                                          ),
                                          hintText: 'R1546464',
                                          hintStyle: GoogleFonts.sourceSansPro(
                                            color: Constants.hintColor,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              24,
                                      child: TextFormField(
                                        onTap: () {
                                          setState(() {
                                            resumeidfilled = false;
                                            resumeId.clear();
                                          });
                                        },
                                        textCapitalization:
                                            TextCapitalization.words,
                                        controller: resumeId,
                                        style: GoogleFonts.varela(
                                            color: Constants.subtitleclr,
                                            fontSize: 14.sp),
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.restaurant_menu_outlined,
                                            color: Constants.themeBgColor,
                                          ),
                                          prefixIconColor:
                                              Constants.themeBgColor,
                                          contentPadding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 10,
                                            right: 10,
                                          ),
                                          counterText: '',
                                          labelText: 'Resume ID',
                                          labelStyle: GoogleFonts.sourceSansPro(
                                            color: Constants.themeBgColor,
                                            fontSize: 14.sp,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: const BorderSide(
                                              color: Color(0xffff0eceb),
                                            ),
                                          ),
                                          focusColor: const Color(0xffff0eceb),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            borderSide: const BorderSide(
                                              color: Constants.themeBgColor,
                                            ),
                                          ),
                                          hintText: 'R1546464',
                                          hintStyle: GoogleFonts.sourceSansPro(
                                            color: Constants.hintColor,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      if (resumeID == "1"
                          ? resumeidfilled
                          : resumeidfilled == false)
                        isEdit4
                            ? SuggestionTextField(
                                onTapCallback: onTextField1Tap2,
                                companyID: company_id.toString(),
                                controller: processController,
                                textfieldNumber: 1,
                                process: processController.text,
                                role: roleController.text,
                                hint: "Health Insurance",
                                //   icon: Icons.propane_outlined,
                                title: "Process",
                                getFunctionalAreaId: (p0) {
                                  setState(() {
                                    processId = p0;
                                  });
                                },
                                /*     getSpoc: (int id) {},
                                getInterviewRounds: (List<String> id) {},
                                getJobId: (String id) {}, */
                                onChanged: (p0) {
                                  setState(() {
                                    isEdit1 = p0;
                                    roleController.clear();
                                    functionalAreaController.clear();
                                  });
                                },
                              )
                            : const SizedBox(),
                      if (isProcess == false)
                        InkWell(
                          onTap: () {
                            setState(() {
                              isProcess = true;
                              // isEdit4 = truep
                              isRole = true;
                              isFunctionalArea = true;
                              isEdit1 = false;
                              isEdit4 = true;
                              processController.clear();
                              roleController.clear();
                              functionalAreaController.clear();
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Process",
                                style: GoogleFonts.varela(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 4.sp,
                              ),
                              Container(
                                  width: double.maxFinite,
                                  // height: MediaQuery.of(context).size.height / 26.h,
                                  margin: const EdgeInsets.only(
                                      right: 5, bottom: 5),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    // ignore: use_full_hex_values_for_flutter_colors
                                    color: Constants.borderColor,

                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(processController.text,
                                          style: GoogleFonts.varela(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15.sp)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        "assets/images/pencil.png",
                                        height: 15.sp,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      if (isRole == true)
                        isEdit1 && isEdit4
                            ? SuggestionTextField(
                                onTapCallback: onTextField1Tap3,
                                companyID: company_id.toString(),
                                controller: roleController,
                                textfieldNumber: 2,
                                process: processController.text,
                                role: roleController.text,
                                // icon: Icons.engineering_outlined,
                                hint: "Sr. Executive",
                                title: "Job Title / Role",
                                getFunctionalAreaId: (p0) {
                                  setState(() {
                                    roleId = p0;
                                  });
                                },
                                onChanged: (p0) {
                                  setState(() {
                                    isEdit2 = p0;

                                    functionalAreaController.clear();
                                  });
                                },
                                /*   getSpoc: (int id) {},
                                getInterviewRounds: (List<String> id) {},
                                getJobId: (String id) {}, */
                              )
                            : const SizedBox(),
                      if (isRole == false)
                        InkWell(
                          onTap: () {
                            setState(() {
                              isRole = true;
                              isEdit3 = true;
                              isEdit1 = true;
                              isEdit4 = true;
                              isEdit2 = false;
                              isFunctionalArea = true;

                              roleController.clear();
                              functionalAreaController.clear();
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Role",
                                style: GoogleFonts.varela(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 4.sp,
                              ),
                              Container(
                                  width: double.maxFinite,
                                  // height: MediaQuery.of(context).size.height / 26.h,
                                  margin: const EdgeInsets.only(
                                      right: 5, bottom: 5),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    // ignore: use_full_hex_values_for_flutter_colors
                                    color: Constants.borderColor,

                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(roleController.text,
                                          style: GoogleFonts.varela(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15.sp)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        "assets/images/pencil.png",
                                        height: 15.sp,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      if (isFunctionalArea == true)
                        isEdit2 && isEdit1 && isEdit4
                            ? SuggestionTextFieldForNew(
                                onTapCallback: onTextField1Tap4,
                                companyID: company_id.toString(),
                                controller: functionalAreaController,
                                textfieldNumber: 3,
                                process: processController.text,
                                role: roleController.text,
                                // icon: Icons.outbond,
                                hint: "Sales",
                                title: "Functional Area",
                                getFunctionalAreaId: getFunctionalAreaIdCust,
                                /*   getSpoc: getSpoc,
                                getInterviewRounds: getInterviewRounds,
                                getJobId: getJobId, */
                                onChanged: (p0) {
                                  setState(() {
                                    isEdit3 = p0;
                                  });
                                },
                              )
                            : const SizedBox(),
                      if (isFunctionalArea == false)
                        InkWell(
                          onTap: () {
                            setState(() {
                              isFunctionalArea = true;
                              isEdit2 = true;
                              isEdit1 = true;
                              isEdit4 = true;

                              functionalAreaController.clear();
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Functional Area",
                                style: GoogleFonts.varela(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 4.sp,
                              ),
                              Container(
                                  width: double.maxFinite,
                                  // height: MediaQuery.of(context).size.height / 26.h,
                                  margin: const EdgeInsets.only(
                                      right: 5, bottom: 5),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    // ignore: use_full_hex_values_for_flutter_colors
                                    color: Constants.borderColor,

                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(functionalAreaController.text,
                                          style: GoogleFonts.varela(
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 15.sp)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        "assets/images/pencil.png",
                                        height: 15.sp,
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomStatusManager(
                        getHrStatusID: getHrStatusId,
                        controller: statusController,
                        /*  onTap: () {
                          statusController.clear();
                          subStatusList.clear();
                        }, */
                        onChanged: (p0) {
                          setState(() {
                            isStatus = true;
                            // result = null;
                            selectedSubStatusId = null;
                            dojController.clear();
                            remarkController.clear();
                            salaryController.clear();
                            empIdController.clear();
                            documentStatusController.clear();
                            isCommercialMale = false;
                            isCommercialFemale = false;
                            empIdController.clear();
                            salaryController.clear();
                            singleSelect = null;

                            // _handleStatusIdChange();
                          });
                        },
                        onSubmit: getStatusId,
                        contextIn: context,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if ((subStatusList.isNotEmpty) ||
                          ((status_id == '12' ||
                              status_id == '14' ||
                              status_id == '13')))
                        Wrap(
                          children: subStatusList.length == 1
                              ? [] // Return an empty list if subStatusList is empty
                              : subStatusList
                                  .where((subStatus) =>
                                      subStatus.hrSubStatus != null &&
                                      subStatus.hrSubStatus!
                                          .isNotEmpty) // Add a check for non-empty hrSubStatus
                                  .map((subStatus) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (subController.text ==
                                              subStatus.hrSubStatus) {
                                            // If the substatus is already selected, unselect it
                                            subController.text = '';
                                            selectedSubStatusId = null;
                                          } else {
                                            // Otherwise, select the substatus
                                            subController.text =
                                                subStatus.hrSubStatus!;
                                            selectedSubStatusId = subStatus.id;
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: subController.text ==
                                                        subStatus.hrSubStatus ||
                                                    widget.leads!
                                                            .hr_sub_status ==
                                                        subStatus.hrSubStatus
                                                ? Constants.bgColorWhite
                                                : Constants.themeBgColor,
                                          ),
                                          color: subController.text ==
                                                      subStatus.hrSubStatus ||
                                                  widget.leads!.hr_sub_status ==
                                                      subStatus.hrSubStatus
                                              ? Colors.grey.shade200
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          subStatus.hrSubStatus!,
                                          style: GoogleFonts.varela(
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                        ),
                      if (hrStatusId == '13')
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                singleSelectPicker();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: MediaQuery.of(context).size.height / 25,
                                margin: EdgeInsets.only(bottom: 5.h),
                                // width: MediaQuery.of(context).size.width / 1.8,
                                // height: 35,
                                color: Colors.white,
                                child: TextFormField(
                                  // focusNode: dojFocusNode,
                                  enabled: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "This Text field Cant be empty";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: dojController,
                                  /* onTap: () {
                              selectDate();
                            }, */
                                  style: GoogleFonts.varela(
                                      color: Constants.subtitleclr,
                                      fontSize: 14.sp),
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.calendar_month_outlined),
                                      prefixIconColor: Constants.themeBgColor,
                                      contentPadding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 10,
                                          right: 10),
                                      counterText: '',
                                      labelText: "DOJ",
                                      labelStyle: GoogleFonts.varela(
                                        color: Constants.themeBgColor,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: const BorderSide(
                                          color: Color(0xffff0eceb),
                                        ),
                                      ),
                                      focusColor: const Color(0xffff0eceb),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: const BorderSide(
                                          color: Constants.themeBgColor,
                                        ),
                                      ),
                                      hintText: "26-Jan-2024",
                                      hintStyle: GoogleFonts.sourceSansPro(
                                          color: Constants.hintColor,
                                          fontSize: 14.sp)),
                                ),
                              ),
                            ),
                            dojController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        dojController.clear();
                                      });
                                    },
                                    icon: const Icon(Icons.close))
                                : const SizedBox()
                          ],
                        ),
                      if (hrStatusId == '13' && selectedSubStatusId == 18)
                        const SizedBox(
                          height: 10,
                        ),
                      if ((hrStatusId == '13' &&
                          selectedSubStatusId == 18 &&
                          isEmp == '1'))
                        CustomTextField(
                            controller: empIdController,
                            hint: "AB001",
                            label: "Emp Id",
                            isNumber: false,
                            icon: const Icon(Icons.eleven_mp)),
                      if ((hrStatusId == '13' &&
                          selectedSubStatusId == 18 &&
                          isEmp == '1'))
                        const SizedBox(
                          height: 10,
                        ),
                      if (hrStatusId == '13' && selectedSubStatusId == 18)
                        CustomTextField(
                            controller: salaryController,
                            hint: "18000",
                            label: "Salary",
                            isNumber: true,
                            icon: const Icon(Icons.money)),
                      if ((hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              widget.leads!.is_ctc_pay == 1) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              widget.leads!.is_work_pay == 1) ||
                          salaryController.text.isNotEmpty ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isSalary == "1"))
                        const SizedBox(
                          height: 10,
                        ),
                      if (hrStatusId == '14' || hrStatusId == '15')
                        Wrap(
                          children:
                              List.generate(interviewRounds.length, (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    if (selectedValue == //TODO do not remove
                                        interviewRounds[index]) {
                                      // If the item is already selected, unselect it
                                      selectedValue = null;
                                    } else {
                                      // Otherwise, select the item
                                      selectedValue = interviewRounds[index];
                                    }
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectedValue ==
                                                  interviewRounds[index]
                                              ? Colors.white
                                              : index <
                                                      interviewRounds.indexOf(
                                                          selectedValue
                                                              .toString())
                                                  ? Colors.white
                                                  : Constants.themeBgColor,
                                        ),
                                        color: selectedValue ==
                                                interviewRounds[index]
                                            ? Colors.grey
                                                .shade200 // Set color when the condition is true
                                            : index <
                                                    interviewRounds.indexOf(
                                                        selectedValue
                                                            .toString())
                                                ? Colors.grey
                                                    .shade200 // Set color for items before the matching item
                                                : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    child: Text(
                                      interviewRounds[index],
                                      style: GoogleFonts.varela(
                                          color: Colors.grey.shade500),
                                    )),
                              ),
                            );
                          }),
                        ),
                      if (hrStatusId == '14' || hrStatusId == '15')
                        const SizedBox(
                          height: 10,
                        ),
                      if (hrStatusId == '13')
                        Wrap(
                          children:
                              List.generate(documentStatus.length, (index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 10),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    if (documentStatusController.text ==
                                        documentStatus[index]) {
                                      // If the substatus is already selected, unselect it
                                      documentStatusController.text = '';
                                    } else {
                                      // Otherwise, select the substatus
                                      documentStatusController.text =
                                          documentStatus[index];
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: documentStatusController.text ==
                                              documentStatus[index]
                                          ? Constants.bgColorWhite
                                          : Constants.themeBgColor,
                                    ),
                                    color: documentStatusController.text ==
                                            documentStatus[index]
                                        ? Colors.grey.shade200
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    documentStatus[index],
                                    style: GoogleFonts.varela(
                                        color: Colors.grey.shade500),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      if (hrStatusId == '13')
                        const SizedBox(
                          height: 10,
                        ),
                      if ((hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              workId == '1') ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCompanyExp == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCompanyFresher == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              widget.leads!.is_work_pay == 1))
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 0, right: 0, bottom: 10),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Company Work Status",
                                style: GoogleFonts.varela(
                                  color: Constants.themeBgColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Expanded(
                                child: Divider(
                                  thickness: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if ((hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isGender == '1') ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCompanyExp == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCompanyFresher == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              widget.leads!.is_work_pay == 1))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customContainerMale(
                                isMale: false,
                                onPressed: () {
                                  setState(() {
                                    isCompanyExp = true;
                                    isCompanyFresher = false;
                                  });
                                },
                                isSelect: isCompanyExp,
                                title: "Experienced",
                                img:
                                    "https://cdn-icons-png.flaticon.com/128/1344/1344761.png"),
                            customContainerMale(
                                isMale: false,
                                onPressed: () {
                                  setState(() {
                                    isCompanyExp = false;
                                    isCompanyFresher = true;
                                  });
                                },
                                isSelect: isCompanyFresher,
                                title: "Fresher",
                                img:
                                    "https://cdn-icons-png.flaticon.com/128/5155/5155956.png"),
                          ],
                        ),
                      if ((hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              workId == '1') ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCompanyExp == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCompanyFresher == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              widget.leads!.is_work_pay == 1))
                        const SizedBox(
                          height: 10,
                        ),
                      if ((hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              genderId == '1') ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCommercialMale == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCommercialFemale == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              widget.leads!.gender == 1))
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 0, right: 0, bottom: 10),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1.5,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Company Gender",
                                style: GoogleFonts.varela(
                                  color: Constants.themeBgColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Expanded(
                                child: Divider(
                                  thickness: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if ((hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              genderId == '1') ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCommercialMale == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCommercialFemale == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              widget.leads!.gender == 1))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customContainerMale(
                                isMale: true,
                                onPressed: () {
                                  setState(() {
                                    isCommercialMale = true;
                                    isCommercialFemale = false;
                                  });
                                },
                                isSelect: isCommercialMale,
                                title: "Male",
                                img: "assets/images/leadmale.png"),
                            customContainerMale(
                                isMale: false,
                                onPressed: () {
                                  setState(() {
                                    isCommercialMale = false;
                                    isCommercialFemale = true;
                                  });
                                },
                                isSelect: isCommercialFemale,
                                title: "Female",
                                img: "assets/images/leadfemal.png"),
                          ],
                        ),
                      if ((hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              genderId == '1') ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCommercialMale == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              isCommercialFemale == true) ||
                          (hrStatusId == '13' &&
                              selectedSubStatusId == 18 &&
                              widget.leads!.gender == 1))
                        const SizedBox(
                          height: 10,
                        ),
                      if (statusController.text == 'Reject' ||
                          statusController.text == 'Revoke' ||
                          subController.text == 'Drop-out' ||
                          subController.text == 'Offer Decline' ||
                          subController.text == 'Not Join' ||
                          subController.text == 'Training Dropout' ||
                          statusController.text == 'Screening Reject' ||
                          statusController.text == 'Wrong Number' ||
                          subController.text == 'On-Hold')
                        CustomTextField(
                            controller: remarkController,
                            hint: "",
                            label: "Remark",
                            isNumber: false,
                            icon: const Icon(Icons.pending_actions)),
                      if (statusController.text == 'Reject' ||
                          statusController.text == 'Revoke' ||
                          subController.text == 'Drop-out' ||
                          subController.text == 'Offer Decline' ||
                          subController.text == 'Not Join' ||
                          subController.text == 'Training Dropout' ||
                          statusController.text == 'Screening Reject' ||
                          statusController.text == 'Wrong Number' ||
                          subController.text == 'On-Hold')
                        const SizedBox(
                          height: 10,
                        ),
                      if (statusController.text != 'Application')
                        const SizedBox(
                          height: 10,
                        ),
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 24,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              controller: spocController.text.isNotEmpty
                                  ? spocController
                                  : TextEditingController(text: selectValue),
                              onTap: () {
                                setState(() {
                                  if (selectValue.isNotEmpty) {
                                    selectValue = '';
                                    spocController.text = '';
                                    isValue = false;
                                    isDropOpen = !isDropOpen;
                                  } else {
                                    isDropOpen = !isDropOpen;
                                  }
                                });
                              },
                              style: GoogleFonts.varela(
                                  color: Constants.subtitleclr,
                                  fontSize: 14.sp),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                prefixIconColor: Constants.themeBgColor,
                                contentPadding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                counterText: '',
                                labelText: "Spoc",
                                labelStyle: GoogleFonts.sourceSansPro(
                                  color: Constants.themeBgColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xffff0eceb)),
                                ),
                                focusColor: const Color(0xffff0eceb),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Constants.themeBgColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isDropOpen)
                            Column(
                              children: content.map(
                                (userData) {
                                  SpocModel userModel =
                                      SpocModel.fromJson(userData);

                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    height: 32,
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: content.indexOf(userData) % 2 == 1
                                          ? Colors.grey.shade100
                                          : Colors.grey,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectValue =
                                              "${userModel.firstName} ${userModel.lastName} -  ${userModel.role}";
                                          spocController.text = selectValue;
                                          selectedSpocId = userModel.id;
                                          spocFirsName = userModel.firstName;
                                          spocLastName = userModel.lastName;
                                          isValue = true;
                                          isDropOpen = false;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userModel.firstName
                                                      .toString(),
                                                  style:
                                                      GoogleFonts.sourceSansPro(
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Text(" "),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userModel.lastName.toString(),
                                                  style:
                                                      GoogleFonts.sourceSansPro(
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Text("  -  "),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userModel.role.toString(),
                                                  style:
                                                      GoogleFonts.sourceSansPro(
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
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
                              ).toList(),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 24,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              controller: sourceNameController.text.isNotEmpty
                                  ? sourceNameController
                                  : TextEditingController(text: sourceValue),
                              onTap: () {
                                setState(() {
                                  if (sourceValue.isNotEmpty) {
                                    sourceValue = '';
                                    sourceNameController.text = '';
                                    isSourceName = false;
                                    isSourceDropOpen = !isSourceDropOpen;
                                  } else {
                                    isSourceDropOpen = !isSourceDropOpen;
                                  }
                                });
                              },
                              style: GoogleFonts.varela(
                                  color: Constants.subtitleclr,
                                  fontSize: 14.sp),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                prefixIconColor: Constants.themeBgColor,
                                contentPadding: const EdgeInsets.only(
                                    top: 8, bottom: 8, left: 10, right: 10),
                                counterText: '',
                                labelText: "Source",
                                labelStyle: GoogleFonts.sourceSansPro(
                                  color: Constants.themeBgColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xffff0eceb)),
                                ),
                                focusColor: const Color(0xffff0eceb),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Constants.themeBgColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isSourceDropOpen)
                            Column(
                              children: sourceName.map(
                                (sourceData) {
                                  SpocModel uModel =
                                      SpocModel.fromJson(sourceData);

                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    height: 32,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          sourceName.indexOf(sourceData) % 2 ==
                                                  1
                                              ? Colors.grey.shade100
                                              : Colors.grey,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          sourceValue =
                                              "${uModel.firstName} ${uModel.lastName}";
                                          sourceNameController.text =
                                              sourceValue;
                                          selectedSourceId = uModel.id;

                                          isSourceName = true;
                                          isSourceDropOpen = false;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  uModel.firstName.toString(),
                                                  style:
                                                      GoogleFonts.sourceSansPro(
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Text(" "),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  uModel.lastName.toString(),
                                                  style:
                                                      GoogleFonts.sourceSansPro(
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
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
                              ).toList(),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (refferalController.text.isNotEmpty)
                        CustomTextField(
                            controller: refferalController,
                            hint: "Rahul Sharma",
                            label: "Referral Source",
                            isNumber: false,
                            icon: const Icon(Icons.person)),
                      if (refferalController.text.isNotEmpty)
                        const SizedBox(
                          height: 10,
                        ),
                      if (subSourceController.text.isNotEmpty)
                        CustomTextField(
                            controller: subSourceController,
                            hint: "Rahul Sharma",
                            label: "Sub Source",
                            isNumber: false,
                            icon: const Icon(Icons.person)),
                      if (subSourceController.text.isNotEmpty)
                        const SizedBox(
                          height: 10,
                        ),
                    ]))));
  }

  int selectedDocumentStatusIndex = -1;

  InkWell customContainerSelectToViewDoc({
    required final VoidCallback onPressed,
    required String title,
  }) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: GoogleFonts.sourceSansPro(
                        color: Constants.themeBgColor, fontSize: 14.sp)),
                SizedBox(
                  width: 6.w,
                ),
                Icon(
                  Icons.visibility_outlined,
                  color: Constants.themeBgColor,
                  size: 18.h,
                )
              ],
            )));
  }

  InkWell customContainerSelect(
      {required final VoidCallback onPressed,
      required String title,
      bool isHalf = false,
      bool isVacancy = false,
      bool isNumOfOpening = false,
      bool isAnother = false,
      bool isEmails = false,
      bool isCross = false,
      bool? isSalary = false}) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: isAnother
                ? null
                : isNumOfOpening
                    ? MediaQuery.of(context).size.width / 2.449
                    : isEmails
                        ? MediaQuery.of(context).size.width / 2.437
                        : MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent)),
            child: Text(title,
                style: GoogleFonts.sourceSansPro(
                    color: Constants.themeBgColor, fontSize: 14.sp))));
  }

  Container CustomTextField(
      {required Icon icon,
      required String hint,
      required String label,
      int? maxLength,
      int? maxLines,
      bool isNumber = false,
      bool isRef = true,
      bool? keyboardType,
      bool? isOptional = false,
      bool isEdit = false,
      bool isResume = false,
      required TextEditingController controller}) {
    return Container(
      width:
          isResume ? MediaQuery.of(context).size.width / 1.4 : double.infinity,
      height: MediaQuery.of(context).size.height / 24,
      decoration: BoxDecoration(
        color:
            isEdit ? Colors.grey.shade200.withOpacity(1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This Text field Cant be empty";
          }
          return null;
        },
        inputFormatters: isNumber
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ]
            : null,
        enabled: isEdit ? false : true,
        maxLength: maxLength,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.name,
        //textInputAction: TextInputAction.s, // Set TextInputAction to sentences
        textCapitalization: TextCapitalization.words,
        controller: controller,
        onTap: (() {}),
        style:
            GoogleFonts.varela(color: Constants.subtitleclr, fontSize: 14.sp),
        decoration: InputDecoration(
            enabled: isRef,
            prefixIcon: icon,
            prefixIconColor: Constants.themeBgColor,
            suffix: isOptional != null && isOptional
                ? const Text("(Optional)")
                : const SizedBox(),
            contentPadding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            counterText: '',
            labelText: label,
            labelStyle: GoogleFonts.sourceSansPro(
              color: Constants.themeBgColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xffff0eceb)),
            ),
            focusColor: const Color(0xffff0eceb),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Constants.themeBgColor,
              ),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.sourceSansPro(
                color: Constants.hintColor, fontSize: 14.sp)),
      ),
    );
  }

  InkWell customContainerMale({
    required final VoidCallback onPressed,
    required bool isSelect,
    required String title,
    required String img,
    bool? isSalary = false,
    bool isDoc = false,
    bool isMale = false,
  }) {
    return InkWell(
        onTap: onPressed,
        child: Container(
            width: isDoc
                ? MediaQuery.of(context).size.width / 4.w
                : MediaQuery.of(context).size.width / 2.6.w,

            // height: MediaQuery.of(context).size.height / 26.h,
            margin: const EdgeInsets.only(top: 5, bottom: 5, right: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color:
                    // isSelect ? const Color(0xfff310d44) :
                    Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: isSelect
                    ? Border.all(color: Constants.themeBgColor)
                    : null),
            // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                isMale
                    ? Image.asset(
                        img,
                        height: 20,
                      )
                    : Image.network(
                        img,
                        height: 20,
                      ),
                const SizedBox(
                  width: 10,
                ),
                Text(title,
                    style: GoogleFonts.sourceSansPro(
                        color: Constants.subtitleclr, fontSize: 14.sp)),
              ],
            )));
  }

  Future<String?> uploadFile({
    allowExt,
  }) async {
    Utils.showLoaderDialog(context, "");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowExt,
      withReadStream: true,
    );

    if (result != null) {
      try {
        var res = await FileUploadService()
            .uploadSingleFile('cv', result.files.single);
        var resultD = Utils.parseResponse(res);

        if (resultD.resultKey == 'SUCCESS') {
          String filePath = result.files.single.path ?? '';
          String filename = resultD.resultData[0]["fileName"];
          Navigator.pop(context);
          setState(() {});
          return filename;
        } else {
          // Close the loading dialog when there is an error
          Navigator.pop(context);

          // Handle the case where the server returns an error
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error while uploading cv"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  ),
                ],
              );
            },
          );
          return null;
        }
      } catch (e) {
        Navigator.pop(context);
        return null;
      }
    } else {
      Navigator.pop(context);
      setState(() {});
      return null;
    }
  }

  Future<void> save() async {
    int hrsubid;

    int? isExperienced;
    if (isExp == true) {
      isExperienced = 1;
    } else if (isFresher == false) {
      isExperienced = 0;
    }

    if (hrStatusId == '11') {
      hrsubid = 3;
    } else if (selectedSubStatusId == null) {
      switch (hrStatusId) {
        case '13':
        case '14':
        case '15':
        case '16':
        case '17':
        case '18':
        case '19':
          hrsubid = 0;
          break;
        default:
          hrsubid = int.parse(selectedSubStatusId.toString());
      }
    } else {
      hrsubid = int.parse(selectedSubStatusId.toString());
    }

    DateTime? parsedDateTime;

    if (widget.leads!.doj != null) {
      try {
        parsedDateTime = DateTime.parse(widget.leads!.doj.toString());
      } catch (e) {
        parsedDateTime = null;
      }
    } else {
      parsedDateTime = null;
    }

    JobApplicationModel leadsModel = JobApplicationModel(
      id: leadId,
      applicantName: firstNameController.text,
      lastName: lastNameController.text,
      contactNo: int.tryParse(contactNoController.text),
      alternateNo: alternateNoController.text.isNotEmpty
          ? int.tryParse(alternateNoController.text)
          : null,
      qualification: isGraduate == true ? "Graduate" : "Under Graduate",
      isExperienced: isExperienced,
      companyName: companyController.text,
      shortListFor: company_id,
      process: processController.text,
      level: roleController.text,
      naturofwork: functionalAreaController.text,
      interview_rounds: status_id == '13'
          ? interviewRounds[interviewRounds.length - 1]
          : selectedValue,
      client_resume_id: resumeController.text,
      hrStatusId: int.tryParse(hrStatusId.toString()),
      status_id: hrsubid,
      spoc: widget.leads!.spoc,
      sourceId: widget.leads!.sourceId,
      sourceName: sourceNameController.text,
      jobid: newJobID,
      dol: widget.leads!.dol,
      remark: feedbackController.text,
      resume: icon_data,
      doj: hrStatusId == "13"
          ? dojController.text.isNotEmpty
              ? DateFormat('dd MMM yyyy').parse(dojController.text)
              : null
          : null,
      uid: uid,
      document_status: selectedValue,

      /* lastName: lastNameController.text,
      companyName: companyController.text,
      process: processController.text,
      level: roleController.text,
      natureOfWork: functionalAreaController.text,
      clientResumeId: resumeId.text,
      empId: empIdController.text,
      sourceName: sourceNameController.text,
      remark: remarkController.text,
      resume: icon_data,
      interviewRounds: status_id == '13'
          ? interviewRounds[interviewRounds.length - 1]
          : selectedValue,
      contactNo: int.tryParse(contactNoController.text),
      alternateNo: int.tryParse(alternateNoController.text),
      qualification: eduController.text,
      isExperienced: isExperienced,
      shortListFor: shortListId != null
          ? int.tryParse(shortListId.toString())
          : widget.leads!.shortListfor,
      sourceId: selectedSourceId ?? widget.leads!.sourceId,
      spoc: selectedSpocId != null
          ? int.parse(selectedSpocId.toString())
          : widget.leads!.spoc,
      jobId: newJobID != null
          ? int.parse(newJobID.toString())
          : widget.leads!.jobId,
      rid: widget.leads!.rid,
      uid: widget.leads!.uid ?? 0,
      isRef: widget.leads!.isRef,
      dol: (widget.leads!.dol == null && status_id == '12' && hrsubid == 4)
          ? DateTime.now()
          : DateTime.tryParse(widget.leads!.dol.toString()),
      doj: singleSelect ?? parsedDateTime,
      salary: salaryController.text.isNotEmpty
          ? double.parse(salaryController.text)
          : null,
      companyExp: isCompanyExp == true
          ? 1
          : isCompanyExp == false
              ? null
              : null,
      commercialGender: isCommercialMale == true
          ? 'Male'
          : isCommercialFemale == true
              ? 'Female'
              : null,
      notes: notesController.text,
      subSource: subSourceController.text,
      referralSource: refferalController.text,
      attrStatus: status_id == '13' && hrsubid == 18
          ? 'Under Clause'
          : widget.leads!.attrStatus,
      isJoinSubmitted:
          ((widget.leads!.isCtcPay == 1 || widget.leads!.isWorkPay == 1) &&
                  salaryController.text.isNotEmpty &&
                  documentStatusController.text == 'Submitted' &&
                  widget.leads!.empCID == 1 &&
                  empIdController.text.isNotEmpty &&
                  widget.leads!.isWork == 1 &&
                  (isCompanyExp || isCompanyFresher))
              ? 1
              : null,
      billableCtc: widget.leads!.billableCtc,
      billingNotes: widget.leads!.billingNotes,
      partnerPaymentStatus: widget.leads!.partnerPaymentStatus,
      dot: widget.leads!.dot != null
          ? DateTime.tryParse(widget.leads!.dot.toString())
          : null,
      transactionNo: widget.leads!.transactionNo,
      modeDocument: widget.leads!.modeDocument,
      hrStatusId: int.parse(status_id.toString()),
      statusId: hrsubid,
      documentStatus: documentStatusController.text,
      invoiceDate: widget.leads!.invoiceDate != null
          ? DateTime.tryParse(widget.leads!.invoiceDate.toString())
          : null,
      invoiceNo: widget.leads!.invoiceNo,
      totalAmount: widget.leads!.totalAmount,
      lastWorkingDate: widget.leads!.lastWorkingDate != null
          ? DateTime.tryParse(widget.leads!.lastWorkingDate.toString())
          : null, */

      // statusId: status_id == '11'
      //     ? 3
      //     : (status_id == '13' && selectedSubStatusId == null)
      //         ? 1
      //         : (status_id == '14' && selectedSubStatusId == null)
      //             ? 0
      //             : (status_id == '15' && selectedSubStatusId == null)
      //                 ? 0
      //                 : (status_id == '16' && selectedSubStatusId == null)
      //                     ? 0
      //                     : (status_id == '17' && selectedSubStatusId == null)
      //                         ? 0
      //                         : (status_id == '18' &&
      //                                 selectedSubStatusId == null)
      //                             ? 0
      //                             : (status_id == '19' &&
      //                                     selectedSubStatusId == null)
      //                                 ? 0
      //                                 : selectedStatusId ??
      //                                     widget.leads!.hrSubStatusId

      //                                     );
    );

    Map<String, dynamic> requestBody = leadsModel.toJson();
    await JobPostApiService.addResume(requestBody, context, false);
   

    /*  try {
      final response = await http.post(
        Uri.parse('http://${GlobalConstants.API_Host}/leads/v1'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(CustomSnackbarfinal(
            title: "Leads Update successful!", error: false));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackbarfinal(title: "leads Faild to save!", error: true));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackbarfinal(
          title: "Exception while saving lead!", error: true));
    } */
  }
}
