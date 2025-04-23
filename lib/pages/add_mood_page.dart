import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import '../services/mood_service.dart';

class AddMoodPage extends StatefulWidget {
  const AddMoodPage({Key? key}) : super(key: key);

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  int _selectedMood = 3;
  bool _isSaving = false;

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

  Future<void> _saveMood() async {
    if (_isSaving) return;
    
    setState(() => _isSaving = true);
    
    try {
      await MoodService().addMood(MoodEntry(
        date: DateTime.now(),
        moodValue: _selectedMood,
      ));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Como está se sentindo?',
          style: TextStyle(fontSize: isSmallScreen ? 18 : 22),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Selecione como você está se sentindo:',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Lista de emoções uma abaixo da outra
                    for (int i = 5; i >= 1; i--) // Começando pelo mais positivo
                      _buildMoodOption(i, isSmallScreen),
                  ],
                ),
              ),
            ),
            
            // Botão de salvar na parte inferior
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: SizedBox(
                width: double.infinity,
                height: isSmallScreen ? 48 : 55,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveMood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getMoodColor(_selectedMood),
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: isSmallScreen ? 20 : 24,
                          height: isSmallScreen ? 20 : 24,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Salvar Emoção',
                          style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMoodOption(int value, bool isSmallScreen) {
    final isSelected = _selectedMood == value;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMood = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12.0 : 16.0,
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? _getMoodColor(value).withOpacity(0.15) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                  ? _getMoodColor(value) 
                  : Theme.of(context).dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                _getMoodEmoji(value),
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMoodLabel(value),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected 
                            ? _getMoodColor(value) 
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: _getMoodColor(value),
                  size: isSmallScreen ? 22 : 26,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
