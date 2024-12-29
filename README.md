# MVVM Task Manager App

This Flutter project is a simple task management application built using the **MVVM architecture**. It allows users to add, edit, delete tasks, and toggle between light and dark themes.

---

## Features

- **Add Tasks**: Create new tasks with a title and description.
- **Edit Tasks**: Modify existing tasks.
- **Delete Tasks**: Remove tasks permanently.
- **Toggle Theme**: Switch between light and dark mode.
- **Persistent Data**: Tasks and user preferences are stored locally using Hive.

---

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture:

- **Model**: Contains data models for tasks and user preferences.
- **ViewModel**: Manages business logic and application state using `Riverpod`'s `StateNotifier`.
- **View**: Defines the UI components and widgets.

---

## Project Structure

lib/
├── main.dart
├── models/
│   ├── task_model.dart
│   ├── preferences_model.dart
├── viewmodels/
│   ├── task_view_model.dart
├── views/
│   ├── home_page.dart
├── utils/
│   ├── database_helper.dart

## Install Dependencies:
flutter pub get

## Dependencies
The following Flutter dependencies are used in the project:

flutter_riverpod - State management.
hive_flutter - Hive integration with Flutter.
sqflite: SQLite database management for local storage.