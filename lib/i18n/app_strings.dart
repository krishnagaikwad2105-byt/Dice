import 'localization_service.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _translations = {
    // App & Navigation
    'appName': {
      'en': 'Champal Pani',
      'hi': 'चंपाळ पाणी',
      'mr': 'चंपाळ पाणी',
    },
    'appSubtitle': {
      'en': 'Traditional 5x5 Board Game',
      'hi': 'पारंपरिक 5x5 बोर्ड गेम',
      'mr': 'पारंपारिक ५x५ पट खेळ',
    },
    'newGame': {
      'en': 'New Game',
      'hi': 'नया खेल',
      'mr': 'नवीन खेळ',
    },
    'newGameSetup': {
      'en': 'New Game Setup',
      'hi': 'नए खेल की तैयारी',
      'mr': 'नवीन खेळाची मांडणी',
    },
    'gameMode': {
      'en': 'Game Mode',
      'hi': 'खेल का प्रकार',
      'mr': 'खेळाचा प्रकार',
    },
    'vsAI': {
      'en': 'You vs AI Bots',
      'hi': 'आप बनाम एआई बॉट',
      'mr': 'तुम्ही विरुद्ध एआय बॉट',
    },
    'passAndPlay': {
      'en': 'Pass & Play (Local)',
      'hi': 'पास एंड प्ले (स्थानीय)',
      'mr': 'पास आणि खेळा (स्थानिक)',
    },
    'numberOfPlayers': {
      'en': 'Number of Players',
      'hi': 'खिलाड़ियों की संख्या',
      'mr': 'खेळाडूंची संख्या',
    },
    'twoPlayers': {
      'en': '2 Players (South vs North)',
      'hi': '2 खिलाड़ी (दक्षिण बनाम उत्तर)',
      'mr': '२ खेळाडू (दक्षिण विरुद्ध उत्तर)',
    },
    'threePlayers': {
      'en': '3 Players',
      'hi': '3 खिलाड़ी',
      'mr': '३ खेळाडू',
    },
    'fourPlayers': {
      'en': '4 Players (Full Board)',
      'hi': '4 खिलाड़ी (पूरा बोर्ड)',
      'mr': '४ खेळाडू (पूर्ण पट)',
    },
    'startMatch': {
      'en': 'Start Match',
      'hi': 'खेल शुरू करें',
      'mr': 'सामना सुरू करा',
    },
    'cancel': {
      'en': 'Cancel',
      'hi': 'रद्द करें',
      'mr': 'रद्द करा',
    },
    'rulesAndGuide': {
      'en': 'Rules & Guide',
      'hi': 'नियम और मार्गदर्शिका',
      'mr': 'नियम व मार्गदर्शक',
    },
    'rulesTitle': {
      'en': 'Champal Pani — Guide & Rules',
      'hi': 'चंपाळ पाणी — नियम और मार्गदर्शिका',
      'mr': 'चंपाळ पाणी — नियम व मार्गदर्शक',
    },
    'changeTheme': {
      'en': 'Change Theme',
      'hi': 'थीम बदलें',
      'mr': 'थीम बदला',
    },
    'themeSelectorTitle': {
      'en': 'Select Visual Theme',
      'hi': 'थीम का चयन करें',
      'mr': 'थीम निवडा',
    },
    'done': {
      'en': 'Done',
      'hi': 'पूर्ण',
      'mr': 'पूर्ण',
    },
    'boardAndToss': {
      'en': 'Board & Toss',
      'hi': 'बोर्ड और टॉस',
      'mr': 'पट आणि फेक',
    },
    'kingdoms': {
      'en': 'Kingdoms',
      'hi': 'साम्राज्य',
      'mr': 'साम्राज्य',
    },
    'chronicle': {
      'en': 'Chronicle',
      'hi': 'इतिहास',
      'mr': 'इतिहास',
    },
    'gameHistory': {
      'en': 'Game History',
      'hi': 'खेल का इतिहास',
      'mr': 'खेळाचा इतिहास',
    },
    'liveChronicle': {
      'en': 'Live Chronicle',
      'hi': 'लाइव विवरण',
      'mr': 'थेट घडामोडी',
    },
    'piecesAndCasting': {
      'en': 'Pieces & Casts',
      'hi': 'मोहरे व पासे',
      'mr': 'सोंगट्या व फासे',
    },
    'piecesSubtitle': {
      'en': 'Traditional Maharashtrian Board Tokens',
      'hi': 'पारंपरिक भारतीय मोहरे व पासे',
      'mr': 'पारंपारिक महाराष्ट्रीयन सोंगट्या व फासे',
    },
    'swargaHome': {
      'en': 'SWARGA\nHOME',
      'hi': 'स्वर्ग\nघर',
      'mr': 'स्वर्ग\nघर',
    },
    'paniStream': {
      'en': '≈ PANI ≈',
      'hi': '≈ पानी ≈',
      'mr': '≈ पाणी ≈',
    },
    'kills': {
      'en': 'Kills',
      'hi': 'शिकार',
      'mr': 'बळी',
    },
    'base': {
      'en': 'Base',
      'hi': 'बेस',
      'mr': 'मूळ',
    },
    'field': {
      'en': 'Field',
      'hi': 'मैदान',
      'mr': 'पट',
    },
    'home': {
      'en': 'Home',
      'hi': 'घर',
      'mr': 'स्वर्ग',
    },
    'paniUnlocked': {
      'en': 'PANI',
      'hi': 'पानी खुला',
      'mr': 'पाणी खुले',
    },
    'noPani': {
      'en': 'NO PANI',
      'hi': 'बिना पानी',
      'mr': 'पाणी नाही',
    },
    'you': {
      'en': 'You',
      'hi': 'आप',
      'mr': 'तुम्ही',
    },
    'bot': {
      'en': 'Bot',
      'hi': 'बॉट',
      'mr': 'बॉट',
    },
    'turnRoll': {
      'en': 'Your turn to roll',
      'hi': 'पासा फेंकने की आपकी बारी',
      'mr': 'फासे टाकण्याची तुमची पाळी',
    },
    'turnSelectPawn': {
      'en': 'Select a glowing pawn',
      'hi': 'चमकती गोटी चुनें',
      'mr': 'चमकणारी सोंगटी निवडा',
    },
    'botThinking': {
      'en': 'Thinking...',
      'hi': 'सोच रहा है...',
      'mr': 'विचार करत आहे...',
    },
    'rolled': {
      'en': 'Rolled',
      'hi': 'आया',
      'mr': 'पडले',
    },
    'bonusRoll': {
      'en': 'BONUS ROLL',
      'hi': 'बोनस रोल',
      'mr': 'बोनस फेक',
    },
    'champalBonus': {
      'en': '8 (Champal!) BONUS ROLL',
      'hi': '8 (चंपाळ!) बोनस रोल',
      'mr': '८ (चंपाळ!) बोनस फेक',
    },
    'challasBonus': {
      'en': '4 (Challas!) BONUS ROLL',
      'hi': '4 (चल्लास!) बोनस रोल',
      'mr': '४ (चल्लास!) बोनस फेक',
    },
    'tossAction': {
      'en': 'Toss',
      'hi': 'फेंकें',
      'mr': 'टाका',
    },
    'tossingAction': {
      'en': 'Tossing...',
      'hi': 'फेंक रहे हैं...',
      'mr': 'टाकत आहे...',
    },
    'tapPawnPrompt': {
      'en': 'Tap a Glowing Pawn',
      'hi': 'चमकती गोटी पर टैप करें',
      'mr': 'चमकणाऱ्या सोंगटीवर टॅप करा',
    },
    'gameOver': {
      'en': 'Game Over',
      'hi': 'खेल समाप्त',
      'mr': 'खेळ समाप्त',
    },
    'victoryTitle': {
      'en': 'VICTORY!',
      'hi': 'विजयरथ! विजय!',
      'mr': 'विजयरथ! विजय!',
    },
    'wonTheGame': {
      'en': 'Won the Game!',
      'hi': 'ने खेल जीत लिया!',
      'mr': 'खेळ जिंकला!',
    },
    'allPawnsSwarga': {
      'en': 'All 4 pawns safely reached Swarga!',
      'hi': 'सभी 4 गोटियाँ स्वर्ग पहुँच गईं!',
      'mr': 'सर्व ४ सोंगट्या स्वर्गात पोहोचल्या!',
    },
    'playAgain': {
      'en': 'Play Again',
      'hi': 'फिर से खेलें',
      'mr': 'पुन्हा खेळा',
    },
    'language': {
      'en': 'Language',
      'hi': 'भाषा',
      'mr': 'भाषा',
    },
    'selectLanguage': {
      'en': 'Select Language',
      'hi': 'भाषा चुनें',
      'mr': 'भाषा निवडा',
    },
    // Sides
    'south': {
      'en': 'South',
      'hi': 'दक्षिण',
      'mr': 'दक्षिण',
    },
    'west': {
      'en': 'West',
      'hi': 'पश्चिम',
      'mr': 'पश्चिम',
    },
    'north': {
      'en': 'North',
      'hi': 'उत्तर',
      'mr': 'उत्तर',
    },
    'east': {
      'en': 'East',
      'hi': 'पूर्व',
      'mr': 'पूर्व',
    },
    // Pieces
    'whiteStone': {
      'en': 'White Stones',
      'hi': 'सफेद कंकड़',
      'mr': 'पांढरे खडे',
    },
    'blackStone': {
      'en': 'Black Stones',
      'hi': 'काले कंकड़',
      'mr': 'काळे खडे',
    },
    'sticks': {
      'en': 'Sticks',
      'hi': 'लकड़ी की तीलियाँ',
      'mr': 'काठ्या',
    },
    'tamarindSeeds': {
      'en': 'Tamarind Seeds',
      'hi': 'इमली के बीज',
      'mr': 'चिंचोके',
    },
    'cowrieShells': {
      'en': 'Cowrie Shells',
      'hi': 'कौड़ियां',
      'mr': 'कवड्या',
    },
    // Scoring & Guide Text
    'scoringGuideTitle': {
      'en': 'Traditional Casts & Tokens',
      'hi': 'पारंपरिक पासे व सोंगट्या',
      'mr': 'पारंपारिक फासे व सोंगट्या',
    },
    'scoringGuideContent': {
      'en': '• ⚪ White Stones: Ivory river stones\n• ⚫ Black Stones: Obsidian basalt stones\n• 🪵 Sticks: Carved daayam sticks\n• 🌰 Tamarind Seeds: Split tamarind seeds\n• 🐚 Cowrie Shells: Traditional kavadis\n• 🌟 8 = Champal Bonus Roll!\n• 🌟 4 = Challas Bonus Roll!',
      'hi': '• ⚪ सफेद कंकड़: चिकने नदी के पत्थर\n• ⚫ काले कंकड़: बेसाल्ट पत्थर\n• 🪵 तीलियाँ: लकड़ी के पासे\n• 🌰 चिंचोके: इमली के दोफाड़ बीज\n• 🐚 कौड़ियां: पारंपरिक कवडियाँ\n• 🌟 8 = चंपाळ बोनस रोल!\n• 🌟 4 = चल्लास बोनस रोल!',
      'mr': '• ⚪ पांढरे खडे: गुळगुळीत नदीचे खडे\n• ⚫ काळे खडे: काळ्या पाषाणाचे खडे\n• 🪵 काठ्या: कोरीव लाकडी दाया\n• 🌰 चिंचोके: अर्धे कापलेले चिंचोके\n• 🐚 कवड्या: पारंपारिक कवड्या\n• 🌟 ८ = चंपाळ बोनस फेक!\n• 🌟 ४ = चल्लास बोनस फेक!',
    },
    // Rules Sections
    'ruleObjectiveTitle': {
      'en': '🎯 Objective',
      'hi': '🎯 खेल का उद्देश्य',
      'mr': '🎯 खेळाचे उद्दिष्ट',
    },
    'ruleObjectiveBody': {
      'en': 'Be the first player to guide all 4 pawns through the outer perimeter, navigate the inner "Pani" stream, and safely enter the center Swarga (Heaven)!',
      'hi': 'सभी 4 गोटियों को बाहरी परिधि से ले जाकर, भीतरी "पानी" धारा को पार कर, सबसे पहले केंद्र स्वर्ग में सुरक्षित पहुँचाएँ!',
      'mr': 'आपल्या सर्व ४ सोंगट्यांना बाहेरील फेरी पूर्ण करून, आतील "पाणी" प्रवाहात नेऊन, मध्यभागी असलेल्या स्वर्गात सर्वात आधी पोहोचवणे हे उद्दिष्ट आहे!',
    },
    'rulePiecesTitle': {
      'en': '🎲 Traditional Casting Pieces (Stones, Sticks, Seeds, Cowries)',
      'hi': '🎲 पारंपरिक पासे (कंकड़, तीलियाँ, चिंचोके, कवडियाँ)',
      'mr': '🎲 पारंपारिक फासे (खडे, काठ्या, चिंचोके, कवड्या)',
    },
    'rulePiecesBody': {
      'en': 'Select your preferred piece from the selector bar.\n\nScoring Rules:\n• 1 Marked face: Move 1 space\n• 2 Marked faces: Move 2 spaces\n• 3 Marked faces: Move 3 spaces\n• 4 Marked faces: Move 4 spaces + Extra Roll!\n• 0 Marked faces (All closed): Move 8 spaces (Champal!) + Extra Roll!',
      'hi': 'पसंदीदा पासा ऊपर दिए गए चयनकर्ता से चुनें।\n\nअंक नियम:\n• 1 खुला मुख: 1 कदम आगे बढ़ें\n• 2 खुले मुख: 2 कदम आगे बढ़ें\n• 3 खुले मुख: 3 कदम आगे बढ़ें\n• 4 खुले मुख: 4 कदम + अतिरिक्त रोल!\n• 0 खुला मुख (सभी बंद): 8 कदम (चंपाळ!) + अतिरिक्त रोल!',
      'mr': 'वर दिलेल्या पट्टीवरून तुमचा आवडता फासा निवडा.\n\nगुणांचे नियम:\n• १ उघडा चेहरा: १ घर पुढे जा\n• २ उघडे चेहरे: २ घरे पुढे जा\n• ३ उघडे चेहरे: ३ घरे पुढे जा\n• ४ उघडे चेहरे: ४ घरे + जादा फेक!\n• ० उघडा चेहरा (सर्व बंद): ८ घरे (चंपाळ!) + जादा फेक!',
    },
    'rulePaniTitle': {
      'en': '🌊 The Sacred "Pani" Rule (Entering the Water)',
      'hi': '🌊 पावन "पानी" का नियम (भीतरी जलधारा में प्रवेश)',
      'mr': '🌊 "पाणी" चा पवित्र नियम (पाण्यात जाणे)',
    },
    'rulePaniBody': {
      'en': 'Pawns travel counter-clockwise around the outer 16 squares. To enter the inner stream ("Pani") towards Swarga, you MUST capture ("kill") at least one opponent pawn! Until then, pawns continue circling the outer track.',
      'hi': 'गोटियाँ बाहरी 16 चौखानों में वामावर्त (एंटी-क्लॉकवाइज) चलती हैं। स्वर्ग की ओर जाने वाली भीतरी जलधारा ("पानी") में प्रवेश करने के लिए, आपको कम से कम एक विरोधी गोटी का शिकार ("किल") करना अनिवार्य है! तब तक गोटियाँ बाहरी परिधि में ही घूमती रहेंगी।',
      'mr': 'सोंगट्या बाहेरील १६ घरांमध्ये घड्याळाच्या उलट दिशेने फिरतात. स्वर्गाकडे जाणाऱ्या आतील प्रवाहात ("पाण्यात जाणे") प्रवेश करण्यासाठी, किमान एका विरोधी सोंगटीचा बळी घेणे ("मारणे") बंधनकारक आहे! तोपर्यंत सोंगट्या बाहेरील फेरीतच फिरत राहतात.',
    },
    'ruleSafeTitle': {
      'en': '⚔️ Safe Sanctuaries & Captures',
      'hi': '⚔️ सुरक्षित घर व शिकार',
      'mr': '⚔️ सुरक्षित घरे व सोंगटी मारणे',
    },
    'ruleSafeBody': {
      'en': '• Safe Squares (✕): Marked starting sanctuaries and center Swarga are safe from capture.\n• Capturing: Landing on an opponent pawn on an unmarked square captures it, sends it back to base, and awards you an extra roll!',
      'hi': '• सुरक्षित चौखाने (✕): क्रॉस (✕) से चिह्नित प्रारंभिक घर और केंद्र स्वर्ग सुरक्षित हैं, यहाँ कोई गोटी मारी नहीं जा सकती।\n• शिकार: बिना निशान वाले चौखाने पर विरोधी गोटी पर उतरने से वह मारी जाती है, वापस बेस पर जाती है और आपको एक अतिरिक्त रोल मिलता है!',
      'mr': '• सुरक्षित घरे (✕): फुलीने (✕) चिन्हांकित केलेली सुरुवातीची घरे आणि मध्य स्वर्ग सुरक्षित असतात, तिथे सोंगटी मारता येत नाही.\n• सोंगटी मारणे: साध्या घरावर विरोधी सोंगटीवर उतरल्यास ती मारली जाते, तिच्या मूळ घरात परत पाठवली जाते आणि तुम्हाला जादा फेक मिळते!',
    },
    'ruleSwargaTitle': {
      'en': '🏆 Entering Swarga (Center Home)',
      'hi': '🏆 स्वर्ग में प्रवेश',
      'mr': '🏆 स्वर्गात प्रवेश',
    },
    'ruleSwargaBody': {
      'en': 'An exact roll is required to step into Swarga (Center Home). For example, from step 23, only a roll of 1 can enter.',
      'hi': 'स्वर्ग (केंद्र) में प्रवेश के लिए सटीक रोल आवश्यक है। उदाहरण के लिए, 23वें कदम से केवल 1 आने पर ही प्रवेश संभव है।',
      'mr': 'मध्यवर्ती स्वर्गात जाण्यासाठी अचूक गुणांची आवश्यकता असते. उदाहरणार्थ, २३ व्या घरावर असताना फक्त १ पडल्यावरच स्वर्गात जाता येते.',
    },
    // Log entries
    'logNewGame': {
      'en': '🎉 New game started with {count} players!',
      'hi': '🎉 {count} खिलाड़ियों के साथ नया खेल शुरू हुआ!',
      'mr': '🎉 {count} खेळाडूंसह नवीन खेळ सुरू झाला!',
    },
    'logRolled': {
      'en': '{player} rolled {roll}{bonus}',
      'hi': '{player} का {roll} आया{bonus}',
      'mr': '{player} ला {roll} पडले{bonus}',
    },
    'logBonusSuffix': {
      'en': ' 🌟 Bonus Roll!',
      'hi': ' 🌟 बोनस रोल!',
      'mr': ' 🌟 बोनस फेक!',
    },
    'logNoMoves': {
      'en': '❌ No valid moves for {player} with roll {roll}.',
      'hi': '❌ {player} के पास {roll} के लिए कोई वैध चाल नहीं।',
      'mr': '❌ {player} साठी {roll} सह कोणतीही वैध चाल नाही.',
    },
    'logCaptured': {
      'en': '⚔️ {killer} captured {victim}\'s pawn! Sent back to base!',
      'hi': '⚔️ {killer} ने {victim} की गोटी का शिकार किया! बेस पर वापस भेजा गया!',
      'mr': '⚔️ {killer} ने {victim} ची सोंगटी मारली! मूळ घरात परत पाठवली!',
    },
    'logUnlockedPani': {
      'en': '🌊 {player} unlocked PANI! Eligible for the inner track!',
      'hi': '🌊 {player} का पानी खुल गया! अब भीतरी धारा में जाने की पात्रता मिली!',
      'mr': '🌊 {player} चे पाणी उघडले! आता आतील प्रवाहात जाण्यास पात्र!',
    },
    'logReachedSwarga': {
      'en': '🏆 {player}\'s pawn reached Center Home (Swarga)!',
      'hi': '🏆 {player} की गोटी स्वर्ग (केंद्र) पहुँच गई!',
      'mr': '🏆 {player} ची सोंगटी स्वर्गात पोहोचली!',
    },
    'logEarnedExtraRoll': {
      'en': '✨ {player} earns an Extra Roll!',
      'hi': '✨ {player} को एक अतिरिक्त रोल मिला!',
      'mr': '✨ {player} ला जादा फेक मिळाली!',
    },
    'logWonGame': {
      'en': '👑🎊 {player} HAS WON THE GAME! 🎊👑',
      'hi': '👑🎊 {player} ने खेल जीत लिया! 🎊👑',
      'mr': '👑🎊 {player} ने खेळ जिंकला! 🎊👑',
    },
  };

  static String get(AppLanguage lang, String key, [Map<String, String>? params]) {
    final entry = _translations[key];
    String text;
    if (entry != null && entry.containsKey(lang.code)) {
      text = entry[lang.code]!;
    } else if (entry != null && entry.containsKey('en')) {
      text = entry['en']!; // Fallback to English
    } else {
      text = key; // Fallback to key itself
    }

    if (params != null) {
      params.forEach((paramKey, paramVal) {
        text = text.replaceAll('{$paramKey}', paramVal);
      });
    }

    return text;
  }
}
