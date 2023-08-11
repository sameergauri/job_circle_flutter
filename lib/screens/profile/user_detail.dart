import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../../common/utils.dart';
import '../../constants/gobal.dart';
import '../../models/userPage.dart';
import '../../themes/colors.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with SingleTickerProviderStateMixin {
  int? cutTab;
  Offset position = const Offset(.0, 200.0);
  late Widget previousWidget;

  late UserDetail profilemodel = UserDetail();
  var usertype = 0;
  List<UserDetail> profileSummaries = [];
  List<UserDetail> filteredProfiles = [];
  List<UserDetail> searchResults = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();

  // Initialize these lists inside the initState method
  List<bool> cardVisibilityList = [];
  List<int> dismissedCardIndexes = [];

  // Define a TextEditingController to control the search field
  final TextEditingController _searchController = TextEditingController();

  // bindProfileSummary() async {
  //   var result = await UserDataService().getAllUserDetails();
  //   if (Utils.parseResponse(result).resultData != null) {
  //     var dataResult = Utils.parseResponse(result).resultData;

  //     // Assuming dataResult is a List<dynamic>
  //     List<dynamic> allUsersData = dataResult as List<dynamic>;

  //     // Loop through each user data and process it
  //     for (var userData in allUsersData) {
  //       var userDataMap = userData["users"] as Map<String, dynamic>;
  //       ProfileSummaryModel profilemodel =
  //           ProfileSummaryModel.fromJson(userDataMap);
  //       profileSummaries.add(profilemodel);

  //       List<dynamic> educationData = userData["educations"] as List<dynamic>;
  //       List<Education> educationList = educationData.isEmpty
  //           ? [] // Empty list if no education records
  //           : educationData.map((item) => Education.fromMap(item)).toList();
  //       educationLists.add(educationList);

  //       List<dynamic> experienceData = userData["experiences"] as List<dynamic>;
  //       List<Experience> experienceList = experienceData.isEmpty
  //           ? [] // Empty list if no experience records
  //           : experienceData.map((item) => Experience.fromMap(item)).toList();
  //       experienceLists.add(experienceList);

  //       profilemodel.isVisible = true;
  //       educationmodel.isVisible = true;
  //       expmodel.isVisible = true;
  //     }

  //     setState(() {});
  //   }
  // }

  void _loadMoreData() async {
    try {
      String apiUrl =
          'http://${GlobalConstants.API_Host}/users/v1/allUserDeails';

      var response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);

      if (response.statusCode == 200) {
        var dataResult = Utils.parseResponse(response).resultData;
        List<dynamic> allUsersData = dataResult as List<dynamic>;

        for (var userData in allUsersData) {
          var userDataMap = userData["users"] as Map<String, dynamic>;
          UserDetail profilemodel = UserDetail.fromJson(userDataMap);

          if (!profileSummaries.contains(profilemodel) &&
              (_searchController.text.isEmpty ||
                  (profilemodel.firstName!
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()) ||
                      profilemodel.lastName!
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase())))) {
            profileSummaries.add(profilemodel);
            filteredProfiles.add(profilemodel);
          }
        }

        _currentPage++;
        setState(() {});
      }
    } catch (e) {
      print('Error loading more data: $e');
    }
  }

  // bindProfileSummary() {
  // }

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_scrollListener);
    _searchController.addListener(_onSearchChanged);

    // Initialize filteredProfiles with the same data as profileSummaries
    // filteredProfiles = List.from(profileSummaries);

    // Load initial data on page load

    _loadMoreData();
  }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     _loadMoreData();
  //   }
  // }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      // Filter the profileSummaries based on the search query
      List<UserDetail> filteredProfileSummaries = profileSummaries
          .where((profile) =>
              (profile.firstName != null &&
                  profile.firstName!.toLowerCase().contains(query)) ||
              (profile.lastName != null &&
                  profile.lastName!.toLowerCase().contains(query)) ||
              (profile.userLocality != null &&
                  profile.userLocality!.toLowerCase().contains(query)) ||
              (profile.userLocation != null &&
                  profile.userLocation!.toLowerCase().contains(query)) ||
              (profile.jobTitleRecent != null &&
                  profile.jobTitleRecent!.toLowerCase().contains(query)) ||
              (profile.companyNameRecent != null &&
                  profile.companyNameRecent!.toLowerCase().contains(query)) ||
              (profile.level != null &&
                  profile.level!.toLowerCase().contains(query)) ||
              (profile.languages != null &&
                  profile.languages!.any(
                      (language) => language.toLowerCase().contains(query))) ||
              (profile.skills != null &&
                  profile.skills!
                      .any((skill) => skill.toLowerCase().contains(query))))
          .toList();

      // Update the searchResults list with filteredProfileSummaries
      searchResults = filteredProfileSummaries.toList();
    });
  }

  void _showCallDialog(UserDetail profilemodel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // Make the dialog transparent
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Add a 15 radius to the dialog
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.phone,
                size: 40,
                color: Colors
                    .blue, // You can customize the color of the phone icon
              ),
              const SizedBox(height: 10),
              if (profilemodel.mobile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      15.0), // Add a 15 radius to the button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Make the button background transparent
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      _makePhoneCall(profilemodel.mobile.toString());
                    },
                    child: const Text("Primary Number"),
                  ),
                ),
              if (profilemodel.alternateNo != null &&
                  profilemodel.alternateNo != "0")
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      15.0), // Add a 15 radius to the button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Make the button background transparent
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      _makePhoneCall(profilemodel.alternateNo.toString());
                    },
                    child: const Text("Secondary Number"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showWhatsAppDialog(UserDetail profilemodel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // Make the dialog transparent
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Add a 15 radius to the dialog
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/whatsapp.png", // Replace with your WhatsApp icon image path
                width: 40,
                height: 40,
                color: Colors.greenAccent.shade400,
              ),
              const SizedBox(height: 10),
              if (profilemodel.mobile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Make the button background transparent
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      _openWhatsApp(
                          profilemodel.mobile.toString(),
                          profilemodel.firstName ?? "",
                          profilemodel.lastName ?? "");
                    },
                    child: const Text("Primary Number"),
                  ),
                ),
              if (profilemodel.alternateNo != null &&
                  profilemodel.alternateNo != 0)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .transparent, // Make the button background transparent
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      _openWhatsApp(
                          profilemodel.alternateNo.toString(),
                          profilemodel.firstName ?? "",
                          profilemodel.lastName ?? "");
                    },
                    child: const Text("Secondary Number"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  //margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 45.h,
                  width: double.maxFinite,
                  child: TextField(
                    controller: _searchController,
                    enableInteractiveSelection:
                        false, // will disable paste operation
                    //focusNode: AlwaysDisabledFocusNode(),
                    /* onTap: () {
                              showSearch(
                                  context: context,
                                  delegate: DataSearch(
                                      onSelected: (String q) =>
                                          {searchText = q, searchAgain()}));
                            }, */
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.search_outlined),
                      filled: true,
                      contentPadding:
                          const EdgeInsets.only(left: 14.0, bottom: 5, top: 5),
                      fillColor: Constants.themeBgColorLight,
                      hintText: 'Search name,job role,company name...',
                      hintStyle: GoogleFonts.varela(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Constants.borderColor),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Constants.borderColor),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    style: GoogleFonts.varela(
                      color: const Color.fromARGB(255, 177, 14, 3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: _searchController.text.isEmpty
                  ? profileSummaries.length
                  : searchResults.length,
              itemBuilder: (context, index) {
                var profilemodel = _searchController.text.isEmpty
                    ? profileSummaries[index]
                    : searchResults[index];
                int age = calculateAge(profilemodel.dateOfBirth);

                final List<String> languagesToExclude = [
                  'English',
                  'Hindi',
                  'Marathi'
                ];
                // Begin the declaration of shouldDisplayLanguages variable
                List<String> filteredLanguages = [];

                if (profilemodel.languages != null &&
                    profilemodel.languages!.isNotEmpty) {
                  List<String> languagesList =
                      List<String>.from(profilemodel.languages!);

                  filteredLanguages = languagesList
                      .where(
                          (language) => !languagesToExclude.contains(language))
                      .toList();
                }
                final previousJoiningDate = profilemodel.joiningDatePrevious;
                final recentJoiningDate = profilemodel.joiningDateRecent;
                final previousLastWorkingDate =
                    profilemodel.lastWorkingDatePrevious;
                final recentLastWorkingDate =
                    profilemodel.lastWorkingDateRecent;

                DateTime? parsedRecentJoiningDate = recentJoiningDate;
                DateTime? parsedRecentLastWorkingDate = recentLastWorkingDate;

                String experienceText;

                if (profilemodel.experience == 'Fresher' &&
                    parsedRecentLastWorkingDate == null) {
                  // If the job title is "Fresher" and lastWorkingDate is null, set experienceText to "Fresher"
                  experienceText = 'Fresher';
                } else if (profilemodel.experience == 'Experienced' &&
                    parsedRecentLastWorkingDate == null) {
                  // If the job title is "Experienced" and lastWorkingDate is null, set experienceText to "Experienced"
                  experienceText = 'Experienced';
                } else if (parsedRecentLastWorkingDate != null) {
                  // Calculate total years and months of experience
                  final duration = parsedRecentLastWorkingDate
                      .difference(parsedRecentJoiningDate!);
                  final totalYears = duration.inDays ~/ 365;
                  final totalMonths = (duration.inDays % 365) ~/ 30;

                  if (totalYears > 0 && totalMonths > 0) {
                    experienceText = "$totalYears yrs $totalMonths mos";
                  } else if (totalYears > 0) {
                    experienceText = "$totalYears yrs";
                  } else {
                    experienceText = "$totalMonths mos";
                  }
                } else {
                  // If lastWorkingDate is null, set experienceText to "Present"
                  experienceText = 'Present';
                }

                String formatSalary(String salary) {
                  // Remove any non-numeric characters from the salary string
                  String cleanedSalary = salary
                      .replaceAll(',', '')
                      .replaceAll(' ', '')
                      .replaceAll('PerMonth', '');

                  double salaryValue = double.tryParse(cleanedSalary) ?? 0.0;
                  String formattedSalary;

                  if (salaryValue >= 100000) {
                    // If salary is in lakhs or more
                    double lakhs = salaryValue / 100000;
                    formattedSalary = '${lakhs.toStringAsFixed(0)} Lacs PA';
                  } else if (salaryValue >= 1000) {
                    // If salary is in thousands or more
                    double thousands = salaryValue / 1000;
                    formattedSalary =
                        '${thousands.toStringAsFixed(0)}k Per Month';
                  } else {
                    formattedSalary = profilemodel
                        .salaryRecent!; // Display 'N/A' if salary is less than 1000
                  }

                  return formattedSalary;
                }

                String capitalizeFirstLetter(String? text) {
                  if (text == null || text.isEmpty) {
                    return '';
                  }
                  return text[0].toUpperCase() + text.substring(1);
                }

                String getFormattedName(String? firstName, String? lastName) {
                  String capitalizeFirstLetter(String? text) {
                    if (text == null || text.isEmpty) {
                      return '';
                    }
                    return text[0].toUpperCase() +
                        text.substring(1).toLowerCase();
                  }

                  if (firstName == null && lastName == null) {
                    return '';
                  } else if (firstName == null) {
                    return capitalizeFirstLetter(lastName!);
                  } else if (lastName == null) {
                    return capitalizeFirstLetter(firstName);
                  } else {
                    List<String> firstNames = firstName.split(' ');
                    List<String> lastNames = lastName.split(' ');

                    // Capitalize the first letter of each word in the first and last names
                    for (int i = 0; i < firstNames.length; i++) {
                      firstNames[i] = capitalizeFirstLetter(firstNames[i]);
                    }
                    for (int i = 0; i < lastNames.length; i++) {
                      lastNames[i] = capitalizeFirstLetter(lastNames[i]);
                    }

                    if (firstNames.isNotEmpty && lastNames.isNotEmpty) {
                      return '${firstNames.join(' ')} ${lastNames.join(' ')}';
                    } else if (firstNames.isNotEmpty) {
                      return firstNames.first;
                    } else if (lastNames.isNotEmpty) {
                      return lastNames.first;
                    } else {
                      return '';
                    }
                  }
                }

                DateTime? parseDateTime(String? dateTimeString) {
                  if (dateTimeString == null) return null;
                  return DateTime.tryParse(dateTimeString);
                }

                String formatDate(DateTime? date) {
                  if (date != null) {
                    return DateFormat('dd MMM yyyy')
                        .format(date); // Adjusted date format
                  } else {
                    return ""; // Empty string as an example, replace it with your desired default value.
                  }
                }

                String getFormattedAge(int age) {
                  return age > 0
                      ? '($age)'
                      : ''; // Returns empty string if age is 0 or not available
                }

                return Dismissible(
                  key: Key(profilemodel.id.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      // Right swipe (open WhatsApp)
                      _showWhatsAppDialog(profilemodel);
                    } else if (direction == DismissDirection.startToEnd) {
                      // Left swipe (make phone call)
                      _showCallDialog(profilemodel);
                    }

                    setState(() {
                      profileSummaries.remove(profilemodel);
                      filteredProfiles.remove(profilemodel);
                      searchResults.remove(profilemodel);
                    });
                  },
                  background: Container(
                    color: Colors.blue, // Left swipe background color
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Icon(
                      Icons.phone_android,
                      size: 110,
                      color: Constants.themeBgColor,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green, // Right swipe background color
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: Image.asset(
                      "assets/images/whatsapp.png",
                      height: 110.h,
                      color: Colors.greenAccent[400],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: CircleAvatar(
                                      backgroundImage: profilemodel
                                                  .profilePic !=
                                              null
                                          ? NetworkImage(
                                              profilemodel.profilePic!)
                                          : const NetworkImage(
                                              "https://cdn-icons-png.flaticon.com/512/236/236831.png"),
                                      radius: 22.0,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getFormattedName(
                                                    profilemodel.firstName,
                                                    profilemodel.lastName) +
                                                getFormattedAge(age),
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (profilemodel.active == true)
                                            const Icon(
                                              Icons.circle,
                                              size: 20,
                                              color: Colors.green,
                                            )
                                          else
                                            const SizedBox(
                                              width:
                                                  24, // Width of the blank space when the user is not active
                                            ),
                                          if (profilemodel.availabilityRecent ==
                                                  "Imediate" ||
                                              profilemodel.availabilityRecent ==
                                                  "15 Days or less")
                                            Image.asset(
                                              "assets/images/log.png",
                                              height: 23.h,
                                            ),
                                        ],
                                      ),
                                      // const SizedBox(height: 2),
                                      const SizedBox(height: 2),
                                      // Now, use experienceText in your Text widget
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.work_outline_outlined,
                                            size: 14,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                              width:
                                                  2), // Adjust the space between the icon and text
                                          Text(
                                            experienceText,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(width: 6),

                                          if (profilemodel.jobTitleRecent !=
                                              null)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                  Icons.money,
                                                  size: 14,
                                                  color: Colors.black,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  formatSalary(profilemodel
                                                          .salaryRecent ??
                                                      'N/A'), // Format the salary using the function
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          const SizedBox(width: 6),
                                          if (profilemodel.userLocality != null)
                                            Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.pin_drop,
                                                    size: 14,
                                                    color: Colors.black,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    '${capitalizeFirstLetter(profilemodel.userLocality)}, ${capitalizeFirstLetter(profilemodel.userLocation)}',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          // Adjust the space between the icon and text
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8.0),
                              if (profilemodel.jobTitleRecent != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topCenter,
                                      child: Icon(
                                        Icons.work_outline_outlined,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            4), // Adjust the space between the icon and text
                                    const Text(
                                      "Current : ",
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${profilemodel.jobTitleRecent ?? 'N/A'} at ${profilemodel.companyNameRecent ?? 'N/A'}',
                                            style: const TextStyle(
                                              fontSize: 11.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 8.0),
                              if (profilemodel.jobTitlePrevious != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topCenter,
                                      child: Icon(
                                        Icons.work_outline_outlined,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            4), // Adjust the space between the icon and text
                                    const Text(
                                      "Previous: ",
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${profilemodel.jobTitlePrevious} at ${profilemodel.companyNamePrevious}',
                                            style: const TextStyle(
                                              fontSize: 11.0,
                                            ),
                                          ),
                                          // Display any additional information related to the previous experience...
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 6.0),
                              if (profilemodel.education != null ||
                                  profilemodel.level != null)
                                if (profilemodel.level != null &&
                                    (profilemodel.level != null ||
                                        profilemodel.education != null))
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Align(
                                        alignment: Alignment.topCenter,
                                        child: Icon(
                                          Icons.school,
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              4), // Adjust the space between the icon and text
                                      // Text(
                                      //   'Education: ',
                                      //   style: TextStyle(
                                      //     fontSize: 13.0,
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      // ),
                                      Text(
                                        '${profilemodel.level ?? profilemodel.education}' +
                                            (profilemodel.university != null
                                                ? ' | ${profilemodel.university}'
                                                : '') +
                                            (profilemodel.passingYear != null
                                                ? ' | ${profilemodel.passingYear}'
                                                : ''),
                                        style: const TextStyle(
                                          fontSize: 11.0,
                                        ),
                                      ),
                                    ],
                                  ),

                              const SizedBox(height: 8.0),
                              if (filteredLanguages.isNotEmpty &&
                                  !languagesToExclude.any((language) =>
                                      filteredLanguages.contains(language)) &&
                                  profilemodel.languages!.isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.language,
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                        width:
                                            4), // Adjust the space between the icon and the text
                                    Flexible(
                                      child: Text(
                                        filteredLanguages.join(", "),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 8.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.pin_drop,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                      width:
                                          4), // Adjust the space between the icon and the text
                                  Flexible(
                                    child: Text(
                                      "Pre. Location : Mumbai, Pune, Delhi",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8.0),
                              if (profilemodel.skills!.isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topCenter,
                                      child: Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            4), // Adjust the space between the icon and text
                                    // Text(
                                    //   'Skills: ',
                                    //   style: TextStyle(
                                    //     fontSize: 13.0,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    Flexible(
                                      child: Wrap(
                                        spacing: 4,
                                        runSpacing: 4,
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  (profilemodel.skills!.length <
                                                          4
                                                      ? profilemodel
                                                          .skills!.length
                                                      : 3);
                                              i++)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                profilemodel.skills![i],
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            ),
                                          if (profilemodel.skills!.length > 3)
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 2),
                                              child: Text(
                                                '+${profilemodel.skills!.length - 3}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              // SizedBox(height: .h),
                              const Divider(
                                thickness: 1,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (profilemodel.active == false &&
                                      profilemodel.lastActive != null)
                                    Text(
                                      'Last Active On: ${formatDate(parseDateTime(profilemodel.lastActive!))}',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  const Icon(
                                    Icons.verified_user,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Profile Updated On: ${profilemodel.updatedDate != null && profilemodel.updatedDate!.isNotEmpty ? formatDate(parseDateTime(profilemodel.updatedDate)) : formatDate(parseDateTime(profilemodel.createdOn))}",
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (profilemodel.cvLink != null &&
                          profilemodel.cvLink!.isNotEmpty)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, top: 15),
                            child: Image.asset(
                              "assets/images/cv.png",
                              height: 20.h,
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to calculate age based on the date of birth
  int calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 0;
    DateTime birthDate = DateTime.parse(dateOfBirth);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // void _makePhoneCall(ProfileSummaryModel profilemodel) async {
  //   final mobile = profilemodel.mobile;
  //   final alternateNo = profilemodel.alternate_no;

  //   if (mobile != null) {
  //     await _launchPhoneCall("+91$mobile");
  //     setState(() {
  //       profilemodel.isVisible =
  //           true; // Show the card after making the phone call
  //     });
  //   } else if (alternateNo != null) {
  //     await _launchPhoneCall("+91$alternateNo");
  //     setState(() {
  //       profilemodel.isVisible =
  //           true; // Show the card after making the phone call
  //     });
  //   } else {
  //     throw "No phone number available";
  //   }
  // }
  void _makePhoneCall(String phoneNumber) async {
    final phoneUrl = "tel:$phoneNumber";
    if (await urlLauncher.canLaunchUrl(Uri.parse(phoneUrl))) {
      await urlLauncher.launchUrl(Uri.parse(phoneUrl));
    } else {
      throw "Could not make the phone call";
    }
    setState(() {
      profilemodel.isVisible = true; // Show the card after opening WhatsApp
    });
  }

  // void _openWhatsApp(ProfileSummaryModel profilemodel) async {
  //   final mobile = profilemodel.mobile;
  //   final alternateNo = profilemodel.alternate_no;

  //   if (mobile != null) {
  //     await _launchWhatsApp("+91$mobile");
  //     setState(() {
  //       profilemodel.isVisible = true; // Show the card after opening WhatsApp
  //     });
  //   } else if (alternateNo != null) {
  //     await _launchWhatsApp("+91$alternateNo");
  // setState(() {
  //   profilemodel.isVisible = true; // Show the card after opening WhatsApp
  // });
  //   } else {
  //     throw "No phone number available";
  //   }
  // }

  // void _openWhatsApp(int phoneNumber) async {
  //   final mobile = phoneNumber.toString();
  //   final whatsappUrl = "whatsapp://send?phone=+91$mobile";

  //   if (await urlLauncher.canLaunchUrl(Uri.parse(whatsappUrl))) {
  //     await urlLauncher.launchUrl(Uri.parse(whatsappUrl));
  //     setState(() {
  //       profilemodel.isVisible = true; // Show the card after opening WhatsApp
  //     });
  //   } else {
  //     throw "Could not open WhatsApp";
  //   }
  //   setState(() {
  //     profilemodel.isVisible = true; // Show the card after opening WhatsApp
  //   });
  // }

  void _openWhatsApp(String mobile, String firstName, String lastName) async {
    final defaultMsg =
        "Hi, $firstName $lastName"; // Construct the default message
    final whatsappUrl =
        "whatsapp://send?phone=+91$mobile&text=${Uri.encodeQueryComponent(defaultMsg)}";

    if (await urlLauncher.canLaunchUrl(Uri.parse(whatsappUrl))) {
      await urlLauncher.launchUrl(Uri.parse(whatsappUrl));
      setState(() {
        profilemodel.isVisible = true; // Show the card after opening WhatsApp
      });
    } else {
      throw "Could not open WhatsApp";
    }
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final phoneUrl = "tel:$phoneNumber";
    if (await urlLauncher.canLaunchUrl(Uri.parse(phoneUrl))) {
      await urlLauncher.launchUrl(Uri.parse(phoneUrl));
    } else {
      throw "Could not make the phone call";
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final whatsappUrl = "whatsapp://send?phone=$phoneNumber";
    if (await urlLauncher.canLaunchUrl(Uri.parse(whatsappUrl))) {
      await urlLauncher.launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw "Could not open WhatsApp";
    }
  }
}
