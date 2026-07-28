import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/custom_loading.dart';
import 'package:job_circle/src/model/faq/faq_model.dart';
import 'package:job_circle/src/provider/faq/faq_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';
import 'package:provider/provider.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  int? _expandedFaqId;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prod = context.read<FaqProvider>();
      prod.dispose();
      prod.loadFaqs();
    });
  }

  void _initTabController(List<String> categories) {
    if (categories.isEmpty) return;

    if (_tabController == null || _tabController!.length != categories.length) {
      _tabController?.dispose();
      _tabController = TabController(length: categories.length, vsync: this);

      _tabController!.addListener(() {
        if (!_tabController!.indexIsChanging) {
          final provider = context.read<FaqProvider>();
          provider.selectCategory(categories[_tabController!.index]);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.bgColor,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: colors.appbarColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.headingColor),
        title: _isSearching
            ? Consumer<FaqProvider>(
                builder: (_, provider, _) => TextField(
                  controller: provider.searchtext,
                  autofocus: true,
                  onChanged: provider.updateSearchQuery,
                  style: TextStyle(color: colors.headingColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Frequently ask questions',
                    hintStyle: TextStyle(
                      color: colors.subTitleColor,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              )
            : customText(
                title: 'FAQs',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.headingColor,
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: colors.headingColor,
            ),
            onPressed: () {
              final provider = context.read<FaqProvider>();
              if (_isSearching) {
                provider.searchtext.clear();
                provider.updateSearchQuery('');
              }
              setState(() => _isSearching = !_isSearching);
            },
          ),
        ],
      ),
      body: Consumer<FaqProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return CustomLoadingIndicator();
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: colors.orangeLine),
                  const SizedBox(height: 12),
                  customText(
                    title: provider.errorMessage!,
                    color: colors.subTitleColor,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadFaqs(),
                    child: const customText(title: 'Retry'),
                  ),
                ],
              ),
            );
          }

          // Sync TabController whenever categories update
          _initTabController(provider.categories);

          // Keep tab in sync with provider.selectedCategory (e.g. auto-switch on search)
          final targetIdx = provider.categories.indexOf(
            provider.selectedCategory,
          );
          if (_tabController != null &&
              targetIdx >= 0 &&
              _tabController!.index != targetIdx) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _tabController?.animateTo(targetIdx);
            });
          }

          return Column(
            children: [
              // Category TabBar with custom styling
              if (provider.categories.isNotEmpty && _tabController != null)
                Container(
                  color: colors.bottomsheetbgColor,
                  child: AnimatedBuilder(
                    animation: _tabController!,
                    builder: (context, child) {
                      return TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: colors.textPrimary,
                        unselectedLabelColor: colors.subTitleColor,
                        indicatorColor: colors.orangeLine,
                        indicatorWeight: 2.5,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.transparent,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        tabs: provider.categories.map((category) {
                          final tabIdx = provider.categories.indexOf(category);
                          final isSelected = _tabController!.indexIsChanging
                              ? _tabController!.index == tabIdx
                              : (_tabController!.animation?.value.round() ??
                                        _tabController!.index) ==
                                    tabIdx;

                          // Count FAQs per category (filtered by search)
                          final categoryCount = provider
                              .filteredCountForCategory(category);

                          return Tab(
                            child: customText(
                              title: '$category ($categoryCount)',
                              color: colors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),

              const Divider(height: 1),

              // TabBarView displaying FAQ content per tab
              if (provider.categories.isNotEmpty && _tabController != null)
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: provider.categories.map((category) {
                      final faqs = provider.filteredFaqs;

                      if (faqs.isEmpty) {
                        return Center(
                          child: customText(
                            title: 'No FAQs found',
                            color: colors.subTitleColor,
                            fontSize: 16,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: faqs.length,
                        itemBuilder: (context, index) {
                          final faq = faqs[index];
                          return _FaqCard(
                            key: ValueKey(
                              '${faq.id}_${_expandedFaqId == faq.id}',
                            ),
                            faq: faq,
                            colors: colors,
                            isExpanded: _expandedFaqId == faq.id,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _expandedFaqId = expanded ? faq.id : null;
                              });
                            },
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final FaqItem faq;
  final AppColors colors;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const _FaqCard({
    super.key,
    required this.faq,
    required this.colors,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.subTitleColor!,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: customText(
            title: faq.question,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: colors.textPrimary,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: customText(
                  title: faq.answer,
                  fontSize: 14,
                  color: colors.subTitleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
