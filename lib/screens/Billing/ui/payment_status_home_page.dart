// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/components/customTextFieldForAll.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/Billing/model/payment_status_model.dart';
import 'package:job_circle/screens/Billing/service/payment_status_service.dart';
import 'package:job_circle/screens/Billing/ui/invoice_detail.dart';
import 'package:job_circle/screens/Billing/widget/custom_invoice_card.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

// Riverpod Provider for invoice data
final invoiceProvider = FutureProvider<PaymentStatusModel>((ref) async {
  final invoiceService = InvoiceService();
  return await invoiceService.fetchListOfInvoice();
});

// State provider for selected date filter
final dateFilterProvider = StateProvider<Map<String, String>?>((ref) => null);

class PaymentStatusHomePage extends ConsumerStatefulWidget {
  const PaymentStatusHomePage({super.key});

  @override
  ConsumerState<PaymentStatusHomePage> createState() =>
      _PaymentStatusHomePageState();
}

class _PaymentStatusHomePageState extends ConsumerState<PaymentStatusHomePage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();

    searchController.dispose();
    super.dispose();
  }

  // Filter InvoiceSent list
  List<InvoiceSent> _filterInvoices(List<InvoiceSent> invoices, String query) {
    if (query.isEmpty) return invoices;
    return invoices.where((invoice) {
      final orgNameMatch = invoice.orgizationName.toLowerCase().contains(query);
      final candidateMatch = invoice.candidates
          .any((candidate) => candidate.name.toLowerCase().contains(query));
      return orgNameMatch || candidateMatch;
    }).toList();
  }

  void _showDateFilterBottomSheet(BuildContext context) {
    final invoiceAsync = ref.read(invoiceProvider);
    final selectedDate = ref.read(dateFilterProvider);

    // Get all available dates from invoiceSent, paidData, and validation
    final availableDates = <String>{};
    invoiceAsync.whenData((paymentStatus) {
      final resultData = paymentStatus.resultData;

      // Collect dates from invoiceSent
      for (var invoice in resultData.invoiceSent) {
        if (invoice.invoiceSubmitDate.isNotEmpty) {
          try {
            final date =
                DateFormat('dd MMM yyyy').parse(invoice.invoiceSubmitDate);
            availableDates.add(DateFormat('MMM yyyy').format(date));
          } catch (e) {
            // Skip invalid date
          }
        }
      }

      // Collect dates from paidData
      for (var item in resultData.paidData) {
        if (item.invoiceSubmitDate.isNotEmpty) {
          try {
            final date =
                DateFormat('dd MMM yyyy').parse(item.invoiceSubmitDate);
            availableDates.add(DateFormat('MMM yyyy').format(date));
          } catch (e) {
            // Skip invalid date
          }
        }
      }

      // Collect dates from validation
      for (var item in resultData.validation) {
        if (item.invoiceSubmitDate.isNotEmpty) {
          try {
            final date =
                DateFormat('dd MMM yyyy').parse(item.invoiceSubmitDate);
            availableDates.add(DateFormat('MMM yyyy').format(date));
          } catch (e) {
            // Skip invalid date
          }
        }
      }
      for (var item in resultData.rejectData) {
        if (item.invoiceSubmitDate.isNotEmpty) {
          try {
            final date =
                DateFormat('dd MMM yyyy').parse(item.invoiceSubmitDate);
            availableDates.add(DateFormat('MMM yyyy').format(date));
          } catch (e) {
            // Skip invalid date
          }
        }
      }
    });

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
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
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
                      ref.read(dateFilterProvider.notifier).state = null;
                      Navigator.pop(context);
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
                        final month = DateFormat('MM')
                            .format(DateFormat('MMM').parse(parts[0]));
                        final year = parts[1];
                        ref.read(dateFilterProvider.notifier).state = {
                          'month': month,
                          'year': year,
                        };
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Constants.lightdull
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 10, top: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date,
                              style: GoogleFonts.merriweather(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (selectedDate != null &&
                                date ==
                                    "${DateFormat('MMM').format(DateFormat('MM').parse(selectedDate['month']!))} ${selectedDate['year']}")
                              const CustomNetworkImage(
                                  color: Constants.darkBlue,
                                  imageUrl:
                                      "https://cdn-icons-png.flaticon.com/128/7794/7794658.png",
                                  defaultIcon: Icons.check),
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
    final invoiceAsync = ref.watch(invoiceProvider);
    final selectedDate = ref.watch(dateFilterProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate responsive font size (e.g., 3% of screen width, capped at 14)
    final tabFontSize = (screenWidth * 0.03).clamp(10.0, 14.0);

    return invoiceAsync.when(
      data: (data) {
        final resultData = data.resultData;
        final invoices = resultData.invoiceSent;
        final paidData = resultData.paidData;
        final validation = resultData.validation;
        final rejectedData = resultData.rejectData;

        // Filter data based on search query
        final filteredInvoices = _filterInvoices(invoices, searchQuery);
        final filteredPaidData = _filterInvoices(paidData, searchQuery);
        final filteredValidation = _filterInvoices(validation, searchQuery);
        final filteredRejected = _filterInvoices(rejectedData, searchQuery);

        // Apply date filter if selected
        List<InvoiceSent> dateFilteredInvoices = filteredInvoices;
        List<InvoiceSent> dateFilteredPaidData = filteredPaidData;
        List<InvoiceSent> dateFilteredValidation = filteredValidation;
        List<InvoiceSent> dateFilteredRejectedData = filteredRejected;

        if (selectedDate != null) {
          final selectedMonth = selectedDate['month'];
          final selectedYear = selectedDate['year'];

          dateFilteredInvoices = filteredInvoices.where((invoice) {
            try {
              final date =
                  DateFormat('dd MMM yyyy').parse(invoice.invoiceSubmitDate);
              return DateFormat('MM').format(date) == selectedMonth &&
                  DateFormat('yyyy').format(date) == selectedYear;
            } catch (e) {
              return false;
            }
          }).toList();

          dateFilteredPaidData = filteredPaidData.where((item) {
            if (item.invoiceSubmitDate.isNotEmpty) {
              try {
                final date =
                    DateFormat('dd MMM yyyy').parse(item.invoiceSubmitDate);
                return DateFormat('MM').format(date) == selectedMonth &&
                    DateFormat('yyyy').format(date) == selectedYear;
              } catch (e) {
                return false;
              }
            }
            return false;
          }).toList();

          dateFilteredValidation = filteredValidation.where((item) {
            if (item.invoiceSubmitDate.isNotEmpty) {
              try {
                final date =
                    DateFormat('dd MMM yyyy').parse(item.invoiceSubmitDate);
                return DateFormat('MM').format(date) == selectedMonth &&
                    DateFormat('yyyy').format(date) == selectedYear;
              } catch (e) {
                return false;
              }
            }
            return false;
          }).toList();

          dateFilteredRejectedData = filteredRejected.where((item) {
            if (item.invoiceSubmitDate.isNotEmpty) {
              try {
                final date =
                    DateFormat('dd MMM yyyy').parse(item.invoiceSubmitDate);
                return DateFormat('MM').format(date) == selectedMonth &&
                    DateFormat('yyyy').format(date) == selectedYear;
              } catch (e) {
                return false;
              }
            }
            return false;
          }).toList();
        }

        // Determine which lists have data after filtering
        final tabData = [
          if (dateFilteredInvoices.isNotEmpty)
            {'name': 'Invoices Sent', 'data': dateFilteredInvoices},
          if (dateFilteredValidation.isNotEmpty)
            {'name': 'Validation', 'data': dateFilteredValidation},
          if (dateFilteredPaidData.isNotEmpty)
            {'name': 'Paid Data', 'data': dateFilteredPaidData},
          if (dateFilteredRejectedData.isNotEmpty)
            {'name': 'Not Paid', 'data': dateFilteredRejectedData},
        ];

        // Dispose of the previous TabController if the number of tabs changes
        if (_tabController != null &&
            _tabController!.length != tabData.length) {
          _tabController!.dispose();
          _tabController = null;
        }

        // Initialize TabController with the number of non-empty lists
        _tabController ??= TabController(length: tabData.length, vsync: this);
        if (data.resultData.invoiceSent.isEmpty &&
            data.resultData.paidData.isEmpty &&
            data.resultData.validation.isEmpty) {
          return const Scaffold(
            backgroundColor: Constants.bgColorWhite,
            body: Center(
              child: customTextForWeather(
                title: "No data available",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Constants.darkBlue,
              ),
            ),
          );
        } else {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                iconTheme: const IconThemeData(color: Constants.black),
                backgroundColor: Constants.borderColor,
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CustomTextFieldforAll(
                    isSearch: true,
                    controller: searchController,
                    isGmail: true,
                    hint: "Search by candidate name",
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query.toLowerCase();
                      });
                    },
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextButton(
                      onPressed: () {
                        _showDateFilterBottomSheet(context);
                      },
                      child: customTextForWeather(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Constants.black,
                          title: selectedDate != null
                              ? "${DateFormat('MMM').format(DateFormat('MM').parse(selectedDate['month']!))} ${selectedDate['year']}"
                              : "Month"),
                    ),
                  ),
                ],
              ),
              body: tabData.isEmpty
                  ? const Center(
                      child: customTextForWeather(
                        title: "No data found",
                        fontSize: 16,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          tabs: tabData
                              .map((tab) => Tab(
                                    text: tab['name'] == "Paid Data"
                                        ? "Paid (${(tab['data'] as List).length})"
                                        : "${tab['name']} (${(tab['data'] as List).length})",
                                  ))
                              .toList(),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          labelColor: Constants.black,
                          unselectedLabelColor: Constants.subtitleclr,
                          indicatorColor: Constants.orange,
                          labelStyle: GoogleFonts.merriweather(
                              fontSize: tabFontSize,
                              fontWeight: FontWeight.w700),
                          unselectedLabelStyle: GoogleFonts.merriweather(
                              fontSize: tabFontSize,
                              fontWeight: FontWeight.normal),
                          indicatorSize: TabBarIndicatorSize.label,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth * 0.02, // Responsive padding
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: tabData.map((tab) {
                              final data = tab['data'] as List<dynamic>;
                              final tabName = tab['name'] as String;

                              return _buildInvoiceList(data, tabName);
                            }).toList(),
                          ),
                        ),
                      ],
                    ));
        }
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Constants.darkBlue,
          ),
        ),
      ),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }

  Widget _buildInvoiceList(List<dynamic> items, String tabName) {
    return RefreshIndicator(
      color: Constants.darkBlue,
      onRefresh: () async {
        // Refresh the invoice data
        await ref.refresh(invoiceProvider.future);
      },
      child: ListView.builder(
        // physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          // Handle InvoiceSent for "Invoices Sent" tab

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvoiceDetail(
                          invoice: item,
                          invoiceTab: InvoiceTab.invoicesent,
                        ),
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
}
