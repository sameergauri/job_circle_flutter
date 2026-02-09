// screens/Billing/ui/payment_status_home_page.dart
// ignore_for_file: camel_case_types, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/referal_program/ppayment_status_model.dart';
import 'package:job_circle/src/provider/referal_program/paymet_status_provider.dart';
import 'package:job_circle/src/screen/referal_program/invoice_detail_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/referal_program/custom_invoice_card.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:job_circle/src/widgets/text_field/custom_text_fielld_for_all.dart';
import 'package:provider/provider.dart';

class PaymentStatusHomePage extends StatefulWidget {
  const PaymentStatusHomePage({super.key});

  @override
  State<PaymentStatusHomePage> createState() => _PaymentStatusHomePageState();
}

class _PaymentStatusHomePageState extends State<PaymentStatusHomePage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PaymentStatusProvider>(
        context,
        listen: false,
      );
      provider.fetchInvoices();
    });

    searchController.addListener(() {
      final provider = Provider.of<PaymentStatusProvider>(
        context,
        listen: false,
      );
      provider.filterInvoices(searchController.text);
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _showDateFilterBottomSheet(BuildContext context, AppColors colors) {
    final provider = Provider.of<PaymentStatusProvider>(context, listen: false);
    final state = provider.state;
    final selectedDate = state.selectedDate;

    // Get all available dates from all invoice types
    final availableDates = <String>{};

    if (state.paymentStatus != null) {
      final resultData = state.paymentStatus!.resultData;

      // Collect dates from all invoice types
      void addDatesFromList(List<InvoiceSent> items) {
        for (var item in items) {
          if (item.invoiceSubmitDate.isNotEmpty) {
            try {
              final date = DateFormat(
                'dd MMM yyyy',
              ).parse(item.invoiceSubmitDate);
              availableDates.add(DateFormat('MMM yyyy').format(date));
            } catch (e) {
              // Skip invalid date
            }
          }
        }
      }

      addDatesFromList(resultData.invoiceSent);
      addDatesFromList(resultData.paidData);
      addDatesFromList(resultData.validation);
      addDatesFromList(resultData.rejectData);
    }

    final sortedDates = List<String>.from(availableDates)
      ..sort((a, b) {
        final dateA = DateFormat('MMM yyyy').parse(a);
        final dateB = DateFormat('MMM yyyy').parse(b);
        return dateB.compareTo(dateA); // Descending: latest first
      });

    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.3),
      backgroundColor: Colors.transparent,
      elevation: 1,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: colors.bottomsheetbgColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Month",
                    style: GoogleFonts.merriweather(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Constants.darkBlue,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      provider.resetFilters();
                      NavigationService.pop();
                    },
                    child: Text(
                      "Reset",
                      style: GoogleFonts.merriweather(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    return InkWell(
                      onTap: () {
                        final parts = date.split(' ');
                        final month = DateFormat(
                          'MM',
                        ).format(DateFormat('MMM').parse(parts[0]));
                        final year = parts[1];
                        provider.filterByDate({'month': month, 'year': year});
                        NavigationService.pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? colors.bottomsheerCard1Color
                              : colors.bottomsheerCard2Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                          top: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date,
                              style: GoogleFonts.merriweather(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colors.headingColor,
                              ),
                            ),
                            if (selectedDate != null &&
                                date ==
                                    "${DateFormat('MMM').format(DateFormat('MM').parse(selectedDate['month']!))} ${selectedDate['year']}")
                              const CustomNetworkImage(
                                color: Constants.darkBlue,
                                imageUrl: CustomIconUrl.locicon,
                                defaultIcon: Icons.check,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
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
    final colors = context.appColors;
    final screenWidth = MediaQuery.of(context).size.width;
    final tabFontSize = (screenWidth * 0.03).clamp(10.0, 14.0);

    return Consumer<PaymentStatusProvider>(
      builder: (context, provider, child) {
        final state = provider.state;

        if (state.isLoading) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: Center(
              child: CircularProgressIndicator(color: Constants.darkBlue),
            ),
          );
        }

        if (state.error != null) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: Center(
              child: customText(
                title: 'Error: ${state.error}',
                color: colors.headingColor,
              ),
            ),
          );
        }

        if (state.paymentStatus == null ||
            (state.paymentStatus!.resultData.invoiceSent.isEmpty &&
                state.paymentStatus!.resultData.paidData.isEmpty &&
                state.paymentStatus!.resultData.validation.isEmpty)) {
          return Scaffold(
            backgroundColor: colors.bgColor,
            body: Center(
              child: customTextForWeather(
                title: "No data available",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.headingColor!,
              ),
            ),
          );
        }

        final tabData = state.tabData;

        // Dispose of the previous TabController if the number of tabs changes
        if (_tabController != null &&
            _tabController!.length != tabData.length) {
          _tabController!.dispose();
          _tabController = null;
        }

        // Initialize TabController with the number of non-empty lists
        _tabController ??= TabController(length: tabData.length, vsync: this);

        return Scaffold(
         
          backgroundColor: colors.bgColor,
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: colors.subtitleTextColor),
            backgroundColor: colors.appbarColor,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CustomTextFieldforAll(
                isSearch: true,
                controller: searchController,
                isGmail: true,
                hint: "Search by candidate name",
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    _showDateFilterBottomSheet(context, colors);
                  },
                  child: customTextForWeather(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                   color: colors.subtitleTextColor!,
                    title: state.selectedDate != null
                        ? "${DateFormat('MMM').format(DateFormat('MM').parse(state.selectedDate!['month']!))} ${state.selectedDate!['year']}"
                        : "Month",
                  ),
                ),
              ),
            ],
          ),
          body: tabData.isEmpty
              ? Center(
                  child: customTextForWeather(
                    title: "No data found",
                    fontSize: 16,
                    color: colors.headingColor!,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      tabs: tabData
                          .map(
                            (tab) => Tab(
                              text: tab['name'] == "Paid Data"
                                  ? "Paid (${(tab['data'] as List).length})"
                                  : "${tab['name']} (${(tab['data'] as List).length})",
                            ),
                          )
                          .toList(),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      labelColor: colors.atsTabTextColor,
                      unselectedLabelColor: Constants.subtitleclr,
                      indicatorColor: colors.orangeLine,
                      labelStyle: GoogleFonts.merriweather(
                        fontSize: tabFontSize,
                        fontWeight: FontWeight.w700,
                        color: colors.subtabTitleColor,
                      ),
                      unselectedLabelStyle: GoogleFonts.merriweather(
                        fontSize: tabFontSize,
                        fontWeight: FontWeight.normal,
                        color: colors.subtitleTextColor,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: tabData.map((tab) {
                          final data = tab['data'] as List<dynamic>;
                          final tabName = tab['name'] as String;

                          return _buildInvoiceList(data, tabName, colors);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildInvoiceList(
    List<dynamic> items,
    String tabName,
    AppColors colors,
  ) {
    return RefreshIndicator(
      color: Constants.darkBlue,
      onRefresh: () async {
        final provider = Provider.of<PaymentStatusProvider>(
          context,
          listen: false,
        );
        await provider.fetchInvoices();
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    NavigationService.push(
                      InvoiceDetail(
                        invoice: item,
                        invoiceTab: _getInvoiceTabFromName(tabName),
                      ),
                    );
                  },
                  child: CustomInvoiceCard(invoice: item),
                ),
                if (index != items.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Divider(thickness: 1, endIndent: 10),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  InvoiceTab _getInvoiceTabFromName(String tabName) {
    switch (tabName) {
      case 'Invoices Sent':
        return InvoiceTab.invoicesent;
      case 'Validation':
        return InvoiceTab.validation;
      case 'Paid Data':
        return InvoiceTab.paid;
      case 'Not Paid':
        return InvoiceTab.reject;
      default:
        return InvoiceTab.invoicesent;
    }
  }
}

// Helper widget for text with weather style
class customTextForWeather extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;

  const customTextForWeather({
    super.key,
    required this.title,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
