SKILLS.md - Standard Operating Procedures

⚡ Skill: Create New Feature

Trigger: "Create the [Name] feature" (e.g., "Create the Goals feature").

Steps:

Scaffold Folder: Create lib/features/[name]/ with subfolders data, domain, presentation.

Domain Layer:

Create domain/entities/[name].dart (Freezed class or simple Dart class).

Create domain/repositories/[name]_repository.dart (Abstract class).

Data Layer:

Create data/repositories/[name]_repository_impl.dart (Implements domain repo).

Create data/datasources/[name]_remote_source.dart (Dio calls).

Presentation Layer:

Create presentation/providers/[name]_provider.dart (Riverpod Notifier).

Create presentation/screens/[name]_screen.dart (ConsumerWidget).

Routing: Register the new screen in lib/core/router/app_router.dart.

⚡ Skill: Run Code Generation

Trigger: "Fix missing generated files", "Update models", or after creating a @freezed class.

Steps:

Check if build_runner is running.

Run command: dart run build_runner build --delete-conflicting-outputs

Restart analysis server if errors persist.

⚡ Skill: Integrate API Endpoint

Trigger: "Connect to the backend endpoint X".

Steps:

DTO: Create a Data Transfer Object in data/models (using json_serializable).

Mapper: Create a method toDomain() in the DTO to convert it to a Domain Entity.

Repository: Call the API in data/repositories, catch DioException, and return Either<Failure, Entity>.

Provider: Update the Riverpod provider to call the repository method.

⚡ Skill: Safe UI State Handling

Trigger: "Show a loading spinner" or "Handle errors".

Steps:

In the build method of ConsumerWidget:

final state = ref.watch(myProvider);
return state.when(
  data: (data) => MyContent(data),
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (err, stack) => ErrorView(message: err.toString()),
);
