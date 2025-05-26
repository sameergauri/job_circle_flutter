import 'package:flutter/material.dart';
import 'package:job_circle/models/e_learning/univerrsity_course_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class UniversityCard extends StatelessWidget {
  final UniversityCourse course;

  const UniversityCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // University image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Stack(
              children: [
                Image.network(
                  course.imageUrl,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 150,
                      color: Colors.grey,
                    );
                  },
                ),
                // University logo overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                    color: Colors.white.withOpacity(0.8),
                    child: Image.network(
                      course.logoUrl,
                      width: 100,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // University name
                Row(
                  children: [
                    customTextForWeather(
                      title: course.universityName,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.darkBlack,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Course details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Course name
                    Row(
                      children: [
                        const Icon(
                          Icons.school,
                          size: 20,
                          color: Constants.subtitleclr,
                        ),
                        const SizedBox(width: 4),
                        customTextForWeather(
                          title: course.courseName,
                          fontSize: 14,
                        ),
                      ],
                    ),
                    // Duration
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: Constants.subtitleclr,
                        ),
                        const SizedBox(width: 4),
                        customTextForWeather(
                          title: course.duration,
                          fontSize: 14,
                        ),
                      ],
                    ),
                    // Fees
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          size: 20,
                          color: Constants.subtitleclr,
                        ),
                        const SizedBox(width: 4),
                        customTextForWeather(
                          title: course.fees,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Wrap(
                  children: [
                    ...course.ranking.map((e) => Container(
                          margin: const EdgeInsets.only(right: 4, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Constants.lightdull),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 6),
                          child: customTextForWeather(title: e),
                        ))
                  ],
                ),
                const SizedBox(height: 16),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.download,
                          size: 20,
                          color: Colors.blue,
                        ),
                        label: const customTextForWeather(
                            title: 'Brochure', color: Colors.blue),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const customTextForWeather(
                          title: 'Enroll',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
