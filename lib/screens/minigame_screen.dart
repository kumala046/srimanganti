import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MinigameScreen extends StatefulWidget {
  const MinigameScreen({Key? key}) : super(key: key);

  @override
  State<MinigameScreen> createState() => _MinigameScreenState();
}

class _MinigameScreenState extends State<MinigameScreen> {
  final List<Map<String, dynamic>> levels = [
    {'level': 1, 'cards': 6, 'time': 30},
    {'level': 2, 'cards': 12, 'time': 45},
    {'level': 3, 'cards': 16, 'time': 60},
  ];

  final List<String> allImages = [
    'assets/wayang1.jpg', 'assets/wayang2.jpg', 'assets/wayang3.jpg',
    'assets/gamelan1.jpg', 'assets/gamelan2.jpg', 'assets/gamelan3.jpg',
    'assets/batik1.jpg', 'assets/batik2.jpg', 'assets/batik3.jpg',
  ];

  int currentLevelIndex = 0;
  List<String> currentCards = [];
  List<bool> cardFlipped = [];
  List<bool> cardMatched = [];
  int? firstCardIndex;
  int matchedPairs = 0;
  int timeLeft = 0;
  Timer? timer;
  bool isGameOver = false;
  bool isLevelComplete = false;
  bool lockBoard = false;

  @override
  void initState() {
    super.initState();
    startLevel(0);
  }

  void startLevel(int levelIndex) {
    setState(() {
      currentLevelIndex = levelIndex;
      firstCardIndex = null;
      matchedPairs = 0;
      isGameOver = false;
      isLevelComplete = false;
      lockBoard = false;
      
      int numCards = levels[levelIndex]['cards'];
      timeLeft = levels[levelIndex]['time'];

      int pairs = numCards ~/ 2;
      List<String> selectedImages = allImages.take(pairs).toList();
      currentCards = [...selectedImages, ...selectedImages];
      currentCards.shuffle(Random());

      cardFlipped = List.generate(numCards, (index) => false);
      cardMatched = List.generate(numCards, (index) => false);
    });

    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        t.cancel();
        setState(() => isGameOver = true);
      }
    });
  }

  void onCardTap(int index) {
    if (lockBoard || cardFlipped[index] || cardMatched[index]) return;
    setState(() => cardFlipped[index] = true);
    if (firstCardIndex == null) {
      firstCardIndex = index;
    } else {
      lockBoard = true;
      if (currentCards[firstCardIndex!] == currentCards[index]) {
        setState(() {
          cardMatched[firstCardIndex!] = true;
          cardMatched[index] = true;
          firstCardIndex = null;
          matchedPairs++;
          lockBoard = false;
        });
        checkWinCondition();
      } else {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            cardFlipped[firstCardIndex!] = false;
            cardFlipped[index] = false;
            firstCardIndex = null;
            lockBoard = false;
          });
        });
      }
    }
  }

  void checkWinCondition() {
    int totalPairs = levels[currentLevelIndex]['cards'] ~/ 2;
    if (matchedPairs == totalPairs) {
      timer?.cancel();
      if (currentLevelIndex < levels.length - 1) {
        setState(() => isLevelComplete = true);
      } else {
        setState(() => isGameOver = true);
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int numCards = levels[currentLevelIndex]['cards'];
    int crossAxisCount = currentLevelIndex == 2 ? 4 : 3;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F6EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0B3D2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Minigame', style: TextStyle(color: Color(0xFF0B3D2E), fontFamily: 'Serif', fontWeight: FontWeight.bold)),
      ),
      body: Center( // Membuat konten ke tengah
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420), // Lebar maksimal
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFF3E9D2), borderRadius: BorderRadius.circular(20)),
                      child: Text('Level ${currentLevelIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E))),
                    ),
                    Text('Waktu: $timeLeft', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E), fontSize: 16)),
                  ],
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: numCards,
                    itemBuilder: (context, index) {
                      bool isFlipped = cardFlipped[index] || cardMatched[index];
                      return GestureDetector(
                        onTap: () => onCardTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: cardMatched[index] ? const Color(0xFFD4EDDA) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: cardMatched[index] ? const Color(0xFF155724) : const Color(0xFFE6D5B8),
                              width: 2,
                            ),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                          ),
                          child: isFlipped 
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(currentCards[index], fit: BoxFit.contain),
                                  ),
                                )
                              : const Icon(Icons.question_mark, color: Color(0xFF0B3D2E), size: 30),
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (isLevelComplete)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => startLevel(currentLevelIndex + 1),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D2E), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Lanjut ke Level Berikutnya'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isGameOver ? _buildGameOverDialog() : null,
    );
  }

  Widget _buildGameOverDialog() {
    bool isAllLevelsWon = matchedPairs == levels[currentLevelIndex]['cards'] ~/ 2;
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isAllLevelsWon ? 'Selamat!' : 'Waktu Habis!',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0B3D2E)),
          ),
          const SizedBox(height: 12),
          Text(
            isAllLevelsWon ? 'Kamu berhasil menyelesaikan semua level!' : 'Kamu gagal di level ini. Ayo coba lagi!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (isAllLevelsWon) {
                      startLevel(0);
                    } else {
                      startLevel(currentLevelIndex);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3D2E), foregroundColor: Colors.white),
                  child: Text(isAllLevelsWon ? 'Main Lagi' : 'Ulangi Level Ini'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE6D5B8), foregroundColor: const Color(0xFF0B3D2E)),
                  child: const Text('Kembali'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}