import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/components/cv.dart';
import 'package:job_circle/components/theme_button.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/card_model.dart';
import 'package:job_circle/models/profileSummary.dart';
import 'package:job_circle/screens/profile/screen1.dart';
import 'package:job_circle/screens/profile/screen2.dart';
import 'package:job_circle/screens/profile/screen3.dart';
import 'package:job_circle/service/FileUploadService.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfileSummaryPartner extends StatefulWidget {
  const ProfileSummaryPartner({Key? key}) : super(key: key);

  @override
  State<ProfileSummaryPartner> createState() => _ProfileSummaryPartnerState();
}

class _ProfileSummaryPartnerState extends State<ProfileSummaryPartner> {
  late Widget previousWidget;
  var profile_final_pic = "";
  var profile_cv_link = "";
  var profile_cv_file = "";
  var partner_request = 1;

  // Veriable Declaration
  CardModel model = CardModel();
  TextEditingController username = TextEditingController();
  TextEditingController joblocation = TextEditingController();
  TextEditingController emailadr = TextEditingController();
  var usertype = 0;
  String gendor = "";
  late ProfileSummaryModel profilemodel = ProfileSummaryModel();
  final basicForm = GlobalKey<FormState>();
  final spinkit = const SpinKitRotatingCircle(
    color: Colors.white,
    size: 50.0,
  );

  bool get kDebugMode => false;
  @override
  void initState() {
    super.initState();
    bindProfileSummary();
  }

  bindProfileSummary() async {
    SharedPreferences prefs = await Utils.getSharedPreferences();
    usertype = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_type.name);

    partner_request = await Utils.getCacheData('partner_request');
    setState(() {});
    var result = await UserDataService().getUserProfileSummary(
        await Utils.getPreferencesValue(
            prefs, ESharedPreferences.user_id.name));
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      var dataResult = Utils.parseResponse(result).resultData;
      profilemodel = ProfileSummaryModel.fromMap(dataResult);
      profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
      profile_cv_file = Utils.getFileName(profile_cv_link);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Center(
              //     child: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SmartCard(model: model),
              // )),

              Expanded(
                child: SingleChildScrollView(
                  child: profilemodel.first_name == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(children: [
                          Stack(
                            children: [
                              basicInfo(),
                              Positioned(
                                top: 0,
                                left: (MediaQuery.of(context).size.width / 2) -
                                    60,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            Image.network(profile_final_pic)
                                                .image,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          var data =
                                              await uploadFile(['jpeg', 'jpg']);
                                          var payload = {
                                            "stage": "profile_pic",
                                            "data": {
                                              "id": await Utils
                                                  .getPreferencesValue(
                                                      null,
                                                      ESharedPreferences
                                                          .user_id.name),
                                              "profile_pic": data['fileName']
                                            }
                                          };
                                          await save(data['fileName'], payload);
                                        },
                                        child: const Text("Change Photo"))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                              visible: (usertype == 1 ? true : false),
                              child: education()),
                          Visibility(
                              visible: (usertype == 1 ? true : false),
                              child: experience()),
                          Visibility(
                              visible: (usertype == 1 ? true : false),
                              child: contactDetails()),
                          Visibility(
                              visible: (partner_request ==
                                          EPartnerApproval.pending.value ||
                                      partner_request ==
                                          EPartnerApproval.reject.value
                                  ? false
                                  : true),
                              child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: cardCustom(
                                    icon: Icons.handshake_outlined,
                                    isedit: false,
                                    title: "Partner",
                                    child: ThemeButton(
                                      onPressed: () => {
                                        Navigator.pushNamed(context,
                                            ERoute.businesspartner.value)
                                      },
                                      themeButtonSize: ThemeButtonSize.small,
                                      isText: true,
                                      text: "Click here to fill details",
                                    ),
                                  ))),
                          Visibility(
                              visible: (usertype == 1 ? true : false),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 3, right: 3),
                                child: cardCustom(
                                    icon: Icons.file_copy,
                                    isedit: false,
                                    title: "Resume",
                                    child: CVWidget(
                                        profileCv: ProfileCv(
                                            cv_link: profilemodel.cv_link,
                                            profile_cv_link: profile_cv_link,
                                            cv_upladted_date:
                                                profilemodel.cv_upladted_date,
                                            profile_cv_file: profile_cv_file),
                                        onUpload: (fileName, payload) async =>
                                            {await save(fileName, payload)})),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: cardCustom(
                                isedit: false,
                                title: "",
                                child: Column(
                                  children: [
                                    ThemeButton(
                                      icon: const Icon(Icons.logout),
                                      text: "Sign Out",
                                      onPressed: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () async {
                                          await AppUtils.clearSession();
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              ERoute.login.value,
                                              (Route<dynamic> route) => false);
                                          // Navigator.pushReplacementNamed(context, nextRoute.value);
                                        });
                                        //
                                      },
                                      themeButtonSize: ThemeButtonSize.small,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )),
                          )
                        ]),
                ),
              ),
            ],
          ),
        ));
  }

  Widget basicInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, top: 100, right: 3),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: cardCustom(
              // icon: Icons.account_circle_outlined,
              title: "",
              onPress: (() {
                // Navigator.pushNamed(context, ERoute.screen1.value,
                //     arguments: 1);
                sendToBasicInfo();
              }),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profilemodel.first_name.toString().toTitleCase() +
                        ' ' +
                        profilemodel.last_name.toString().toTitleCase(),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w300),
                  ),
                  if (usertype == EUserType.jobSeeker.value)
                    const SizedBox(height: 10),
                  if (usertype == EUserType.jobSeeker.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Location",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          profilemodel.job_location_city.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  if (usertype == EUserType.jobSeeker.value)
                    const SizedBox(height: 10),
                  if (usertype == EUserType.jobSeeker.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Gender",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          profilemodel.gender.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  if (usertype == EUserType.jobSeeker.value)
                    const SizedBox(height: 10),
                  if (usertype == EUserType.jobSeeker.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Languages",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          profilemodel.languages!.join(',').toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  if (usertype == EUserType.jobSeeker.value)
                    const SizedBox(height: 10),
                  if (usertype == EUserType.jobSeeker.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Date Of Birth",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          DateFormat('MMMM dd,yyyy').format(DateTime.parse(
                              profilemodel.dateofbirth.toString())),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget education() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: cardCustom(
              onPress: (() {
                sendToEducation();
              }),
              icon: Icons.school_outlined,
              title: "Education",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Highest Education",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        profilemodel.education.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "University / Institite",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        profilemodel.univercity.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Degree / Specialization",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        profilemodel.degree_spc.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Passing Year",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        profilemodel.passing_year.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget experience() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: cardCustom(
              onPress: (() {
                sendToExperience();
              }),
              icon: Icons.business_center_outlined,
              title: "Experience",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (profilemodel.has_experience == 1)
                        const Text(
                          "Years of Experience",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      if (profilemodel.has_experience == 1)
                        Text(
                          profilemodel.experience.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      if (profilemodel.has_experience == 0)
                        const Text(
                          "No Experience",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: profilemodel.has_experience == 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Company Name",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          profilemodel.companyName.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: profilemodel.has_experience == 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Job Title",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          profilemodel.job_title.toString(),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contactDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 3, right: 3),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: cardCustom(
              isedit: false,
              icon: Icons.alternate_email_outlined,
              title: "Contact Details",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Mobile",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        profilemodel.mobile.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        profilemodel.email.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card cardCustom(
      {required String title,
      IconData? icon,
      Widget? child,
      bool? isedit = false,
      Function()? onPress}) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isedit == true)
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: onPress,
                              )
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  child: child,
                )
              ],
            )));
  }

  updateCard(CardModel items) {
    model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    // model.cardName = items.cardName == "" ? "Your Name" : items.cardName;
    setState(() {});
  }

  // saveTo() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString('username', username.text);
  //   save();
  //   setState(() {});
  // }

  // save() async {
  //   // var result = await UserDataService().getUser(1);

  //   // print(Utils.parseResponse(result).resultData);

  //   var result = await UserDataService().saveUserStages({
  //     "stage": "otp",
  //     "data": {"mobile": "9321284090"}
  //   });
  //   print(Utils.parseResponse(result));
  // }

  sendToBasicInfo() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen1(
          prevPageModel: profilemodel,
        ),
      ),
    );
    if (result != null) {
      profilemodel.first_name = result.first_name;
      profilemodel.last_name = result.last_name;
      profilemodel.job_location_city = result.job_location_city;
      profilemodel.gender = result.gender;
      profilemodel.languages = result.languages;
      setState(() {});
    }
  }

  sendToEducation() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen2(
          prevPageModel: profilemodel,
        ),
      ),
    );
    if (result != null) {
      profilemodel.education = result.education;
      setState(() {});
    }
  }

  sendToExperience() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Screen3(
          prevPageModel: profilemodel,
        ),
      ),
    );
    if (result != null) {
      profilemodel.experience = result.experience;
      setState(() {});
    }
  }

  uploadFile(allowExt) async {
    Utils.showLoaderDialog(context, "Uploading...");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowExt,
        withReadStream: true);

    if (result != null) {
      var res =
          await FileUploadService().uploadSingleFile("cv", result.files.single);
      var resultD = Utils.parseResponse(res);
      Navigator.pop(context);
      if (resultD.resultKey == 'SUCCESS') {
        return resultD.resultData[0];
      }
      // File file = File(result.files.single.readStream.first!);
    } else {
      Navigator.pop(context);
      return null;
      // User canceled the picker
    }
  }

  save(filePath, data) async {
    var result = await UserDataService().saveUserStages(data);
    if (Utils.parseResponse(result).resultKey == 'SUCCESS') {
      if (data['stage'] == 'profile_pic') {
        profilemodel.profile_pic = filePath;
        profile_final_pic = Utils.resolveImage(profilemodel.profile_pic);
      } else if (data['stage'] == 'upload_cv') {
        profilemodel.cv_link = filePath;
        profile_cv_link = Utils.resolveImage(profilemodel.cv_link);
        profile_cv_file = Utils.getFileName(profile_cv_link);

        profilemodel.cv_upladted_date =
            DateFormat('MMM dd, yyyy').format(DateTime.now());
      } else if (data['stage'] == 'partnerRequest') {
        profilemodel.partner_request = data['data']['partner_request'];
      }
    }
    setState(() {});
  }
}
