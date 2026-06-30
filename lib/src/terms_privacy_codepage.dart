import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/custom_title/onboarding_title.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class TermsPrivacyCodePage extends StatefulWidget {
  const TermsPrivacyCodePage({super.key});

  @override
  State<TermsPrivacyCodePage> createState() => _TermsPrivacyCodePageState();
}

class _TermsPrivacyCodePageState extends State<TermsPrivacyCodePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        title: const OnboardingTitle(title: "Terms of service", fontSize: 16),
        elevation: 2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: colors.bgColor,
            child: TabBar(
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colors.orangeLine!, width: 3.0),
              ),

              indicatorWeight: 3.0,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelColor: colors.atsTabTextColor,
              unselectedLabelColor: Constants.subtitleclr,
              indicatorColor: colors.orangeLine,
              labelStyle: GoogleFonts.merriweather(
                color: colors.subtabTitleColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.merriweather(
                color: colors.subtitleTextColor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(text: "Terms & Condition"),
                Tab(text: "Privacy Plicy"),
                Tab(text: "Code of Conduct"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContentTab(
            termsAndConditionsText,
            "Terms and Conditions",
            colors,
          ),
          _buildContentTab(privacyPolicyText, "Privacy Policy", colors),
          _buildContentTab(codeOfConductText, "Code of Conduct", colors),
        ],
      ),
    );
  }

  Widget _buildContentTab(String fullText, String title, AppColors colors) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        // color: colors.bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildFormattedText(fullText, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildFormattedText(String text, AppColors colors) {
    final lines = text.split('\n');
    List<Widget> widgets = [];

    for (String rawLine in lines) {
      String line = rawLine.trim();

      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 12));
        continue;
      }

      // ==================== HEADINGS ====================
      if (_isHeading(line)) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: customText(
              title: line,
              textAlign: TextAlign.left, // Force Left Align
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
        );
        continue;
      }

      // ==================== BULLET POINTS ====================
      if (line.startsWith('•') ||
          line.startsWith('ü') ||
          line.startsWith('- ') ||
          line.startsWith('* ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title: "• ",
                  fontSize: 18,
                  color: colors.textPrimary,
                ),
                Expanded(
                  child: customText(
                    title: line.replaceAll(RegExp(r'^[•ü\-\*]\s*'), ''),
                    textAlign: TextAlign.left,
                    fontSize: 15.5,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // ==================== NUMBERED LIST ====================
      else if (RegExp(r'^\d+\.').hasMatch(line)) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title: "${line.split('.').first}. ",
                  color: colors.textPrimary,
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                ),
                Expanded(
                  child: customText(
                    title: line.replaceAll(RegExp(r'^\d+\.\s*'), ''),
                    textAlign: TextAlign.left,
                    fontSize: 15.5,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // ==================== NORMAL TEXT ====================
      else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: customText(
              title: line,
              textAlign: TextAlign.left,
              fontSize: 15.5,
              color: colors.textPrimary,
            ),
          ),
        );
      }
    }

    return Column(children: widgets);
  }

  bool _isHeading(String line) {
    if (line.length > 70) return false;
    if (line.endsWith(':')) return true;
    if (RegExp(r'^[A-Z][a-zA-Z\s&]+$').hasMatch(line))
      return true; // Capital starting
    if (line.toUpperCase() == line && line.length < 60) return true;
    return false;
  }
}

const String termsAndConditionsText = '''
Usage

The Job Circle Platform (including any mobile based applications, website and web applications) is provided by Job Circle. Through the Job Circle Platform any person with a verified account can view and apply for jobs (“User”) through the Job Circle Platform, access and participate in the services provided by Job Circle.

A User accessing the Job Circle Platform shall be bound by these Terms of Service, and all other rules, regulations and terms of use referred to herein or provided by Job Circle in relation to any services provided via the Job Circle Platform.

Job Circle shall be entitled to modify these Terms of Service, rules, regulations and terms of use referred to herein or provided by Job Circle in relation to any Job Circle Services, at any time, by posting the same on the Job Circle Platform. Use of the Job Circle Platform and Job Circle Services constitutes the User's acceptance of such modified Terms of Service, rules, regulations and terms of use referred to herein or provided by Job Circle in relation to any Job Circle Services, as may be amended from time to time. Job Circle may, at its sole discretion, also notify the User of any change or modification in these Terms of Service, rules, regulations and terms of use referred to herein or provided by Job Circle, by way of sending an email to the User's registered email address or posting notifications in the User accounts or through any other mode of communication. The User may then exercise the options provided in such an email or notification to indicate non-acceptance of the modified Terms of Service, rules, regulations and terms of use referred to herein or provided by Job Circle. If such options are not exercised by the User within the time frame prescribed in the email or notification, the User will be deemed to have accepted the modified Terms of Service, rules, regulations and terms of use referred to herein or provided by Job Circle.

Job Circle may, at its sole and absolute discretion:
Restrict, suspend, or terminate any User’s access to all or any part of the Job Circle platform or Services.
Change, suspend, or discontinue all or any part of the Job Circle platform or Services.
Reject, move, or remove any material that may be submitted by a User.
Move or remove any content that is available on the Job Circle platform or Services.
Deactivate or delete a User’s account and all related information and files on the account.
Establish general practices and limits concerning use of Job Circle platform or Services.
Assign its rights and liabilities to all User accounts hereunder to any entity (post such assignment intimation of such assignment shall be sent to all Users to their registered email ids).
In the event any User breaches, or Job Circle reasonably believes that such User has breached these Terms of Service, or has illegally or improperly used the Job Circle Platform or Job Circle Services, Job Circle may, at its sole and absolute discretion, and without any notice to the User, restrict, suspend or terminate such User's access to all or any part of the Job Circle Platform and Service, deactivate or delete the User's account and all related information on the account, delete any content posted by the User on Job Circle and further, take technical and legal steps as it deems necessary.
By accepting these Terms of Service Users are providing their consent to receiving communications such as announcements, administrative messages and advertisements from Job Circle or any of its partners, licensors or associates.
Participation
When accessing and interacting with the Job Circle Platform and Job Circle Services a User will be able to view and apply for jobs posted by Job Circle potential employee on behalf their respective client’s.
To view and apply for a job a User shall be required to provide information about the User’s education, qualifications, past experience and skills. While Job Circle does not tolerate or allow for discrimination on the basis of gender, certain jobs might be gender specific and might be available only to persons of a certain gender. The User understands and acknowledges that such stipulations as to gender specifications for a certain job are not mandated by Job Circle and that such stipulation is made by the clients.
By agreeing to these Terms of Service and while applying for a job through the Job Circle Platform, Users undertake that all information shared will at all times be accurate and not be misleading. The User understands and acknowledges that any incorrect information or misrepresentations made by the User will affect the efficacy of the Job Circle Platform and Job Circle Services and that Job Circle shall have the right to suspend the User’s account if it is found that the information shared by the User is false or misleading.
The job applications by the Users on the Job Circle Platform shall remain active only for a period of 30 days from the date of application to the job posts and upon the expiry of the said period of 30 days, such job applications shall be archived ("Archived Job Applications"). The potential employers shall not have access to the list of such Users or to the Archived Job Applications upon the expiry of 30 days. The Users, however, may re-apply to a job post (if still active) after the expiry of 30 days from the date such User made their first application to the same job post.
Users agree that they shall at all times be bound by and adhere to the Code of Conduct while accessing the Job Circle Platform and while using the Job Circle Services.
Eligibility
The Job Circle Platform is open only to persons above the age of 18 years.
The Job Circle Platform is open only to persons currently residing in India.
People who wish to participate must have a valid email address and/or mobile phone number.
Job Circle may on receipt of information bar a person from accessing their Job Circle account if such person is found to be in violation of any part of these Terms of Service or the Code of Conduct.
Only those Users who have successfully registered on the Job Circle Platform shall be eligible to Post view and/or apply for jobs via the Job Circle Platform.

User Conduct
Users agree to abide by these Terms of Service and all other rules, regulations and terms of use of the Job Circle Platform and Job Circle Services. In the event User does not abide by these Terms of Service and all other rules, regulations and terms of use, Job Circle may, at its sole and absolute discretion, take necessary remedial action, including but not limited to:
restricting, suspending, or terminating any User's access to all or any part of the Job Circle Platform and Job Circle Services;
deactivating or deleting a User's account and all related information and files on the account.
Users agree to provide true, accurate, current and complete information at the time of registration and at all other times (as required by Job Circle). Users further agree to update and keep updated their registration information and other information as may be required by Job Circle.
A User shall not register or operate more than one User account with Job Circle.
Users agree to ensure that they can receive all communication from Job Circle either by email, SMS, Whatsapp or any other mode of communication from Job Circle. Job Circle shall not be held liable if any communication sent to the User by Job Circle remains unread by the User.
Any password issued by Job Circle to a User may not be revealed to anyone else. Users may not use anyone else's password. Users are responsible for maintaining the confidentiality of their accounts and passwords. Users agree to immediately notify Job Circle of any unauthorized use of their passwords or accounts or any other breach of security.
Users agree to exit/log-out of their accounts at the end of each session. Job Circle shall not be responsible for any loss or damage that may result if the User fails to comply with these requirements.
Users agree not to use cheats, exploits, automation, software, bots, hacks or any unauthorized third-party software designed to modify or interfere with the Job Circle Services and/or Job Circle experience or assist in such activity.
Users agree not to copy, modify, rent, lease, loan, sell, assign, distribute, reverse engineer, grant a security interest in, or otherwise transfer any right to the technology or software underlying the Job Circle Platform or Job Circle’s Services.
Users agree that without Job Circle's express written consent, they shall not modify or cause to be modified any files or software that are part of Job Circle's Services or the Job Circle Platform.
Users agree not to disrupt, overburden, or aid or assist in the disruption or overburdening of (a) any computer or server used to offer or support the Job Circle Platform or Job Circle’s Services (each a "Server"); or (2) the enjoyment of Job Circle Services by any other User or person.
Users agree not to institute, assist or become involved in any type of attack, including without limitation to distribution of a virus, denial of service, or other attempts to disrupt Job Circle Services or any other person's use or enjoyment of Job Circle Services.
Users shall not attempt to gain unauthorised access to User accounts, Servers or networks connected to the Job Circle Platform or Job Circle Services by any means other than the User interface provided by Job Circle, including but not limited to, by circumventing or modifying, attempting to circumvent or modify, or encouraging or assisting any other person to circumvent or modify, any security, technology, device, or software that underlies or is part of the Job Circle Platform or Job Circle Services.
A User shall not publish any content that is patently false and untrue, and is written or published in any form, with the intent to mislead or harass a person, entity or agency for financial gain or to cause any injury to any person.
Without limiting the foregoing, Users agree not to use Job Circle for any of the following:
To engage in any obscene, offensive, indecent, racial, communal, anti-national, objectionable, defamatory or abusive action or communication;
To harass, stalk, threaten, or otherwise violate any legal rights of other individuals;
To publish, post, upload, e-mail, distribute, or disseminate (collectively, "Transmit") any inappropriate, profane, defamatory, infringing, obscene, indecent, or unlawful content;
To Transmit files that contain viruses, corrupted files, or any other similar software or programs that may damage or adversely affect the operation of another person's computer, Job Circle, any software, hardware, or telecommunications equipment;
To advertise, offer or sell any goods or services for any commercial purpose on Job Circle including but not limited to multi-level marketing for a third party, promoting business of a third party, selling financial products such as loans, insurance, promoting demat account openings, without the express written consent of Job Circle;
To download any file, recompile or disassemble or otherwise affect our products that you know or reasonably should know cannot be legally obtained in such manner;
To falsify or delete any author attributions, legal or other proper notices or proprietary designations or labels of the origin or the source of software or other material;
To restrict or inhibit any other User from using and enjoying any public area within our sites;
To collect or store personal information about other Users;
To collect or store information about potential candidates;
To mine information relating to potential candidates with the aim of creating a database of potential candidates whether or not such database is used or meant to be used by the User or any third party associated with the User or to whom such User makes such mined information available, for either a commercial purpose of for the User’s own use at a future date;
To interfere with or disrupt the Job Circle and/or the Job Circle Platform, Job Circle servers, or Job Circle networks;
To impersonate any person or entity, including, but not limited to, a representative of Job Circle, or falsely state or otherwise misrepresent User's affiliation with a person or entity;
To forge headers or manipulate identifiers or other data in order to disguise the origin of any content transmitted through Job Circle or to manipulate User's presence on the Job Circle Platform;
To take any action that imposes an unreasonably or disproportionately large load on Job Circle’s infrastructure;
To engage in any illegal activities.
To engage in any action that threatens the unity, integrity, defence, security or sovereignty of India, friendly relations with foreign States, or public order, or causes incitement to the commission of any cognisable offence or prevents investigation of any offence or is insulting other nations.
If a User chooses a username that, in Job Circle's considered opinion is obscene, indecent, abusive or that might subject Job Circle to public disparagement or scorn, or a name which is an official team/league/franchise names and/or name of any sporting personality, as the case may be, Job Circle reserves the right, without prior notice to the User, to restrict usage of such names, which in Job Circle’s opinion fall within any of the said categories and/or change such username and intimate the User or delete such username and posts from Job Circle, deny such User access to Job Circle, or any combination of these options.
Unauthorized access to the Job Circle Platform is a breach of these Terms of Service, and a violation of the law. Users agree not to access the Job Circle Platform by any means other than through the interface that is provided by Job Circle via the Job Circle Platform for use in accessing the Job Circle Platform. Users agree not to use any automated means, including, without limitation, agents, robots, scripts, or spiders, to access, monitor, or copy any part of the Job Circle Platform, Job Circle Services or any information available for access through the Job Circle Platform or Job Circle Services, except those automated means that Job Circle has approved in advance and in writing.
Use of the Job Circle Platform is subject to existing laws and legal processes. Nothing contained in these Terms of Service shall limit Job Circle's right to comply with governmental, court, and law-enforcement requests or requirements relating to Users' use of Job Circle.
Persons below the age of eighteen (18) years are not allowed to register with the Job Circle Platform. All persons interested in becoming Job Circle Users might be required by Job Circle to disclose their age at the time of getting access to the Job Circle Platform. If a person declares a false age, Job Circle shall not be held responsible and such person shall, in addition to forfeiting any and all rights over their Job Circle account, shall indemnify and hold Job Circle, its Directors, officers, employees, agents, affiliates harmless of any and all losses that may be suffered by Job Circle its Directors, officers, employees, agents, affiliates by virtue of such false declaration being made. In case the person making the false declaration is below the age of 18 such person’s legal guardians shall indemnify and hold Job Circle, its Directors, officers, employees, agents, affiliates harmless of any and all losses that may be suffered by Job Circle its Directors, officers, employees, agents, affiliates by virtue of such false declaration having been made by said person.
Job Circle may not be held responsible for any content contributed by Users on the Job Circle Platform.

Privacy Policy
All information collected from Users, such as registration (including but not limited to email addresses, mobile phone numbers, government identity documentation) and payment information, is subject to Job Circle's Privacy Policy which is available at Privacy Policy.
We do not share personal information of any individual with other companies/entities without obtaining permission. We may share all such information that we have in our possession in accordance with our Privacy Policy
Once the personal information has been shared with you, you shall, at all times, be responsible to secure such information.
You warrant and represent that you shall not disclose or transfer personal information shared by us to any sub-processors without ensuring that adequate and equivalent safeguards to the personal information.

You, hereby agree and acknowledge that you will use the information shared with you only for the purpose of availing the Services. You shall not use such information for any personal or other business purposes. In the event you are found to be misusing the information shared with you, we shall, at our sole discretion, delete your account with immediate effect and you will be blocked from using/ accessing Job Circle Platform in future

''';

const String privacyPolicyText = '''
Job Circle app is a commercial app by Job Circle. This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information for anyone using the app and website of JOB CIRCLE Platform and Services. By using Job Circle Platform, you consent to the terms of our privacy policy ("Privacy Policy") in addition to our Terms of Service. We encourage you to read this Privacy Policy regarding the collection, use, and disclosure of your information from time to time to keep yourself updated with the changes & updated that we make to this Privacy Policy.

Personal Identification Information
If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Identification Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.
The personal information you provide on Job Circle Platform when you fill out your profile is public, such as your name, location, gender, profile picture, education and professional info including where you are working.
1. Be associated with you on the internet
2. Show up when someone does a search on a search engine. We also use your Public Profile, to help connect you with friends and family which increases your and your friends' chances to find suitable job opportunities.
We may collect Personal Identification Information of users including the information that is available on the internet, such as from Facebook, LinkedIn, Twitter and Google, or publicly available information that we acquire from service providers. We collect this information to identify users for better communication, processing and personalization of the Services provided by Applozic.

Non-personal Identification Information
We may collect non-personal identification information about users whenever they interact with our site. Non-personal identification information may include the type of mobile phone and technical information about users, such as the operating system and the Internet service providers utilized including IP address and other similar information.

Usage and Technical Information
We collect the information about how you interact with our Service. This information may include your IP address, geographical location, browser type, referral source, length of visit, pages viewed and items clicked.

Information Collection
For a better experience, while using our Service, you are required to provide us with certain personally identifiable information for your Public Profile, including but not limited to:
1. Identity information, such as your first name, last name, gender, username and/or similar as may be verified by voter ID card, PAN or driving license;
2. Contact information, such as your mobile number, postal address, email address and telephone number;
3. Professional information, such as your education, work experience, skills, photo, city or area. Professional information helps you to get more from our Services, including helping employers find you. Please do not post or add personal data to your resume that you would not want to be publicly available.
4. Feedback and correspondence, such as information you provide when you respond to surveys, participate in market research activities, report a problem with Service, receive customer support or otherwise correspond with us;
5. Usage information, such as information about how you use the Service and interact with us; and
6. Marketing information, such as your preferences for receiving marketing communications and details about how you engage with them.
Job Circle Platform’s mission is to connect talent to job opportunities and employers to quality talent. We are committed to be transparent about the data we collect about you, how it is used and with whom it is shared.
When you use the services of our customers and partners, such as employers or prospective employers and applicant tracking systems, we share your Public Profile (e.g., your job title and name of the company where you work) with prospective employers to enable you to get job interviews.

Information we collect
Contacts List.
ü When you sync your contacts with our Services, we import and store the contacts list to our servers. You have the option to deny us the access to your contacts list.
ü We also receive personal data (including contact information) about you when others import or sync their contacts with our Services.
Location Information.
· When you give location permission, we access information that is derived from your GPS. We may use third-party cookies and similar technologies to collect some of this information.
Storage.
· When you opt-in for storage permission, we access your device storage like gallery photos.
Camera.
· Granting camera permission allows us to access the photo that you click to be displayed on your resume.
Microphone.
· Voice and audio information when you use audio features. How we use it

How we use it
Contacts List.
· We collect your contacts to help you keep growing your network by suggesting connections for you and your friends.
Location Information.
· To provide you with location-based services like finding jobs near you.
Storage.
· To allow you to select your profile picture from your existing photos in the gallery. A good resume photo helps you stand out among other candidates.
Camera.
· To allow you to click your profile picture. A good resume photo helps you stand out among other candidates.
Microphone.
· To allow you to send audio messages within the app.
Call.
· For enabling the Call HR feature of the app.
To effectively provide and introduce any new Services to you, we collect and use certain information, including, but not limited to, such as:
· We log your visits and use of our Services.
· We receive data from your devices and networks, including location data.
· We may further request and store additional information.
· To monitor usage or traffic patterns (including to track users' movements around the Services) and gather demographic information.
· To communicate directly with you, including by sending you information about new products and services.
· To deliver you a personalized experience. May come in the form of messages, delivering tailor-made ads based on your interest and browsing history.
To the extent permitted by the applicable law, we may record and monitor your communications with us to ensure compliance with our legal and regulatory obligations and our internal policies. This may include the recording of telephone conversations.

How do we protect your information?
We adopt appropriate data collection, storage and processing practices and security measures to protect against unauthorized access, alteration, disclosure or destruction of your personal information, username, password, transaction information and data stored on our app.

Sharing your personal information
We do not sell, trade, or rent users personal identification information to any third party. We may share generic aggregated demographic information not linked to any personal identification information regarding visitors and users with our business partners, trusted affiliates and advertisers for the purposes outlined above.
The app does use third-party services that may collect information used to identify you.
We do not disclose, transfer or share your personal information with others except with:
· Our affiliates and group companies to the extent required for our internal business and/or administrative purposes and/or general corporate operations and for provision of services aimed at helping you in your career enhancement;
· In the event posted jobs on Job Circle Platform on behalf of such companies;
· Candidates who have applied to the job posted by you on the Platform, if we determine that the requirements of the job post match with the resume of the candidate. By registering on the Platform and consenting to the terms of this Privacy Policy, you agree that we may contact you or share your contact details with the candidates for the purpose of the Services;
· Potential recruiters/ job posters if we determine that your resume matches a particular job description/ vacancy available with such recruiters. By registering on the Platform and consenting to the terms of this Privacy Policy, you agree that we may contact you or forward your resume to potential recruiters;
· Third parties including enforcement, regulatory and judicial authorities, if we determine that disclosure of your personal information is required to a) respond to court orders, or legal process, or to establish or exercise our legal rights or defend against legal claims; or b) investigate, prevent, or take action regarding illegal activities, suspected fraud, situations involving potential threats to the physical safety of any person, violations of our Terms of Service or as otherwise required by law;
· In the event of a merger, acquisition, financing, or sale of assets or any other situation involving the transfer of some or all of our business assets we may disclose personal information to those involved in the negotiation or transfer.
· Third party service providers and marketing partners that we engage to a) provide services over the Platform on our behalf; b) maintain the Platform and mailing lists; or c) communicate with you on our behalf about offers relating to its products and/or services. We will take reasonable steps to ensure that these third-party service providers are obligated to protect your personal information and are also subject to appropriate confidentiality / non-disclosure obligations.
You, hereby agree and acknowledge that you will use the information shared with you only for the purpose of the Services. You shall not use such information for any personal or other business purposes. In the event you are found to be misusing the information shared with you, we shall, at our sole discretion, delete your account with immediate effect and you will be blocked from using/ accessing Job Circle Platform in future.

Log Data
Whenever you use our Service, including our sites, app and platform technology, such as when you view or click on content (e.g., learning video) or perform a search, install or update one of our mobile apps, post messages or apply for jobs and in a case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as log-ins, cookies, your device Internet Protocol ("IP") address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics to identify you and log your use.

Cookies
Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.
This Service does not use these "cookies" explicitly. However, the app may use third party code and libraries that use "cookies" to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.

Service Providers
We may employ third-party companies and individuals due to the following reasons:
To facilitate our Service; To provide the Service on our behalf; To perform Service-related services; or To assist us in analyzing how our Service is used. We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.

One-to-one messages
JOB CIRCLE has access to the one-to-one messages of users of the app and we review these messages periodically for moderation of trust and safety related concerns. However, JOB CIRCLE never shares this data with any third-party.

Security
We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.

Links to Other Sites
This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.

Children's Privacy
These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.

No Impersonation or False Information to be Provided
You have to use your actual name on the Platform, you are required to input your correct phone number to use our Services. You will be getting a job based on your JOB CIRCLE account. You will not falsely represent yourself as another person or representative of another person to use our Services. You will not lie about your details, for any reason.

Trust and Safety
JOB CIRCLE takes the trust and safety of all its users seriously. We do not allow content that promotes abuse, fraud, MLM/network marketing, job openings that charge fees, suicide, self-harm, or is intended to shock or disgust users. Strict action is taken against such content and with people posting such messages/content in the group.
To ensure the best possible experience for all the users of the app, we have established some basic guidelines called the Community Guidelines. The Community Guidelines gets updated periodically. You will be notified when this happens.

Disclaimer
Job Circle does not hold any responsibility for any incident, fraud, cheat or crime that may happen to any users. We advise you to check and verify information of other users before proceeding with any transactions or interaction among users.

Changes to This Privacy Policy
We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. These changes are effective immediately after they are posted on this page.

Contact Us
If you have any questions or suggestions about our Privacy Policy, do not hesitate to connect us at rahul@Jobcircle.co.in

''';

const String codeOfConductText = '''
This Code of Conduct aims to ensure that the Job Circle Platform and Job Circle Services are free of inappropriate and unwanted content or behavior. This Code of Conduct, which we continue to develop, provides guidance and rules for the use of the Job Circle Platform and Job Circle Services.
These reports, along with our automated defenses, help us identify and prevent abuse and misbehavior. Please use the reporting tools responsibly and only for their intended purposes and not for unnecessarily harassing other users. A violation of this Code of Conduct may result in us taking action, including but not limited to suspending your access to the Job Circle Platform and Job Circle Services and where applicable cases reporting illegal activities to the concerned authorities. Depending on the severity of the violation and a member's behavior or account history, we may block your account permanently.

You agree that you will:
Provide accurate information to us and keep it updated
Use the Services in a professional manner
All information you provide will be accurate

You agree that you will not:
Create a fake profile on JOB CIRCLE, misrepresent your identity, impersonate anyone, create a Member profile for anyone other than yourself (a real person), or use or attempt to use another's account
Use any information which may be considered misleading or deceptive
Communicate with any person using the Job Circle Platform or Job Circle Services in a manner which may be considered offensive or inappropriate
Directly or indirectly scrape the Services or otherwise copy profiles and other data from the Services
Try to circumvent any access controls or use limits of the Service (such as caps on keyword searches or profile views)
Copy, use, disclose or distribute any information obtained from the Services, whether directly or through third parties (such as search engines), without the consent of JOB CIRCLE
Breach your confidentiality obligations by disclosing information you do not have the consent to disclose
Post anything that contains software viruses, worms, or any other harmful code
Reverse engineer, decompile, disassemble, decipher or otherwise attempt to derive the source code for the Services or any related technology that is not open source
Imply or state that you are affiliated with or endorsed by JOB CIRCLE without our express consent (e.g., representing yourself as an accredited JOB CIRCLE trainer)
Monetize in any manner Services or related data or access to the same, without JOB CIRCLE's consent
Deep-link to our Services for any purpose other than to promote your profile or a Group on our Services, without JOB CIRCLE's consent
Use bots or other automated methods to access the Services, add or download contacts, send or redirect messages
Monitor the Services' availability, performance or functionality for any competitive purpose
Engage in "framing," "mirroring," or otherwise simulating the appearance or function of the Services
Overlay or otherwise modify the Services or their appearance (such as by inserting elements into the Services or removing, covering, or obscuring an advertisement included on the Services)
Interfere with the operation of, or place an unreasonable load on, the Services (e.g., spam, denial of service attack, viruses, gaming algorithms)
Violate the Professional Community Policies or any additional terms concerning a specific Service that are provided when you sign up for or start using such Service, where applicable
Charge any fee for providing recruitment services
Participate in any harassment or send other unwelcome communications to any person (e.g., romantic advances, sexually explicit content, junk mail, spam, chain letters, phishing schemes) or fraud
Share graphic, obscene, or pornographic content
Discriminate on the basis of age, race, caste, sex, gender, political affiliations, geography, or indulge in any practices that may be considered to be discriminatory in any manner or form
Propagate or endorse or advocate hate speech, hate groups, terrorists, or those who engage in violent crimes


''';
