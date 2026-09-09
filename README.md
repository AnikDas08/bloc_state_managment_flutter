# Flutter Clean Architecture with BLoC & Cubit State Management

A modern, scalable Flutter application built using **Clean Architecture** (Feature-First approach), **BLoC & Cubit** state management, and **GetIt** Dependency Injection.

---

## 📌 Table of Contents
- [Architecture Overview](#-architecture-overview)
- [Folder Structure](#-folder-structure)
- [How BLoC & Cubit Work in this Project](#-how-bloc--cubit-work-in-this-project)
  - [1. BLoC Pattern (Event-Driven)](#1-bloc-pattern-event-driven)
  - [2. Cubit Pattern (Method-Driven)](#2-cubit-pattern-method-driven)
  - [BLoC vs Cubit Decision Matrix](#bloc-vs-cubit-decision-matrix)
- [Dependency Injection with GetIt](#-dependency-injection-with-getit)
- [Key Features & Packages](#-key-features--packages)
- [Getting Started](#-getting-started)

---

## 🏛️ Architecture Overview

This project follows **Clean Architecture** principles combined with a **Feature-First** folder structure. This ensures:
- **Separation of Concerns:** Business logic is decoupled from UI and data layers.
- **Maintainability & Scalability:** Adding new features requires minimal modification to existing code.
- **Testability:** Domain logic and repositories can be unit tested without Flutter dependencies.

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                   │
│         (UI Widgets, Screens, BLoC / Cubit)             │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                       Domain Layer                      │
│            (Entities, Repository Interfaces,            │
│                       Use Cases)                        │
└───────────────────────────▲─────────────────────────────┘
                            │
                            │ (Implements Interfaces)
┌───────────────────────────┴─────────────────────────────┐
│                       Data Layer                        │
│          (Data Sources, Models, Repositories)           │
└─────────────────────────────────────────────────────────┘
```

---

## 📁 Folder Structure

```
lib/
├── component/               # Reusable UI components (Buttons, Text, TextFields, Loaders)
├── config/                  # App configurations (Routes, Theme, Secret keys, Scroll behavior)
│   ├── api/                 # API Endpoints
│   ├── core/                # Global error handlers & App lifecycle
│   ├── route/               # AppRoutes and RouteGenerator
│   └── theme/               # Material Theme data
├── core/                    # Core application services & utilities
│   ├── di/                  # Dependency Injection (GetIt service locator)
│   ├── error/               # Custom Failure & Error classes
│   └── services/            # Services (API Client, Firebase, Storage, Location, Socket, Notification)
├── features/                # Modular features (Feature-First)
│   ├── auth/                # Authentication feature
│   │   ├── data/            # Data Sources, Models, Repository Impl
│   │   ├── domain/          # Entities, Repositories
│   │   └── presentation/    # BLoC, Cubit, Screens, Widgets
│   ├── home/                # Dashboard & Receipts feature
│   │   ├── data/            # Data Sources, Models, Repository Impl
│   │   ├── domain/          # Entities, Repositories, UseCases
│   │   └── presentation/    # Home BLoC, Receipt Details Cubit, Screens, Widgets
│   └── notification/        # Push Notifications feature
│       └── presentation/    # Notification BLoC, Events, States
├── firebase_options.dart    # Firebase CLI config
└── main.dart                # Application entry point
```

---

## 🔄 How BLoC & Cubit Work in this Project

State management in this project is powered by `flutter_bloc`. We use both **BLoC** (for complex, event-driven workflows) and **Cubit** (for simple, direct action workflows).

### 1. BLoC Pattern (Event-Driven)

BLoC uses **Events** to trigger business logic and emits new **States**.

```
[ UI Widget ] ──────► (Dispatches Event) ──────► [ BLoC ]
     ▲                                             │
     └─────────────── (Emits New State) ───────────┘
```

#### Example Flow: `SignInBloc`
1. **Event (`signin_event.dart`):** UI triggers `SignInSubmitted`.
   ```dart
   class SignInSubmitted extends SignInEvent {
     final String email;
     final String password;
     final String role;
     SignInSubmitted({required this.email, required this.password, required this.role});
   }
   ```
2. **State (`signin_state.dart`):** Represents UI state (`SignInInitial`, `SignInLoading`, `SignInSuccess`, `SignInFailure`).
3. **BLoC (`signin_bloc.dart`):**
   ```dart
   class SignInBloc extends Bloc<SignInEvent, SignInState> {
     final AuthRepository _authRepository;

     SignInBloc({required AuthRepository authRepository})
         : _authRepository = authRepository,
           super(const SignInInitial()) {
       on<SignInSubmitted>(_onSignInSubmitted);
     }

     Future<void> _onSignInSubmitted(SignInSubmitted event, Emitter<SignInState> emit) async {
       emit(const SignInLoading());
       final result = await _authRepository.signIn(
         email: event.email, password: event.password, role: event.role,
       );
       result.fold(
         (failure) => emit(SignInFailure(failure.message)),
         (user) => emit(SignInSuccess(user)),
       );
     }
   }
   ```
4. **UI Usage (`signin_screen.dart`):**
   ```dart
   BlocConsumer<SignInBloc, SignInState>(
     listener: (context, state) {
       if (state is SignInFailure) showSnackBar(state.message);
       if (state is SignInSuccess) Navigator.pushNamed(context, AppRoutes.home);
     },
     builder: (context, state) {
       return ElevatedButton(
         onPressed: () => context.read<SignInBloc>().add(
           SignInSubmitted(email: email, password: password, role: role),
         ),
         child: state is SignInLoading ? CircularProgressIndicator() : Text('Sign In'),
       );
     },
   );
   ```

---

### 2. Cubit Pattern (Method-Driven)

Cubit simplifies state management by eliminating Events. UI directly calls methods on the Cubit.

```
[ UI Widget ] ──────► (Direct Method Call) ──────► [ Cubit ]
     ▲                                              │
     └─────────────── (Emits New State) ────────────┘
```

#### Example Flow: `SignInCubit`
1. **State (`signin_cubit_state.dart`):**
   ```dart
   abstract class SignInCubitState extends Equatable {}
   class SignInCubitInitial extends SignInCubitState {}
   class SignInCubitLoading extends SignInCubitState {}
   class SignInCubitSuccess extends SignInCubitState { final UserEntity user; ... }
   class SignInCubitFailure extends SignInCubitState { final String message; ... }
   ```
2. **Cubit (`signin_cubit.dart`):**
   ```dart
   class SignInCubit extends Cubit<SignInCubitState> {
     final AuthRepository _authRepository;
     SignInCubit({required AuthRepository authRepository})
         : _authRepository = authRepository, super(SignInCubitInitial());

     Future<void> signIn({required String email, required String password, required String role}) async {
       emit(SignInCubitLoading());
       final result = await _authRepository.signIn(email: email, password: password, role: role);
       result.fold(
         (failure) => emit(SignInCubitFailure(failure.message)),
         (user) => emit(SignInCubitSuccess(user)),
       );
     }
   }
   ```
3. **UI Usage (`signin_cubit_screen.dart`):**
   ```dart
   context.read<SignInCubit>().signIn(email: email, password: password, role: role);
   ```

---

### BLoC vs Cubit Decision Matrix

| Criterion | BLoC | Cubit |
| :--- | :--- | :--- |
| **Trigger Mechanism** | Event dispatch (`add(Event)`) | Direct function call (`cubit.method()`) |
| **Complexity** | High (Traceability, Event transformation) | Low to Moderate (Direct & Concise) |
| **Best For** | Complex workflows, event streams, analytics tracking | Simple screens, CRUD operations, view-state toggles |
| **In this Project** | `SignInBloc`, `HomeBloc`, `NotificationBloc` | `SignInCubit`, `SignUpCubit`, `ReceiptDetailsCubit` |

---

## 💉 Dependency Injection with GetIt

Dependency Injection is managed using `GetIt` in `lib/core/di/service_locator.dart`.

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // Data Sources (Lazy Singleton)
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  // Repositories (Lazy Singleton)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases (Lazy Singleton)
  sl.registerLazySingleton(() => GetDashboardUseCase(sl()));

  // BLoCs / Cubits (Factory - new instance per request)
  sl.registerFactory(() => SignInBloc(authRepository: sl()));
  sl.registerFactory(() => HomeBloc(getDashboardUseCase: sl()));
}
```

- **`registerLazySingleton`**: Creates a single shared instance upon first access (ideal for Data Sources, Repositories, and Services).
- **`registerFactory`**: Creates a new instance every time it is requested (ideal for BLoCs and Cubits tied to widget lifecycles).

---

## 🛠️ Key Features & Packages

| Package | Purpose |
| :--- | :--- |
| `flutter_bloc` | BLoC & Cubit state management |
| `get_it` | Dependency Injection / Service Locator |
| `equatable` | Value equality for BLoC States and Events |
| `firebase_core` & `firebase_messaging` | Firebase integration & Push notifications |
| `flutter_screenutil` | Responsive screen adaptivity |
| `google_fonts` | Typography & custom font styles |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- FVM (optional, `.fvmrc` configured)

### Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd bloc_state_managment_flutter
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the project:**
   ```bash
   flutter run
   ```
