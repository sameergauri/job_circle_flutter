import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    with SingleTickerProviderStateMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
    _refreshController.dispose();
    searchController.dispose();
    super.dispose();
  }

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

      // Collect dates from paidData (assuming it has invoiceSubmitDate)
      for (var item in resultData.paidData) {
        if (item is Map<String, dynamic> && item['invoiceSubmitDate'] != null) {
          try {
            final date =
                DateFormat('dd MMM yyyy').parse(item['invoiceSubmitDate']);
            availableDates.add(DateFormat('MMM yyyy').format(date));
          } catch (e) {
            // Skip invalid date
          }
        }
      }

      // Collect dates from validation (assuming it has invoiceSubmitDate)
      for (var item in resultData.validation) {
        if (item is Map<String, dynamic> && item['invoiceSubmitDate'] != null) {
          try {
            final date =
                DateFormat('dd MMM yyyy').parse(item['invoiceSubmitDate']);
            availableDates.add(DateFormat('MMM yyyy').format(date));
          } catch (e) {
            // Skip invalid date
          }
        }
      }
    });

    final sortedDates = availableDates.toList()..sort();

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
                    "Invoice Submit Date",
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
                      "Clear All",
                      style: GoogleFonts.merriweather(
                        fontSize: 14,
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

    return Scaffold(
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
            hint: "Search by organization, invoice or candidate",
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
                  title: selectedDate != null
                      ? "${DateFormat('MMM').format(DateFormat('MM').parse(selectedDate['month']!))} ${selectedDate['year']}"
                      : "Select Month"),
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          ref.invalidate(invoiceProvider);
          await Future.delayed(const Duration(seconds: 1));
          _refreshController.refreshCompleted();
        },
        child: invoiceAsync.when(
          data: (paymentStatus) {
            final resultData = paymentStatus.resultData;
            final invoices = resultData.invoiceSent;
            final paidData = resultData.paidData;
            final validation = resultData.validation;

            // Filter invoices based on search query
            final filteredInvoices = _filterInvoices(invoices, searchQuery);

            // Apply date filter if selected
            List<InvoiceSent> dateFilteredInvoices = filteredInvoices;
            List<dynamic> dateFilteredPaidData = paidData;
            List<dynamic> dateFilteredValidation = validation;

            if (selectedDate != null) {
              final selectedMonth = selectedDate['month'];
              final selectedYear = selectedDate['year'];

              dateFilteredInvoices = filteredInvoices.where((invoice) {
                try {
                  final date = DateFormat('dd MMM yyyy')
                      .parse(invoice.invoiceSubmitDate);
                  return DateFormat('MM').format(date) == selectedMonth &&
                      DateFormat('yyyy').format(date) == selectedYear;
                } catch (e) {
                  return false;
                }
              }).toList();

              dateFilteredPaidData = paidData.where((item) {
                if (item is Map<String, dynamic> &&
                    item['invoiceSubmitDate'] != null) {
                  try {
                    final date = DateFormat('dd MMM yyyy')
                        .parse(item['invoiceSubmitDate']);
                    return DateFormat('MM').format(date) == selectedMonth &&
                        DateFormat('yyyy').format(date) == selectedYear;
                  } catch (e) {
                    return false;
                  }
                }
                return false;
              }).toList();

              dateFilteredValidation = validation.where((item) {
                if (item is Map<String, dynamic> &&
                    item['invoiceSubmitDate'] != null) {
                  try {
                    final date = DateFormat('dd MMM yyyy')
                        .parse(item['invoiceSubmitDate']);
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
              if (dateFilteredPaidData.isNotEmpty)
                {'name': 'Paid Data', 'data': dateFilteredPaidData},
              if (dateFilteredValidation.isNotEmpty)
                {'name': 'Validation', 'data': dateFilteredValidation},
            ];

            if (tabData.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            // Dispose of the previous TabController if the number of tabs changes
            if (_tabController != null &&
                _tabController!.length != tabData.length) {
              _tabController!.dispose();
              _tabController = null;
            }

            // Initialize TabController with the number of non-empty lists
            _tabController ??=
                TabController(length: tabData.length, vsync: this);

            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: tabData
                      .map((tab) => Tab(
                            text: tab['name'] as String,
                          ))
                      .toList(),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabAlignment: TabAlignment.start,
                  labelColor: Constants.black,
                  unselectedLabelColor: Constants.subtitleclr,
                  indicatorColor: Constants.orange,
                  labelStyle: GoogleFonts.merriweather(
                      fontSize: 12, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: GoogleFonts.merriweather(
                      fontSize: 12, fontWeight: FontWeight.normal),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: tabData.map((tab) {
                      final data = tab['data'] as List<dynamic>;
                      final tabName = tab['name'] as String;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //  if (tabName == 'Invoices Sent')
                            ...data.map((invoice) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InvoiceDetail(
                                                  invoice: invoice,
                                                  invoiceTab: tabName ==
                                                          'Invoices Sent'
                                                      ? InvoiceTab.invoicesent
                                                      : tabName == 'Paid Data'
                                                          ? InvoiceTab.paid
                                                          : tabName ==
                                                                  'Validation'
                                                              ? InvoiceTab
                                                                  .validation
                                                              : InvoiceTab
                                                                  .reject,
                                                )));
                                  },
                                  child: CustomInvoiceCard(
                                    invoice: invoice as InvoiceSent,
                                  ),
                                ))
                            /*  else
                              ...data.map((item) => Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        item.toString(),
                                        style: GoogleFonts.merriweather(
                                            fontSize: 14),
                                      ),
                                    ),
                                  )), */
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
