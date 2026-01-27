RULES.md - Flutter Strict Constraints

🛡️ 1. State Management Rules (Riverpod)

NO setState: Never use setState for business logic or complex UI states. Use ConsumerWidget.

NO GetX: Strictly forbidden.

Provider Definition: Use @riverpod annotation syntax for all new providers.

// GOOD
@riverpod
class MyNotifier extends _$MyNotifier { ... }


Async Handling: Always handle AsyncValue (loading, error, data) in the UI using .when().

🛡️ 2. Architecture Rules (Feature-First)

Dependency Rule: Domain layer must NOT depend on Data or Presentation.

Data Flow: UI calls -> Controller (Provider) -> UseCase/Repository -> Data Source.

Files:

Logic goes in presentation/providers.

UI goes in presentation/screens or presentation/widgets.

API calls go in data/repositories.

🛡️ 3. UI & Styling Rules

Theming: NEVER hardcode hex colors (e.g., Color(0xFF0000)). Use Theme.of(context).colorScheme.primary.

Typography: Use Theme.of(context).textTheme....

Responsive: Avoid fixed widths/heights where possible. Use Expanded, Flexible, or relative spacing.

Structure: Extract complex widget trees into smaller, private classes (_HeaderSection) or separate files if reused.

🛡️ 4. Code Quality

Linter: Fix all linter warnings immediately.

Imports: Use absolute imports for project files: import 'package:wealthscope/features/...'.

Const: Use const constructors everywhere possible to optimize rebuilds.