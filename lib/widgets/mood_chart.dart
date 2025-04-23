import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';
import 'package:intl/intl.dart';

class MoodChart extends StatelessWidget {
  final List<MoodEntry> moods;

  const MoodChart({Key? key, required this.moods}) : super(key: key);

  Color _getMoodColor(int value) {
    switch (value) {
      case 1: return Colors.red.shade700;
      case 2: return Colors.orange.shade700;
      case 3: return Colors.amber.shade700;
      case 4: return Colors.lightGreen.shade700;
      case 5: return Colors.green.shade700;
      default: return Colors.amber.shade700;
    }
  }

  String _getMoodEmoji(int value) {
    switch (value) {
      case 1: return '😢';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '😐';
    }
  }

  String _getMoodLabel(int value) {
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
    // Verificar se a tela é pequena (menor que 600px de largura)
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    // Contagem da quantidade de cada humor
    final Map<int, int> moodCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    
    // Contar a quantidade de cada humor
    for (var mood in moods) {
      moodCounts[mood.moodValue] = (moodCounts[mood.moodValue] ?? 0) + 1;
    }
    
    // Encontrar o valor máximo para escala do gráfico
    final maxCount = moodCounts.values.fold(0, (max, count) => count > max ? count : max);
    
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8.0 : 16.0,
              vertical: isSmallScreen ? 16.0 : 24.0,
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxCount * 1.2, // Adiciona 20% de espaço acima
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final moodValue = value.toInt() + 1;
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            children: [
                              Text(
                                _getMoodEmoji(moodValue),
                                style: TextStyle(fontSize: isSmallScreen ? 16 : 20),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getMoodLabel(moodValue),
                                style: TextStyle(
                                  color: _getMoodColor(moodValue),
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 9 : 11,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      reservedSize: isSmallScreen ? 50 : 70,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        
                        // Só mostrar números inteiros
                        if (value % 1 != 0) return const SizedBox.shrink();
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 10 : 12,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.transparent,
                    ),
                    top: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                barGroups: [
                  for (int i = 0; i < 5; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: moodCounts[i + 1]!.toDouble(),
                          color: _getMoodColor(i + 1),
                          width: isSmallScreen ? 15 : 25,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    ),
                ],
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final moodValue = group.x + 1;
                      return BarTooltipItem(
                        '${_getMoodLabel(moodValue)}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '${rod.toY.toInt()} registros',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Total de registros: ${moods.length}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
