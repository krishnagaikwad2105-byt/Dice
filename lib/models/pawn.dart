/// Represents an individual pawn (सोंगटी) belonging to a player
class Pawn {
  final int id;
  int stepIndex; // 0..24
  bool isHome;   // Reached Swarga (Center Home)

  Pawn({
    required this.id,
    this.stepIndex = 0,
    this.isHome = false,
  });

  void reset() {
    stepIndex = 0;
    isHome = false;
  }
}
