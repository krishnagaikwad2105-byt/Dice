import 'package:flutter/material.dart';

class RulesDialog extends StatelessWidget {
  const RulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF221108),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 650),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "चंपाळ पाणी — Guide & Rules",
                    style: TextStyle(
                      color: Color(0xFFF7D070),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Color(0xFFF7D070)),
                  ),
                ],
              ),
              const Divider(color: Color(0x44D4AF37)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        "🎯 Objective",
                        "Be the first player to guide all 4 pawns (सोंगट्या) through the outer perimeter, navigate the inner 'पाणी' stream, and safely enter the center Swarga (स्वर्ग)!",
                      ),
                      _buildSection(
                        "🎲 Traditional Casting Pieces (कवड्या, खडे, काठ्या, चिंचोके)",
                        "You can choose your casting piece from the selector:\n• ⚪ White Stones (पांढरे खडे)\n• ⚫ Black Stones (काळे खडे)\n• 🪵 Sticks (काठ्या / Dala)\n• 🌰 Tamarind Seeds (चिंचोके)\n• 🐚 Cowrie Shells (कवड्या)\n\nScoring Rules:\n• 1 Marked face: Move 1 space\n• 2 Marked faces: Move 2 spaces\n• 3 Marked faces: Move 3 spaces\n• 4 Marked faces: Move 4 spaces + Extra Roll!\n• 0 Marked faces (All closed): Move 8 spaces (चंपाळ!) + Extra Roll!",
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0x332EC4B6),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF2EC4B6)),
                        ),
                        child: _buildSection(
                          "🌊 The Sacred 'Pani' Rule (पाण्यात जाणे)",
                          "Pawns travel counter-clockwise around the outer ring. To enter the inner track ('पाणी') toward Swarga, you MUST capture ('kill') at least one opponent pawn! Until then, pawns must circle the outer ring.",
                          isHighlight: true,
                        ),
                      ),
                      _buildSection(
                        "⚔️ Safe Sanctuaries & Captures",
                        "• Safe Squares (✕): Marked starting squares and center Swarga are safe from captures.\n• Capturing: Landing on an opponent pawn on an unmarked square captures it, sends it to base, and gives you an extra roll!",
                      ),
                      _buildSection(
                        "🏆 Entering Swarga",
                        "An exact roll is required to step into Swarga (Center Home).",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isHighlight ? const Color(0xFF5CF0E2) : const Color(0xFFF7D070),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            body,
            style: const TextStyle(
              color: Color(0xFFC9B9A6),
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
