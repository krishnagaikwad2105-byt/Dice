import 'package:flutter/material.dart';
import '../i18n/localization_service.dart';
import '../theme/game_theme.dart';

class RulesDialog extends StatelessWidget {
  final GameTheme theme;

  const RulesDialog({
    super.key,
    this.theme = GameTheme.cleanMinimal,
  });

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.instance;

    return Dialog(
      backgroundColor: theme.surfaceBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.cardBorder, width: 1.5),
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
                  Expanded(
                    child: Text(
                      loc.t('rulesTitle'),
                      style: TextStyle(
                        color: theme.textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: theme.textSecondaryColor),
                  ),
                ],
              ),
              Divider(color: theme.dividerColor),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        loc.t('ruleObjectiveTitle'),
                        loc.t('ruleObjectiveBody'),
                      ),
                      _buildSection(
                        loc.t('rulePiecesTitle'),
                        loc.t('rulePiecesBody'),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.cellPaniBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.cellPaniBorder),
                        ),
                        child: _buildSection(
                          loc.t('rulePaniTitle'),
                          loc.t('rulePaniBody'),
                          isHighlight: true,
                        ),
                      ),
                      _buildSection(
                        loc.t('ruleSafeTitle'),
                        loc.t('ruleSafeBody'),
                      ),
                      _buildSection(
                        loc.t('ruleSwargaTitle'),
                        loc.t('ruleSwargaBody'),
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
              color: isHighlight ? theme.cellPaniTextColor : theme.accentGold,
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: TextStyle(
              color: theme.textColor.withValues(alpha: 0.85),
              fontSize: 12.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
