# Project Guide

## Overview

This is a Flutter application named `thimar`. It uses a feature-first Clean Architecture style with `data`, `domain`, and `presentation` layers under `lib/features`.

## Core Stack

- Flutter with Dart SDK `^3.11.5`
- State management: `flutter_bloc`
- Dependency injection: `get_it` via `lib/core/injection/injection.dart`
- Routing: `go_router` via `lib/core/routing/app_router.dart`
- Networking: `dio` through `DioClient` and `ApiService`
- Caching: Hive through `HiveService` and `HiveCacheService`
- Localization: `easy_localization`, Arabic-first with `assets/translations`
- Responsive sizing: `flutter_screenutil`

## Architecture Rules

- Keep new functionality inside the matching feature folder under `lib/features/<feature>`.
- The app supports two roles: `driver` and `user`/client. Prefer reusing the same pages and shells for both roles; branch by role only for data sources, actions/buttons, and small widget differences.
- Avoid creating separate duplicate screens for driver and client unless the layout or workflow is genuinely different.
- Follow the existing layer split:
  - `data`: remote/local data sources, models, repository implementations
  - `domain`: entities, repositories, use cases
  - `presentation`: pages, widgets, blocs/cubits, events, states
- Register new data sources, repositories, use cases, and blocs/cubits in `lib/core/injection/injection.dart`.
- Add routes centrally in `lib/core/routing/app_router.dart` using `AppRoutes`.
- Prefer shared widgets from `lib/core/shared/widgets` before creating new UI primitives.

## Code Style

- Match the existing Dart style and keep edits narrowly scoped.
- Use `Equatable` for bloc events/states and domain value objects where appropriate.
- Return `Either<Failure, T>` from domain use cases and repositories.
- Convert `ServerException` and `NetworkException` to `ServerFailure` and `NetworkFailure` in repository implementations.
- Prefer translation keys with `.tr()` instead of hardcoded UI text.
- Use the existing `core_imports.dart` and `packages_imports.dart` barrels where they are already used locally.

## Networking

- Keep API path constants in `lib/core/networking/endpoints.dart`.
- Use `ApiService` for HTTP requests instead of accessing Dio directly outside core networking.
- Auth tokens are read from `HiveCacheService` and attached by `DioClient`.
- 401 responses clear cached auth data and notify `GoRouter` through `DioClient.onUnauthorized`.

## UI Conventions

- The app uses the `tajawal` font and `AppTheme.primaryColor` green branding.
- Layouts generally use Arabic-first RTL behavior and `ScreenUtil` sizing.
- Role-specific UI should be composed from reusable widgets with role-specific props or state, not copied into parallel page trees.
- Keep reusable visual pieces in feature `widgets` folders or `lib/core/shared/widgets` for cross-feature components.

## Validation

- Run `dart format` on changed Dart files.
- Run `flutter analyze` after meaningful code changes.
- Run targeted `flutter test` commands when tests exist or when adding test coverage.

## Notes

- Git commands may require configuring `safe.directory` because the sandbox user differs from the repository owner.
- Avoid changing generated or build output directories such as `.dart_tool` and `build`.




