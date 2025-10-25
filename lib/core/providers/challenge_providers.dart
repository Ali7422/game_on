import 'package:flutter_riverpod/flutter_riverpod.dart';


class Top10State {
  final List<bool> selectedPlayers;
  final List<int?> selectedByTeam;
  final int activeTeam;
  final int team1Score;
  final int team2Score;
  final String currentQuestion;

  const Top10State({
    this.selectedPlayers = const [
      false, false, false, false, false, false, false,
      false, false, false,
    ],
    this.selectedByTeam = const [null, null, null, null, null, null, null, null, null, null,],
    this.activeTeam = 1,
    this.team1Score = 0,
    this.team2Score = 0,
    this.currentQuestion = 'Select all the players who have won the Ballon d\'Or:',
  });

  Top10State copyWith({
    List<bool>? selectedPlayers,
    List<int?>? selectedByTeam,
    int? activeTeam,
    int? team1Score,
    int? team2Score,
    String? currentQuestion,
  }) {
    return Top10State(
      selectedPlayers: selectedPlayers ?? this.selectedPlayers,
      selectedByTeam: selectedByTeam ?? this.selectedByTeam,
      activeTeam: activeTeam ?? this.activeTeam,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      currentQuestion: currentQuestion ?? this.currentQuestion,
    );
  }
}

class Top10Notifier extends StateNotifier<Top10State> {
  Top10Notifier() : super(const Top10State());

  void switchTeam() {
    state = state.copyWith(activeTeam: state.activeTeam == 1 ? 2 : 1);
  }

  void togglePlayer(int index) {
    if (state.selectedPlayers[index]) return;

    final newSelectedPlayers = List<bool>.from(state.selectedPlayers);
    final newSelectedByTeam = List<int?>.from(state.selectedByTeam);

    newSelectedPlayers[index] = true;
    newSelectedByTeam[index] = state.activeTeam;

    final points = index + 1;

    int newTeam1Score = state.team1Score;
    int newTeam2Score = state.team2Score;

    if (state.activeTeam == 1) {
      newTeam1Score += points;
    } else {
      newTeam2Score += points;
    }

    state = state.copyWith(
      selectedPlayers: newSelectedPlayers,
      selectedByTeam: newSelectedByTeam,
      team1Score: newTeam1Score,
      team2Score: newTeam2Score,
    );
  }

  void resetSelection() {
    state = state.copyWith(
      selectedPlayers: List.filled(13, false),
      selectedByTeam: List.filled(13, null),
      team1Score: 0,
      team2Score: 0,
    );
  }
}

final top10Provider = StateNotifierProvider<Top10Notifier, Top10State>((ref) {
  return Top10Notifier();
});




class PictureChallengeState {
  final bool namesRevealed;
  final String imageUrl;
  final List<String> playerNames;

  const PictureChallengeState({
    this.namesRevealed = false,
    this.imageUrl = 'assets/images/player_group.jpg',
    this.playerNames = const [
      'Lionel Messi',
      'Cristiano Ronaldo',
      'Neymar Jr',
      'Kylian Mbappé',
      'Mohamed Salah'
    ],
  });

  PictureChallengeState copyWith({
    bool? namesRevealed,
    String? imageUrl,
    List<String>? playerNames,
  }) {
    return PictureChallengeState(
      namesRevealed: namesRevealed ?? this.namesRevealed,
      imageUrl: imageUrl ?? this.imageUrl,
      playerNames: playerNames ?? this.playerNames,
    );
  }
}

class PictureChallengeNotifier extends StateNotifier<PictureChallengeState> {
  PictureChallengeNotifier() : super(const PictureChallengeState());

  void toggleNamesReveal() {
    state = state.copyWith(namesRevealed: !state.namesRevealed);
  }

  void resetChallenge() {
    state = const PictureChallengeState();
  }
}

final pictureChallengeProvider =
StateNotifierProvider<PictureChallengeNotifier, PictureChallengeState>(
        (ref) {
      return PictureChallengeNotifier();
    });

class WhoAmIState {
  final int timerSeconds;
  final bool isTimerRunning;
  final bool isTimerPaused;
  final List<bool> playerRevealed;

  const WhoAmIState({
    this.timerSeconds = 60,
    this.isTimerRunning = false,
    this.isTimerPaused = false,
    this.playerRevealed = const [false, false, false],
  });

  WhoAmIState copyWith({
    int? timerSeconds,
    bool? isTimerRunning,
    bool? isTimerPaused,
    List<bool>? playerRevealed,
  }) {
    return WhoAmIState(
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      isTimerPaused: isTimerPaused ?? this.isTimerPaused,
      playerRevealed: playerRevealed ?? this.playerRevealed,
    );
  }
}

class WhoAmINotifier extends StateNotifier<WhoAmIState> {
  WhoAmINotifier() : super(const WhoAmIState());

  void startTimer() {
    state = state.copyWith(
      isTimerRunning: true,
      isTimerPaused: false,
      timerSeconds: 60,
    );
  }

  void pauseTimer() {
    state = state.copyWith(isTimerRunning: false, isTimerPaused: true);
  }

  void resetTimer() {
    state = state.copyWith(
      isTimerRunning: false,
      isTimerPaused: false,
      timerSeconds: 60,
    );
  }

  void updateTimer(int seconds) {
    state = state.copyWith(timerSeconds: seconds);
  }

  void togglePlayerReveal(int index) {
    final newRevealed = List<bool>.from(state.playerRevealed);
    newRevealed[index] = !newRevealed[index];
    state = state.copyWith(playerRevealed: newRevealed);
  }

  void resetAllReveals() {
    state = state.copyWith(playerRevealed: [false, false, false]);
  }
}

final whoAmIProvider =
StateNotifierProvider<WhoAmINotifier, WhoAmIState>((ref) {
  return WhoAmINotifier();
});
class RiskChallengeState {
  final int timerSeconds;
  final bool isTimerRunning;
  final bool isTimerPaused;
  final int team1Score;
  final int team2Score;
  final List<List<bool>> buttonStates;

  const RiskChallengeState({
    this.timerSeconds = 120,
    this.isTimerRunning = false,
    this.isTimerPaused = false,
    this.team1Score = 0,
    this.team2Score = 0,
    this.buttonStates = const [
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false],
      [false, false, false, false],
    ],
  });

  RiskChallengeState copyWith({
    int? timerSeconds,
    bool? isTimerRunning,
    bool? isTimerPaused,
    int? team1Score,
    int? team2Score,
    List<List<bool>>? buttonStates,
  }) {
    return RiskChallengeState(
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      isTimerPaused: isTimerPaused ?? this.isTimerPaused,
      team1Score: team1Score ?? this.team1Score,
      team2Score: team2Score ?? this.team2Score,
      buttonStates: buttonStates ?? this.buttonStates,
    );
  }
}

class RiskChallengeNotifier extends StateNotifier<RiskChallengeState> {
  RiskChallengeNotifier() : super(const RiskChallengeState());

  void startTimer() {
    state = state.copyWith(isTimerRunning: true, isTimerPaused: false);
  }

  void pauseTimer() {
    state = state.copyWith(isTimerRunning: false, isTimerPaused: true);
  }

  void resetTimer() {
    state = state.copyWith(isTimerRunning: false, isTimerPaused: false);
  }

  void addScore(int team, int points) {
    if (team == 1) {
      state = state.copyWith(team1Score: state.team1Score + points);
    } else {
      state = state.copyWith(team2Score: state.team2Score + points);
    }
  }

  void toggleButton(int categoryIndex, int buttonIndex) {
    final newButtonStates =
    state.buttonStates.map((category) => List<bool>.from(category)).toList();
    newButtonStates[categoryIndex][buttonIndex] =
    !newButtonStates[categoryIndex][buttonIndex];
    state = state.copyWith(buttonStates: newButtonStates);
  }

  void resetScores() {
    state = state.copyWith(
      team1Score: 0,
      team2Score: 0,
      buttonStates: List.generate(4, (_) => [false, false, false, false]),
    );
  }
}

final riskChallengeProvider =
StateNotifierProvider<RiskChallengeNotifier, RiskChallengeState>((ref) {
  return RiskChallengeNotifier();
});
