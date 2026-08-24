import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/business_page/business_home_page_model.dart';
import 'package:job_circle/src/provider/business_page/business_comapny_provider.dart';
import 'package:job_circle/src/screen/business_page/create_company/create_company_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';
// import create company page

class BusinessHomePage extends StatefulWidget {
  const BusinessHomePage({super.key});

  @override
  State<BusinessHomePage> createState() => _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessCompanyProvider>().loadMyCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        backgroundColor: colors.appbarColor,
        title: customText(
          title: 'My Companies',
          fontSize: 18,
          color: colors.headingColor,
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to Create Company Page (fresh, blank form)
              context.read<BusinessCompanyProvider>().resetForm();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreateCompanyPage(forNewJob: ForNewJob.OLD,)),
              ).then((_) {
                // Refresh after coming back
                context.read<BusinessCompanyProvider>().loadMyCompanies();
              });
            },
            icon: Icon(Icons.add_circle_outline, color: colors.darkBlue),
          ),
        ],
      ),
      body: Consumer<BusinessCompanyProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customText(
                    title: provider.errorMessage!,
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.loadMyCompanies();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.companies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  customText(
                    title: 'No company created yet',
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  customText(
                    title: 'Create your company page to start posting jobs',
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<BusinessCompanyProvider>().resetForm();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreateCompanyPage(forNewJob: ForNewJob.OLD)),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Company'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.darkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadMyCompanies(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.companies.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final company = provider.companies[index];
                return _CompanyCard(company: company);
              },
            ),
          );
        },
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final BusinessCompany company;

  const _CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BusinessCompanyProvider>();
    final colors = context.appColors;
    return InkWell(
      onTap: () {
        provider.initFormForEdit(company);
        NavigationService.push(CreateCompanyPage(forNewJob: ForNewJob.OLD));
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.bottomsheetbgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: company.logoUrl != null && company.logoUrl!.isNotEmpty
                    ? Image.network(
                        company.logoUrl!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _placeholderLogo(colors),
                      )
                    : _placeholderLogo(colors),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      title: company.companyName,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.headingColor,
                    ),
                    if (company.industryType != null) ...[
                      const SizedBox(height: 4),
                      customText(
                        title: company.industryType!,
                        fontSize: 12,
                        color: colors.subTitleColor,
                      ),
                    ],
                    if (company.designation != null) ...[
                      const SizedBox(height: 2),
                      customText(
                        title: company.designation!,
                        fontSize: 12,
                        color: colors.subTitleColor,
                      ),
                    ],
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: company.isApproved
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: customText(
                  title: company.isApproved ? 'Approved' : 'Pending',
                  fontSize: 11,
                  color: company.isApproved ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderLogo(dynamic colors) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.business, color: Colors.grey.shade500),
    );
  }
}
