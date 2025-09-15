import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/models/e_learning/univerrsity_course_model.dart';

// Provider to fetch courses from API
final courseProvider = FutureProvider<List<UniversityCourse>>((ref) async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);

    // Create a list with exactly 2 MBA and 2 MCA courses
    return [
      //TODO:: DYPATIL
      UniversityCourse(
          universityName: 'D Y Patil University',
          courseName: 'MBA',
          duration: '2 years',
          fees: '₹1,89,400',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Photos%2FDY%2520Patil%2520college%2520image.jpg&w=320&q=75',
          logoUrl: 'https://cdn-websites.talentedge.com/DYPATIL/www/wwwroot/dypatiledu.com/assets/img/staticpage/dyp-online-logo.png',
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A++' Grade",
            'NIRF Ranking'
          ]),
      UniversityCourse(
          universityName: 'D Y Patil University',
          courseName: 'BBA',
          duration: '3 years',
          fees: '₹1,35,000',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Photos%2FDY%2520Patil%2520college%2520image.jpg&w=320&q=75',
          logoUrl: 'https://cdn-websites.talentedge.com/DYPATIL/www/wwwroot/dypatiledu.com/assets/img/staticpage/dyp-online-logo.png',
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A++' Grade",
            'NIRF Ranking'
          ]),
      // TODO:: NMIS
      UniversityCourse(
          universityName: 'NMIMS University',
          courseName: 'MBA',
          duration: '2 years',
          fees: '₹2,20,000',
          imageUrl:
              'https://www.nmims.edu/images/gallery/navimumbai-campus/1.jpg',
          logoUrl: "https://ncet.nmims.edu/images/logo-nmims.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            "NAAC 'A+' Grade",
                'QS Ranking',
            'NIRF Ranking',
            'IIRF Ranking',
            'AACSB Accredited',
            'AMBA Accredited',
            'NBA Accredited',
          ]),
      UniversityCourse(
          universityName: 'NMIMS University',
          courseName: 'BBA(Marketing & Finance)',
          duration: '3 years',
          fees: '₹1,50,000',
          imageUrl:
              'https://www.nmims.edu/images/gallery/navimumbai-campus/1.jpg',
          logoUrl: "https://ncet.nmims.edu/images/logo-nmims.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            "NAAC 'A+' Grade",
                'QS Ranking',
            'NIRF Ranking',
            'IIRF Ranking',
            'AACSB Accredited',
            'AMBA Accredited',
            'NBA Accredited',
          ]),
      UniversityCourse(
          universityName: 'NMIMS University',
          courseName: 'B.com',
          duration: '3 years',
          fees: '₹1,08,000',
          imageUrl:
              'https://www.nmims.edu/images/gallery/navimumbai-campus/1.jpg',
          logoUrl: "https://ncet.nmims.edu/images/logo-nmims.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            "NAAC 'A+' Grade",
                'QS Ranking',
            'NIRF Ranking',
            'IIRF Ranking',
            'AACSB Accredited',
            'AMBA Accredited',
            'NBA Accredited',
          ]),
      //TODO:: Manipal
      UniversityCourse(
          universityName: 'Manipal University',
          courseName: 'MBA',
          duration: '2 years',
          fees: '₹1,75,000',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Banners%2Fmanipal.webp&w=320&q=75',
          logoUrl:
              "https://cdn.apna.co/apna-learn/College%20Logos/Adj_manipal_university_online.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A+' Grade",
            'NIRF Ranking',
            'WES',
            'ICASC',
          ]),
      UniversityCourse(
          universityName: 'Manipal University',
          courseName: 'MCA',
          duration: '2 years',
          fees: '₹1,58,000',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Banners%2Fmanipal.webp&w=320&q=75',
          logoUrl:
              "https://cdn.apna.co/apna-learn/College%20Logos/Adj_manipal_university_online.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A+' Grade",
            'NIRF Ranking',
            'WES',
            'ICASC',
          ]),
      UniversityCourse(
          universityName: 'Manipal University',
          courseName: 'M.com',
          duration: '2 years',
          fees: '₹1,08,000',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Banners%2Fmanipal.webp&w=320&q=75',
          logoUrl:
              "https://cdn.apna.co/apna-learn/College%20Logos/Adj_manipal_university_online.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A+' Grade",
            'NIRF Ranking',
            'WES',
            'ICASC',
          ]),
      UniversityCourse(
          universityName: 'Manipal University',
          courseName: 'MA',
          duration: '2 years',
          fees: '₹80,000',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Banners%2Fmanipal.webp&w=320&q=75',
          logoUrl:
              "https://cdn.apna.co/apna-learn/College%20Logos/Adj_manipal_university_online.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A+' Grade",
            'NIRF Ranking',
            'WES',
            'ICASC',
          ]),
      UniversityCourse(
          universityName: 'Manipal University',
          courseName: 'BBA',
          duration: '3 years',
          fees: '₹1,35,000',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Banners%2Fmanipal.webp&w=320&q=75',
          logoUrl:
              "https://cdn.apna.co/apna-learn/College%20Logos/Adj_manipal_university_online.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A+' Grade",
            'NIRF Ranking',
            'WES',
            'ICASC',
          ]),
      UniversityCourse(
          universityName: 'Manipal University',
          courseName: 'BCA',
          duration: '3 years',
          fees: '₹1,35,000',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Banners%2Fmanipal.webp&w=320&q=75',
          logoUrl:
              "https://cdn.apna.co/apna-learn/College%20Logos/Adj_manipal_university_online.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A+' Grade",
            'NIRF Ranking',
            'WES',
            'ICASC',
          ]),
      UniversityCourse(
          universityName: 'Manipal University',
          courseName: 'B.com',
          duration: '3 years',
          fees: '₹99,000',
          imageUrl:
              'https://apna.co/_next/image?url=https%3A%2F%2Fcdn.apna.co%2Fapna-learn%2FCollege%2520Banners%2Fmanipal.webp&w=320&q=75',
          logoUrl:
              "https://cdn.apna.co/apna-learn/College%20Logos/Adj_manipal_university_online.png",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'AICTE Approved',
            "NAAC 'A+' Grade",
            'NIRF Ranking',
            'WES',
            'ICASC',
          ]),

      //TODO:: Amity
      UniversityCourse(
          universityName: 'Amity University',
          courseName: 'MBA',
          duration: '2 years',
          fees: '₹1,99,000',
          imageUrl:
              'https://lh3.googleusercontent.com/proxy/ZPRcB9mBDocvW8JPal1dN7cc81FMl8eLF9v4Z7Py-6DMjdlvpEsiB56Tayd1J52cPGo3f9xgIkEZsDG9SjoHktJCmMCatJBong1qfRrvRHoDKybcmHno-qyemoXrVtt9r_2bRNmH1PcF7xujJna0ssyd1VZi9ZcbX6XZVw=s680-w680-h510-rw',
          logoUrl:
              "https://tpc.googlesyndication.com/simgad/8221025694121490724?sqp=uqWu0g0ICNIBEJEDQFo&rs=AOga4qnDphypMTWgvqxDbv4Kmd0xyNaLWw",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'WES Recognition',
            'WASC Accreditation',
            'QAA Accreditation',
            'AICTE',
            'QS Ranking',
            "NAAC 'A+' Grade",
            'NIRF Ranking'
          ]),
      UniversityCourse(
          universityName: 'Amity University',
          courseName: 'MCA',
          duration: '2 years',
          fees: '₹1,70,000',
          imageUrl:
              'https://lh3.googleusercontent.com/proxy/ZPRcB9mBDocvW8JPal1dN7cc81FMl8eLF9v4Z7Py-6DMjdlvpEsiB56Tayd1J52cPGo3f9xgIkEZsDG9SjoHktJCmMCatJBong1qfRrvRHoDKybcmHno-qyemoXrVtt9r_2bRNmH1PcF7xujJna0ssyd1VZi9ZcbX6XZVw=s680-w680-h510-rw',
          logoUrl:
              "https://tpc.googlesyndication.com/simgad/8221025694121490724?sqp=uqWu0g0ICNIBEJEDQFo&rs=AOga4qnDphypMTWgvqxDbv4Kmd0xyNaLWw",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'WES Recognition',
            'WASC Accreditation',
            'QAA Accreditation',
            'AICTE',
            'QS Ranking',
            "NAAC 'A+' Grade",
            'NIRF Ranking'
          ]),
      UniversityCourse(
          universityName: 'Amity University',
          courseName: 'BBA',
          duration: '3 years',
          fees: '₹1,65,000',
          imageUrl:
              'https://lh3.googleusercontent.com/proxy/ZPRcB9mBDocvW8JPal1dN7cc81FMl8eLF9v4Z7Py-6DMjdlvpEsiB56Tayd1J52cPGo3f9xgIkEZsDG9SjoHktJCmMCatJBong1qfRrvRHoDKybcmHno-qyemoXrVtt9r_2bRNmH1PcF7xujJna0ssyd1VZi9ZcbX6XZVw=s680-w680-h510-rw',
          logoUrl:
              "https://tpc.googlesyndication.com/simgad/8221025694121490724?sqp=uqWu0g0ICNIBEJEDQFo&rs=AOga4qnDphypMTWgvqxDbv4Kmd0xyNaLWw",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'WES Recognition',
            'WASC Accreditation',
            'QAA Accreditation',
            'AICTE',
            'QS Ranking',
            "NAAC 'A+' Grade",
            'NIRF Ranking'
          ]),
      UniversityCourse(
          universityName: 'Amity University',
          courseName: 'BCA',
          duration: '3 years',
          fees: '₹1,50,000',
          imageUrl:
              'https://lh3.googleusercontent.com/proxy/ZPRcB9mBDocvW8JPal1dN7cc81FMl8eLF9v4Z7Py-6DMjdlvpEsiB56Tayd1J52cPGo3f9xgIkEZsDG9SjoHktJCmMCatJBong1qfRrvRHoDKybcmHno-qyemoXrVtt9r_2bRNmH1PcF7xujJna0ssyd1VZi9ZcbX6XZVw=s680-w680-h510-rw',
          logoUrl:
              "https://tpc.googlesyndication.com/simgad/8221025694121490724?sqp=uqWu0g0ICNIBEJEDQFo&rs=AOga4qnDphypMTWgvqxDbv4Kmd0xyNaLWw",
          detail_url: "https://amityonline.com/",
          ranking: [
            'UGC Approved',
            'WES Recognition',
            'WASC Accreditation',
            'QAA Accreditation',
            'AICTE',
            'QS Ranking',
            "NAAC 'A+' Grade",
            'NIRF Ranking'
          ]),
    ];
  } else {
    throw Exception('Failed to load courses');
  }
});

// StateProvider for the selected filter
final courseFilterProvider = StateProvider<String>((ref) => 'All');

// Provider for filtered courses
final filteredCoursesProvider = Provider<List<UniversityCourse>>((ref) {
  final coursesAsync = ref.watch(courseProvider);
  final filter = ref.watch(courseFilterProvider);

  return coursesAsync.when(
    data: (courses) {
      if (filter == 'All') return courses;
      return courses
          .where((course) =>
              course.courseName.toLowerCase() == filter.toLowerCase())
          .toList();
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});
