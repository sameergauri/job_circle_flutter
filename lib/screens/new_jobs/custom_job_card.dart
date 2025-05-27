import 'package:flutter/material.dart';
import 'package:job_circle/models/job_home_page_model.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart'; // Assuming customTextForWeather is here

class CustomJobCard extends StatelessWidget {
  final JobContent job;
  final List<String> skills;

  const CustomJobCard({
    super.key,
    required this.job,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Constants.lightdull,
              child: Image.network(
                "https://cdn-icons-png.flaticon.com/128/14644/14644423.png",
                height: 25,
                width: 25,
                fit: BoxFit.cover,
              ),
            ),
            title: customTextForWeather(
              title: job.jobHeadline ?? '',
              fontWeight: FontWeight.w700,
              maxlines: 2,
              overflow: TextOverflow.ellipsis,
              fontSize: job.jobHeadline!.length < 30 ? 16 : 14,
            ),
            // subtitle: customTextForWeather(title: job.process ?? ''),
            trailing: InkWell(
              onTap: () {
                // Handle favorite toggle logic here
                // For example, you can call a method to update the job's favorite status
              },
              child: Icon(
                job.isFavorite == true
                    ? Icons.bookmark_outlined
                    : Icons.bookmark_border_outlined,
                color: Constants.subtitleclr,
              ),
            ),
          ),
          const SizedBox(height: 5),
          _buildInfoRow(
              Icons.work_outline_outlined, job.experienceRequired.toString()),
          const SizedBox(height: 5),
          _buildInfoRow(
              Icons.currency_rupee,
              job.salaryRange!.contains('- 0')
                  ? job.salaryRange!.replaceFirst(RegExp(r'\s*-\s*0'), '')
                  : job.salaryRange.toString()),
          const SizedBox(height: 5),
          _buildInfoRow(Icons.location_on_outlined, job.location ?? ''),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.start,
            children: [
              const customTextForWeather(title: "Skills : "),
              ...skills.take(10).toList().asMap().entries.map((entry) {
                final skillIndex = entry.key;
                final value = entry.value;
                final isLast = skillIndex == skills.take(10).length - 1;
                return customTextForWeather(
                  title: isLast
                      ? value + (skills.length > 10 ? '...' : '.')
                      : '$value, ',
                  overflow: TextOverflow.ellipsis,
                  fontStyle: FontStyle.italic,
                  softwrap: true,
                  color: Constants.subtitleclr,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Constants.subtitleclr,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: customTextForWeather(
            title: text,
            fontSize: 12,
            color: Constants.subtitleclr,
          ),
        ),
      ],
    );
  }
}
