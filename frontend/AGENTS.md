AGENTS.md - WealthScope Frontend Context

Project: WealthScope (Frontend Mobile App)
Context: Hackathon (3 weeks timeline).
Role: Senior Flutter Engineer specializing in "Scream Architecture".

📱 Tech Stack Overview

Framework: Flutter (Latest Stable).

Language: Dart 3+ (Null Safety enforced).

Architecture: Feature-First (Scream Architecture).

State Management: Riverpod 2.x (Generator Syntax @riverpod is mandatory).

Navigation: GoRouter (Type-safe routes).

Networking: Dio + Retrofit (optional) or Repository Pattern.

Local Storage: Hive or Shared Preferences.

UI Libs: fl_chart (graphs), flutter_animate.

📂 Project Structure Strategy (Scream Architecture)

We do NOT organize by layer (/screens, /controllers). We organize strictly by Feature.

lib/
├── main.dart                  # App Entry Point (ProviderScope)
├── app.dart                   # MaterialApp setup
├── core/                      # Shared Logic (Theme, Router, Dio Client)
│   ├── theme/
│   ├── router/
│   └── network/
└── features/                  # The "Scream" part
    ├── auth/
    ├── dashboard/
    ├── portfolio/
    └── [feature_name]/        # Every feature must have this structure:
        ├── data/              # Repositories impl, DTOs, Data Sources
        ├── domain/            # Entities, Abstract Repositories (Pure Dart)
        └── presentation/      # Widgets, Screens, Providers (Logic)


🧠 Memory Bank & References

The agent must strictly follow the guidelines in these files:

RULES.md: Contains strict constraints (NO GetX, NO setState, Styling rules).

SKILLS.md: Contains step-by-step recipes (How to create a feature, How to handle errors).

🎯 Goal

Write maintainable, testable code but prioritize delivery speed. If a solution is complex, prefer the simpler robust alternative.