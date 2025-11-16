# Parenting Quiz Learning App (Flutter)

[简体中文](./README.md) | English

A lightweight “learn-by-quizzing” app for new parents and parents-to-be. It offers staged knowledge aligned with child development, bite-sized daily practice, instant feedback with explanations, and review via a personal wrong-question notebook.

> Platform strategy: We currently focus on the iOS experience and release first, while keeping the codebase cross-platform and avoiding iOS-only APIs. If platform-specific code is necessary, we’ll provide fallbacks or graceful degradation.

> Ownership & License: The project is owned by `sealday <sealday@gmail.com>` and released under Apache-2.0.

## Features
- Stages: 0–6 months, 6–12 months, 1–3 years
- Question set: Single/Multi choice; fields include question, options, answer(s), explanation, stage and category tags (nutrition/sleep/motor/cognition/social, etc.)
- Practice: random questions, progress indicator, instant result + explanation, practical tips
- Wrong Questions: automatically collected, view details and remove items
- Stats: per-stage completion with progress bars and a pie chart overview
- Persistence: local storage for progress, wrong questions and daily practice count

## Tech Stack
- Flutter 3 (multi-platform)
- Lightweight state with `StatefulWidget`
- Local storage: `shared_preferences`
- Charts: `fl_chart`

## Project Structure
```
lib/
  main.dart
  models/
    question.dart
    stage.dart
  services/
    question_service.dart    # loads assets/questions.json
    storage_service.dart     # local persistence for progress/wrongs/daily
  screens/
    home_screen.dart
    quiz_screen.dart
    result_screen.dart
    stats_screen.dart
    wrong_questions_screen.dart
    quiz_detail_screen.dart
assets/
  questions.json
```

## Run & Develop
1) Install dependencies
```bash
cd /Users/seal/Documents/projects/flutter-demo/flutter_application_1
flutter pub get
```

2) Run on a device/simulator
```bash
flutter run
```
Common:
```bash
flutter devices
flutter run -d "iPhone 15"
```

3) iOS (first time or after adding plugins)
```bash
cd ios && pod install && cd ..
flutter clean
flutter pub get
flutter run
```
Note: MissingPluginException often happens when using hot reload after adding a new plugin. Do a full rebuild (clean + run).

## Extend Question Bank
- File: `assets/questions.json`
- Declared in `pubspec.yaml`:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/questions.json
```
- JSON example:
```json
{
  "id": 1,
  "stage": "0-6个月",
  "question": "宝宝多大开始翻身？",
  "options": ["1个月", "3个月", "6个月", "9个月"],
  "answer": "3个月",
  "explanation": "一般宝宝在3个月左右开始尝试翻身...",
  "tip": "清醒时做俯卧练习，逐步延长时间",
  "category": "运动"
}
```
Notes:
- For multi-choice, separate answers with commas: `"answer": "A,B"`
- Optional field: `tip`
- The `stage` must match `ageRange` in `stage.dart` (`"0-6个月"`, `"6个月-1岁"`, `"1-3岁"`).

## Done
- [x] Staged selection and question loading
- [x] Single/Multi choice with instant feedback & explanation
- [x] Result page with score and per-question analysis
- [x] Wrong questions notebook (view/remove)
- [x] Stats: stage progress + pie chart
- [x] Local persistence (progress, wrongs, daily count)

## Developer Notes
- Lints: `flutter_lints`
- Storage keys are centralized in `storage_service.dart`
- UI uses warm, friendly palette targeting parents

## Roadmap
Short term:
- [ ] Search & practice by category (nutrition/sleep/motor/cognition/social)
- [ ] Daily tasks / badges
- [ ] Export wrong questions & share summary cards

Mid/Long term (AI & Community):
- [ ] AI-generated question bank from authoritative materials with human review
+- [ ] Community discussions under questions, experience sharing
+- [ ] “Frequently wrong” mining: identify high-error items and build focused practice
+- [ ] Question quality scoring via feedback, correctness, expert review
+- [ ] “Invalid/controversial questions” workflow: appeals, quick removal & revision
+- [ ] Multi-device sync and user accounts (login/cloud progress)

## Contributing
PRs are welcome:
- Bug fixes, performance, UI/wording improvements
- New questions & explanations (cite sources)
- New feature proposals aligning with the roadmap

## License
Apache License 2.0
- Copyright © 2025 `sealday <sealday@gmail.com>`
- See `LICENSE` at the repo root for the full text
- By contributing, you agree to license your contribution under Apache-2.0

---
Flutter docs:
- <https://docs.flutter.dev/>
- <https://docs.flutter.dev/cookbook>

