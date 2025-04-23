import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/mood_service.dart';
import '../widgets/mood_chart.dart';
import '../models/mood_entry.dart';
import 'add_mood_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final MoodService _service = MoodService();
  List<MoodEntry> _moods = [];
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMoods();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMoods() async {
    setState(() => _isLoading = true);
    final moods = await _service.getMoods();
    setState(() {
      _moods = moods;
      _isLoading = false;
    });
  }

  String _getEmotionEmoji(int value) {
    switch (value) {
      case 1: return '😢';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '😐';
    }
  }

  String _getEmotionText(int value) {
    switch (value) {
      case 1: return 'Péssimo';
      case 2: return 'Ruim';
      case 3: return 'Neutro';
      case 4: return 'Bom';
      case 5: return 'Excelente';
      default: return 'Neutro';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                expandedHeight: isSmallScreen ? 70 : 100,
                toolbarHeight: isSmallScreen ? 40 : 56,
                pinned: false,
                floating: true,
                snap: true,
                centerTitle: true,
                title: null,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Container(
                    margin: EdgeInsets.only(bottom: isSmallScreen ? 34 : 42),
                    child: Text(
                      'Diário de Emoções',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 20,
                      ),
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  labelStyle: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.normal,
                  ),
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.show_chart, size: isSmallScreen ? 18 : 22),
                      text: 'Gráfico',
                      height: isSmallScreen ? 38 : 50,
                    ),
                    Tab(
                      icon: Icon(Icons.history, size: isSmallScreen ? 18 : 22), 
                      text: 'Histórico',
                      height: isSmallScreen ? 38 : 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // Gráfico Tab
                    Builder(
                      builder: (context) => CustomScrollView(
                        slivers: [
                          SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          ),
                          SliverToBoxAdapter(
                            child: _moods.isEmpty
                                ? _buildEmptyState()
                                : Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      isSmallScreen ? 8.0 : 16.0,
                                      isSmallScreen ? 24.0 : 32.0,
                                      isSmallScreen ? 8.0 : 16.0,
                                      isSmallScreen ? 8.0 : 16.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Seu progresso emocional',
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontSize: isSmallScreen ? 16 : null,
                                          ),
                                        ),
                                        SizedBox(height: isSmallScreen ? 2 : 4),
                                        Text(
                                          'Acompanhe como você tem se sentido ao longo do tempo',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                            fontSize: isSmallScreen ? 12 : null,
                                          ),
                                        ),
                                        SizedBox(height: isSmallScreen ? 12 : 24),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.6,
                                          child: Card(
                                            elevation: 2,
                                            child: Padding(
                                              padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
                                              child: MoodChart(moods: _moods),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Histórico Tab
                    Builder(
                      builder: (context) => CustomScrollView(
                        slivers: [
                          SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                          ),
                          _moods.isEmpty
                              ? SliverFillRemaining(
                                  child: _buildEmptyState(),
                                )
                              : SliverPadding(
                                  padding: EdgeInsets.fromLTRB(
                                    isSmallScreen ? 8.0 : 16.0,
                                    isSmallScreen ? 24.0 : 32.0,
                                    isSmallScreen ? 8.0 : 16.0,
                                    isSmallScreen ? 8.0 : 16.0,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        // Ordene por data mais recente
                                        final mood = _moods.reversed.toList()[index];
                                        return Card(
                                          margin: EdgeInsets.only(bottom: isSmallScreen ? 8.0 : 16.0),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: isSmallScreen ? 12.0 : 16.0,
                                              vertical: isSmallScreen ? 6.0 : 8.0,
                                            ),
                                            leading: CircleAvatar(
                                              radius: isSmallScreen ? 18 : 22,
                                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                              child: Text(
                                                _getEmotionEmoji(mood.moodValue),
                                                style: TextStyle(fontSize: isSmallScreen ? 18 : 24),
                                              ),
                                            ),
                                            title: Text(
                                              _getEmotionText(mood.moodValue),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: isSmallScreen ? 14 : 16,
                                              ),
                                            ),
                                            subtitle: Text(
                                              DateFormat('dd/MM/yyyy - HH:mm').format(mood.date),
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                                fontSize: isSmallScreen ? 12 : 14,
                                              ),
                                            ),
                                            trailing: Container(
                                              width: isSmallScreen ? 36 : 48,
                                              height: isSmallScreen ? 36 : 48,
                                              decoration: BoxDecoration(
                                                color: _getMoodColor(mood.moodValue),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  mood.moodValue.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: isSmallScreen ? 14 : 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: _moods.length,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMoodPage()),
          );
          _loadMoods();
        },
        icon: const Icon(Icons.add),
        label: Text(isSmallScreen ? '' : 'Registrar'),
        isExtended: !isSmallScreen,
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mood,
            size: isSmallScreen ? 60 : 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'Nenhuma emoção registrada',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: isSmallScreen ? 18 : null,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            'Registre como você está se sentindo hoje',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddMoodPage()),
              );
              _loadMoods();
            },
            icon: const Icon(Icons.add),
            label: const Text('Registrar primeiro humor'),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(int value) {
    switch (value) {
      case 1:
        return Colors.red.shade700;
      case 2:
        return Colors.orange.shade700;
      case 3:
        return Colors.amber.shade700;
      case 4:
        return Colors.lightGreen.shade700;
      case 5:
        return Colors.green.shade700;
      default:
        return Colors.amber.shade700;
    }
  }
}
