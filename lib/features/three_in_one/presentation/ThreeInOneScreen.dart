import 'package:flutter/material.dart';

class ThreeInOneScreen extends StatefulWidget {
  final List<String> playerNames;

  const ThreeInOneScreen({
    super.key,
    required this.playerNames,
  });

  @override
  State<ThreeInOneScreen> createState() => _ThreeInOneScreenState();
}

class _ThreeInOneScreenState extends State<ThreeInOneScreen> {
  late int player1Score;
  late int player2Score;
  late int player3Score;

  String question =
      'ما هي المدينة التي تستضيف الديربي الأولى في العالم؟';
  String answer = 'غلاسكو (بين سيلتيك ورينجرز)';
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    player1Score = 0;
    player2Score = 0;
    player3Score = 0;
  }

  void incrementScore(int player) {
    setState(() {
      switch (player) {
        case 1:
          player1Score++;
          break;
        case 2:
          player2Score++;
          break;
        case 3:
          player3Score++;
          break;
      }
    });
  }

  void decrementScore(int player) {
    setState(() {
      switch (player) {
        case 1:
          player1Score--;
          break;
        case 2:
          player2Score--;
          break;
        case 3:
          player3Score--;
          break;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      showAnswer = false;
      question = 'من هو أكثر لاعب تسجيلاً للأهداف في كأس العالم؟';
      answer = 'كلوزه - ألمانيا';
    });
  }

  @override
  Widget build(BuildContext context) {
    final names = widget.playerNames;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          '3 في 1',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildPlayerScore(names[2], player3Score, 3),
                buildPlayerScore(names[1], player2Score, 2),
                buildPlayerScore(names[0], player1Score, 1),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (showAnswer)
                        Text(
                          answer,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFFFC700),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: nextQuestion,
                    child: const Text(
                      'التالي',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF404040),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showAnswer = !showAnswer;
                      });
                    },
                    child: const Text(
                      'إظهار الإجابة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayerScore(String name, int score, int playerNumber) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$score',
              style: const TextStyle(
                color: Color(0xFFFFC700),
                fontSize: 40,
                fontWeight: FontWeight.w900,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCircleButton('-', const Color(0xFFFF3030), () {
                  decrementScore(playerNumber);
                }),
                const SizedBox(width: 12),
                buildCircleButton('+', const Color(0xFF00FF87), () {
                  incrementScore(playerNumber);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircleButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
