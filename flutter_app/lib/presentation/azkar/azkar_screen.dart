import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/banner_ad_widget.dart';
import '../../providers/azkar_provider.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AzkarProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AzkarProvider>();
    final categories = provider.items.map((e) => e.category).toSet().toList();

    if (provider.loading && !provider.loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (provider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('الأذكار')),
        body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.error_outline, size: 56), const SizedBox(height: 12), const Text('تعذر تحميل الأذكار'), const SizedBox(height: 8), SelectableText(provider.error!, textAlign: TextAlign.center), const SizedBox(height: 16), FilledButton(onPressed: provider.load, child: const Text('إعادة المحاولة'))]))),
      );
    }

    return DefaultTabController(
      length: categories.isEmpty ? 1 : categories.length,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأذكار'), bottom: TabBar(isScrollable: true, tabs: categories.isEmpty ? const [Tab(text: 'الأذكار')] : categories.map((e) => Tab(text: e)).toList())),
        body: Column(children: [
          Expanded(child: categories.isEmpty ? const Center(child: Text('لا توجد أذكار')) : TabBarView(children: categories.map((category) {
            final items = provider.byCategory(category);
            return ListView.builder(padding: const EdgeInsets.all(12), itemCount: items.length, itemBuilder: (context, i) {
              final item = items[i];
              final remaining = provider.remaining(item);
              return Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text(item.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, height: 1.8)), const SizedBox(height: 12), FilledButton.tonal(onPressed: () { HapticFeedback.lightImpact(); provider.decrement(item); }, child: Text(remaining == 0 ? 'ابدأ من جديد' : 'المتبقي: $remaining'))])));
            });
          }).toList())),
          const Center(child: BannerAdWidget()),
        ]),
      ),
    );
  }
}
