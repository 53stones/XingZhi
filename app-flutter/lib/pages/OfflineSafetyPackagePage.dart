import 'package:flutter/material.dart';

class OfflineSafetyPackagePage extends StatefulWidget {
  const OfflineSafetyPackagePage({
    required this.isDayMode,
    super.key,
  });

  final bool isDayMode;

  @override
  State<OfflineSafetyPackagePage> createState() =>
      _OfflineSafetyPackagePageState();
}

class _OfflineSafetyPackagePageState extends State<OfflineSafetyPackagePage> {
  int _selectedIndex = 0;
  int? _selectedIssueIndex;

  static const List<OfflineSafetyCategory> _categories = [
    OfflineSafetyCategory(
      title: '运动损伤',
      icon: Icons.directions_run_rounded,
      issues: [
        OfflineSafetyIssue(
          title: '扭伤',
          summary: '常见于脚踝、膝盖、手腕，表现为疼痛、肿胀、活动受限。',
          steps: [
            '立即停止活动，避免继续负重。',
            '用冰袋或冷水毛巾冷敷，每次 15-20 分钟。',
            '用弹力绷带适度加压包扎，避免过紧。',
            '抬高受伤部位，减少肿胀。',
            '疼痛明显、无法行走或畸形时，尽快就医。',
          ],
        ),
        OfflineSafetyIssue(
          title: '拉伤',
          summary: '多发生在大腿、小腿、肩背部，常见于突然发力或运动过度。',
          steps: [
            '停止运动，避免继续拉伸受伤肌肉。',
            '前 24-48 小时以冷敷为主。',
            '不要立即热敷或按摩。',
            '疼痛减轻后再逐步恢复活动。',
          ],
        ),
        OfflineSafetyIssue(
          title: '骨折疑似',
          summary: '出现明显畸形、剧烈疼痛、无法活动时，应按骨折处理。',
          steps: [
            '不要强行复位或移动受伤部位。',
            '用木板、登山杖、硬纸板等固定上下两个关节。',
            '保持伤者安静，避免二次损伤。',
            '立即联系救援或就医。',
          ],
        ),
      ],
    ),
    OfflineSafetyCategory(
      title: '中毒',
      icon: Icons.warning_amber_rounded,
      issues: [
        OfflineSafetyIssue(
          title: '食物中毒',
          summary: '常见症状包括恶心、呕吐、腹痛、腹泻、发热。',
          steps: [
            '停止食用可疑食物。',
            '少量多次补充清水或口服补液盐。',
            '保留可疑食物或包装，方便医生判断。',
            '出现高热、血便、严重脱水、意识异常时立即就医。',
          ],
        ),
        OfflineSafetyIssue(
          title: '野果 / 野蘑菇中毒',
          summary: '误食野果、野蘑菇后可能出现呕吐、腹泻、幻觉、肝肾损伤。',
          steps: [
            '立即停止食用。',
            '不要自行催吐，尤其是意识不清者。',
            '保留剩余样本或拍照记录。',
            '尽快联系急救或前往医院。',
          ],
        ),
        OfflineSafetyIssue(
          title: '一氧化碳中毒',
          summary: '常见于帐篷、车内、封闭空间使用炉具时。',
          steps: [
            '立即离开封闭环境，到空气流通处。',
            '关闭炉具或远离污染源。',
            '保持呼吸道通畅。',
            '出现头痛、乏力、意识模糊时立即呼救。',
          ],
        ),
      ],
    ),
    OfflineSafetyCategory(
      title: '蚊虫叮咬',
      icon: Icons.bug_report_rounded,
      issues: [
        OfflineSafetyIssue(
          title: '普通蚊虫叮咬',
          summary: '表现为局部红肿、瘙痒、轻微疼痛。',
          steps: [
            '用清水清洗叮咬部位。',
            '避免抓挠，防止感染。',
            '可冷敷缓解肿胀和瘙痒。',
            '红肿扩大、流脓或发热时就医。',
          ],
        ),
        OfflineSafetyIssue(
          title: '蜂蜇',
          summary: '局部疼痛明显，少数人可能出现严重过敏。',
          steps: [
            '如果有毒刺残留，尽量刮除，不要用力挤压。',
            '清洗伤口并冷敷。',
            '观察是否出现呼吸困难、全身皮疹、头晕等过敏反应。',
            '出现严重过敏症状时立即呼救。',
          ],
        ),
        OfflineSafetyIssue(
          title: '蜱虫叮咬',
          summary: '蜱虫可能附着在皮肤上，不要直接拍打或硬拽。',
          steps: [
            '用镊子尽量贴近皮肤夹住蜱虫头部。',
            '平稳向外拔出，避免挤压虫体。',
            '取出后用碘伏消毒。',
            '记录叮咬时间，后续出现发热、皮疹、乏力时就医。',
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primaryText =
        widget.isDayMode ? const Color(0xFF1D140C) : Colors.white;
    final secondaryText =
        widget.isDayMode ? const Color(0xB21D140C) : _OfflineColors.soft;
    final selectedCategory = _categories[_selectedIndex];

    final selectedIssue = _selectedIssueIndex == null
        ? null
        : selectedCategory.issues[_selectedIssueIndex!];

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(primaryText),
          const SizedBox(height: 8),
          Text(
            '户外应急参考，严重情况请立即联系救援。',
            style: TextStyle(
              color: secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: _OfflineGlassPanel(
              isDayMode: widget.isDayMode,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    _buildLeftCategoryList(
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedCategory.title,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: selectedIssue == null
                                ? _buildIssueTitleList(
                                    selectedCategory: selectedCategory,
                                    primaryText: primaryText,
                                    secondaryText: secondaryText,
                                  )
                                : _buildIssueDetail(
                                    issue: selectedIssue,
                                    primaryText: primaryText,
                                    secondaryText: secondaryText,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primaryText) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: widget.isDayMode
                    ? const Color(0xFFFFF7E8)
                    : const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _OfflineColors.line),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: primaryText,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          '离线安全包',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildLeftCategoryList({
    required Color primaryText,
    required Color secondaryText,
  }) {
    return SizedBox(
      width: 35, // 调整左侧栏宽度
      child: ListView.separated(
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = index == _selectedIndex;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  _selectedIssueIndex = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? _OfflineColors.orange.withOpacity(0.18)
                      : widget.isDayMode
                          ? Colors.white.withOpacity(0.46)
                          : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? _OfflineColors.orange.withOpacity(0.65)
                        : widget.isDayMode
                            ? const Color(0x33D9A966)
                            : Colors.white.withOpacity(0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      category.icon,
                      color: selected ? _OfflineColors.orange : secondaryText,
                      size: 22,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected ? _OfflineColors.orange : primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIssueTitleList({
    required OfflineSafetyCategory selectedCategory,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return ListView.separated(
      itemCount: selectedCategory.issues.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final issue = selectedCategory.issues[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                _selectedIssueIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: widget.isDayMode
                    ? const Color(0xFFFFF3DE)
                    : Colors.black.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.isDayMode
                      ? const Color(0x44D9A966)
                      : Colors.white.withOpacity(0.08),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      issue.title,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: secondaryText,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIssueDetail({
    required OfflineSafetyIssue issue,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return ListView(
      children: [
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    _selectedIssueIndex = null;
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.isDayMode
                        ? const Color(0xFFFFF7E8)
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.isDayMode
                          ? const Color(0x44D9A966)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: primaryText,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                issue.title,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isDayMode
                ? const Color(0xFFFFF3DE)
                : Colors.black.withOpacity(0.18),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isDayMode
                  ? const Color(0x44D9A966)
                  : Colors.white.withOpacity(0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                issue.summary,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              for (var stepIndex = 0;
                  stepIndex < issue.steps.length;
                  stepIndex++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${stepIndex + 1}. ',
                        style: const TextStyle(
                          color: _OfflineColors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          issue.steps[stepIndex],
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 12,
                            height: 1.32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class OfflineSafetyCategory {
  const OfflineSafetyCategory({
    required this.title,
    required this.icon,
    required this.issues,
  });

  final String title;
  final IconData icon;
  final List<OfflineSafetyIssue> issues;
}

class OfflineSafetyIssue {
  const OfflineSafetyIssue({
    required this.title,
    required this.summary,
    required this.steps,
  });

  final String title;
  final String summary;
  final List<String> steps;
}

class _OfflineColors {
  static const green = Color(0xFFFFD36A);
  static const orange = Color(0xFFFF3F1F);
  static const soft = Color(0xE8F2F2F2);
  static const line = Color(0x5CE0E0E0);
}

class _OfflineGlassPanel extends StatelessWidget {
  const _OfflineGlassPanel({
    required this.child,
    required this.isDayMode,
  });

  final Widget child;
  final bool isDayMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDayMode
            ? const Color(0xEFFFF6E8)
            : Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDayMode
              ? const Color(0x66D9A966)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: child,
    );
  }
}