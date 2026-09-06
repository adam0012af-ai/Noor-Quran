import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/banner_ad_widget.dart';
import '../../providers/azkar_provider.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AzkarProvider>();
    final categories = provider.items.map((e) => e.category).toSet().toList();
    return DefaultTabController(
      length: categories.isEmpty ? 1 : categories.length,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأذكار'), bottom: TabBar(isScrollable: true, tabs: categories.isEmpty ? const [Tab(text: 'الأذكار')] : categories.map((e) => Tab(text: e)).toList())),
        body: provider.loading ? const Center(child: CircularProgressIndicator()) : Column(children: [
          Expanded(child: categories.isEmpty ? const Center(child: Text('لا توجد أذكار')) : TabBarView(children: categories.map((category) {
            final items = provider.byCategory(category);
            return ListView.builder(padding: const EdgeInsets.all(12), itemCount: items.length, itemBuilder: (context, i) {
              final item = items[i];
              final remaining = provider.remaining(item);
              return Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text(item.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, height: 1.8)), if (item.reference != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(item.reference!, style: Theme.of(context).textTheme.bodySmall)), const SizedBox(height: 12), FilledButton.tonal(onPressed: () { HapticFeedback.lightImpact(); provider.decrement(item); }, child: Text(remaining == 0 ? 'ابدأ من جديد' : 'المتبقي: $remaining'))])));
            });
          }).toList())),
          const Center(child: BannerAdWidget()),
        ]),
      ),
    );
  }
}
