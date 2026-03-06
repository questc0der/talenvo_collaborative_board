# Talenvo Collaborative Board

Collaborative board application built with Flutter, using a feature-first and layered architecture.

## Architecture Explanation

The codebase is organized by **feature** and by **layer** to keep business logic separate from UI and data source details.

- **App bootstrap:** `lib/main.dart` initializes `MaterialApp`, routes, theme, and global providers.
- **Global composition:** `lib/config/providers/app_providers.dart` wires repositories, services, and root controllers.
- **Navigation:** `lib/config/routes/app_routes.dart` defines route constants, and `lib/config/routes/app_router.dart` maps routes to pages.
- **Feature modules:** each feature is isolated and owns its `domain`, `data`, and `presentation` concerns.

Dependency direction is intentionally one-way:

- `presentation` → uses `domain` contracts
- `data` → implements `domain` contracts
- `domain` → contains entities/use cases/interfaces and stays framework-agnostic

This architecture makes it easier to evolve from in-memory repositories to API-backed repositories without rewriting screens.

## State Management Reasoning

The project uses `provider` + `ChangeNotifier` for explicit, lightweight state handling.

Why this choice:

- **Simple DI and ownership:** app-level dependencies are created once and shared through `MultiProvider`.
- **Clear UI state model:** controllers expose `isLoading`, `errorMessage`, and typed data for predictable loading/error/empty/success rendering.
- **Scoped state where needed:**
  - Global state (auth, board list) is provided at app root.
  - Board-specific state is created per board screen (`BoardDetailShellPage`).
- **MVP-friendly complexity:** easy to read, debug, and iterate quickly in a collaborative app.

Controller responsibilities:

- `AuthController`: session bootstrap, login/register/logout, auth status.
- `BoardsController`: list/create/delete/refresh boards.
- `BoardDetailController`: load/mutate columns, cards, and teammate assignments for a selected board.

## Folder Structure Breakdown

```text
lib/
├── main.dart
├── config/
│   ├── providers/
│   │   └── app_providers.dart
│   └── routes/
│       ├── app_router.dart
│       └── app_routes.dart
├── core/
│   ├── error/
│   ├── services/
│   │   └── token_storage.dart
│   └── theme/
└── features/
		├── auth/
		│   ├── data/
		│   ├── domain/
		│   └── presentation/
		├── boards/
		│   ├── data/
		│   ├── domain/
		│   └── presentation/
		├── cards/
		│   ├── data/
		│   └── domain/
		├── columns/
		│   ├── data/
		│   └── domain/
		├── shell/
		│   └── presentation/
		└── teammates/
				├── data/
				└── domain/
```

Layer intent:

- **`config/`**: app-level setup (providers, routes).
- **`core/`**: shared cross-feature utilities/services/themes/errors.
- **`features/`**: business capabilities split by domain.
  - **`domain/`**: entities, use cases, repository interfaces.
  - **`data/`**: repository implementations (currently in-memory).
  - **`presentation/`**: controllers, pages, and widgets.
