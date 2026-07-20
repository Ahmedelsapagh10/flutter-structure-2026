# Repository Guidance for AI Agents

## Project Context

- This repository is a feature-first Flutter starter for localized, API-driven applications.
- Treat `README.md` as the source of truth for the current architecture, setup, feature status, and production checklist.
- Preserve the package name `new_strucuture`, including its current spelling, unless the task explicitly requests a coordinated rename across every platform and Dart import.
- Check the project status in `README.md` before changing behavior. Keep working features, demo/scaffold behavior, and configuration-required integrations clearly distinguished.

## Architecture

- Keep feature-specific code under `lib/features/<feature_name>/`.
- Follow the Screen/Widget -> Cubit -> Repository -> `BaseApiConsumer` flow for API-backed features.
- Keep UI rendering and interaction in widgets, state and orchestration in Cubits, transport and response mapping in repositories, and serialization in models.
- Do not call Dio directly from widgets or Cubits.
- Put shared code in `lib/core/` only when it is genuinely reused across features.
- Define application endpoint constants in `lib/core/api/end_points.dart`; do not inline feature URLs.
- Register repositories and Cubits through GetIt in `lib/injector.dart`.
- Provide Cubits at the smallest appropriate widget scope; reserve `lib/app.dart` for truly global providers.
- Add named routes and transitions through `lib/config/routes/app_routes.dart`.

## Flutter Conventions

- Follow the existing Dart style and the lints in `analysis_options.yaml`; format changed Dart files with `dart format`.
- Reuse existing core widgets and services before adding overlapping abstractions.
- Use semantic theme colors through `ThemeHelper.colorsOf(context)` when an appropriate color exists instead of hard-coded feature colors.
- Keep user-facing text localized. Add every new translation key to both `assets/lang/ar.json` and `assets/lang/en.json`.
- Preserve explicit Cubit initial, loading, success, and error states for asynchronous flows.
- Return `Either<Failure, T>` from repositories and map transport exceptions to the established failure types.

## Safety and Scope

- Do not commit passwords, API tokens, signing material, production credentials, or object-storage access/secret keys.
- Do not add secrets to source code, examples, logs, fixtures, or documentation. Use placeholders and documented environment/configuration steps.
- Do not silently connect demo Cubits to production endpoints, enable incomplete Firebase configuration, or replace scaffold behavior unless the task requests it.
- Preserve unrelated user changes and keep edits within the requested scope.
- Update `README.md` when a change affects public architecture, endpoints, setup, feature status, required configuration, or production-readiness notes.

## Tests and Handoff

- Add or update unit, Cubit, repository, or widget tests for every behavior change at the narrowest useful level.
- Before handoff, run the relevant checks from the repository root:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

- Do not introduce new analyzer findings. Two existing `use_build_context_synchronously` notices in `lib/features/splash/screens/splash_screen.dart` are the documented baseline until fixed by a dedicated change.
- If a check cannot run because of the local environment, report the exact blocker and still run every unaffected check.
