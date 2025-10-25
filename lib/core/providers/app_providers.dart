import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserState {
  final String name;
  final int points;
  final String avatarUrl;
  final bool hasCompletedOnboarding;

  const UserState({
    this.name = 'Player',
    this.points = 0,
    this.avatarUrl = '',
    this.hasCompletedOnboarding = false,
  });

  UserState copyWith({
    String? name,
    int? points,
    String? avatarUrl,
    bool? hasCompletedOnboarding,
  }) {
    return UserState(
      name: name ?? this.name,
      points: points ?? this.points,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState()) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'Player';
    final points = prefs.getInt('user_points') ?? 0;
    final avatarUrl = prefs.getString('user_avatar') ?? '';
    final hasCompletedOnboarding = prefs.getBool('has_completed_onboarding') ?? false;

    state = UserState(
      name: name,
      points: points,
      avatarUrl: avatarUrl,
      hasCompletedOnboarding: hasCompletedOnboarding,
    );
  }

  Future<void> updateName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    state = state.copyWith(name: name);
  }

  Future<void> addPoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final newPoints = state.points + points;
    await prefs.setInt('user_points', newPoints);
    state = state.copyWith(points: newPoints);
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  Future<void> resetUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const UserState();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

class GameState {
  final int currentRound;
  final int team1Score;
  final int team2Score;
  final int totalScore;
  final bool isTimerRunning;
  final int timerSeconds;
  final bool isAnswerRevealed;

  const GameState({
    this.currentRound = 0,
    this.team1Score = 0,
    this.team2Score = 0,
    this.totalScore = 0,
    this.isTimerRunning = false,
    this.timerSeconds = 120,
    this.isAnswerRevealed = false,
  });

  GameState copyWith({
    int? currentRound,
    int? team1Score,
    int? team2Score,
    int? totalScore,
    bool? isTimerRunning,
    int? timerSeconds,
    bool? isAnswerRevealed,
  }) {
    return GameState(
      currentRound: currentRound ?? this.currentRound,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      totalScore: totalScore ?? this.totalScore,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isAnswerRevealed: isAnswerRevealed ?? this.isAnswerRevealed,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(const GameState());

  void setCurrentRound(int round) {
    state = state.copyWith(currentRound: round);
  }

  void updateTeam1Score(int score) {
    state = state.copyWith(team1Score: score);
  }

  void updateTeam2Score(int score) {
    state = state.copyWith(team2Score: score);
  }

  void addToTotalScore(int points) {
    state = state.copyWith(totalScore: state.totalScore + points);
  }

  void subtractFromTotalScore(int points) {
    state = state.copyWith(totalScore: (state.totalScore - points).clamp(0, double.infinity).toInt());
  }

  void setTimerRunning(bool running) {
    state = state.copyWith(isTimerRunning: running);
  }

  void updateTimer(int seconds) {
    state = state.copyWith(timerSeconds: seconds);
  }

  void setAnswerRevealed(bool revealed) {
    state = state.copyWith(isAnswerRevealed: revealed);
  }

  void resetGame() {
    state = const GameState();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class PasswordGameState {
  final List<bool> revealedBoxes;
  final int currentPlayerIndex;
  final List<String> playerNames;

  const PasswordGameState({
    this.revealedBoxes = const [false, false, false, false, false, false, false, false, false, false],
    this.currentPlayerIndex = 0,
    this.playerNames = const [
      'Lionel Messi',
      'Cristiano Ronaldo',
      'Neymar Jr',
      'Kylian Mbappأ©',
      'Mohamed Salah',
      'Robert Lewandowski',
      'Kevin De Bruyne',
      'Virgil van Dijk',
      'Luka Modriؤ‡',
      'Erling Haaland',
    ],
  });

  PasswordGameState copyWith({
    List<bool>? revealedBoxes,
    int? currentPlayerIndex,
    List<String>? playerNames,
  }) {
    return PasswordGameState(
      revealedBoxes: revealedBoxes ?? this.revealedBoxes,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      playerNames: playerNames ?? this.playerNames,
    );
  }
}

class PasswordGameNotifier extends StateNotifier<PasswordGameState> {
  PasswordGameNotifier() : super(const PasswordGameState());

  void toggleBox(int index) {
    final newRevealedBoxes = List<bool>.from(state.revealedBoxes);
    if (!newRevealedBoxes[index]) {
      newRevealedBoxes[index] = true;
      state = state.copyWith(revealedBoxes: newRevealedBoxes);
    }
  }

  void resetGrid() {
    state = state.copyWith(
      revealedBoxes: List.generate(10, (index) => false),
      currentPlayerIndex: 0,
    );
  }

  void updatePlayerNames(List<String> newNames) {
    state = state.copyWith(playerNames: newNames);
  }
}

final passwordGameProvider = StateNotifierProvider<PasswordGameNotifier, PasswordGameState>((ref) {
  return PasswordGameNotifier();
});
