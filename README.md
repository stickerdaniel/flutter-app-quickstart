# Flutter App Quickstart

Jumpstart your next Flutter project with this template, which includes a settings screen to display the app version and offers an option to switch between light, dark, or system default themes.

<p align="center">
  <img src="https://github.com/stickerdaniel/FlutterAppQuickstart/assets/63877413/b26fb3f5-be34-4dbf-92a1-f8711ab53861" width="200">
</p>


## Features

- **Settings Screen:** A dedicated screen to display app-related settings.
  - **App Version:** Shows the current version of the app.
  - **Theme Toggle:** Lets users switch between light, dark, or system default themes.

## Getting Started

### Prerequisites

Ensure you have Flutter installed on your machine. If not, head over to the official [Flutter installation guide](https://docs.flutter.dev/get-started/install) to set up your local development machine.

### Installation

#### macOS/Linux

1. Create a new Flutter project:
   ```sh
   flutter create your_project_name
   ```
2. Navigate into the new project directory:
   ```sh
   cd your_project_name
   ```
3. Download the template repository:
   ```sh
   git clone https://github.com/stickerdaniel/flutter-app-quickstart.git template_repo
   ```
4. Copy the files from the template repository:
   ```sh
   cp -r template_repo/* .
   cp -r template_repo/.[^.]* .
   ```
5. Clean up the temporary repository folder:
   ```sh
   rm -rf template_repo
   ```
6. Install the dependencies:
   ```sh
   flutter pub get
   ```

#### Windows

1. Create a new Flutter project:
   ```sh
   flutter create your_project_name
   ```
2. Navigate into the new project directory:
   ```sh
   cd your_project_name
   ```
3. Download the template repository:
   ```sh
   git clone https://github.com/stickerdaniel/flutter-app-quickstart.git template_repo
   ```
4. Copy the files from the template repository:
   ```sh
   xcopy template_repo\* . /s /e /y
   xcopy template_repo\.* . /s /e /y
   ```
5. Clean up the temporary repository folder:
   ```sh
   rmdir /s /q template_repo
   ```
6. Install the dependencies:
   ```sh
   flutter pub get
   ```

## Resources

If this is your first time with Flutter, here are some resources to help you get started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For comprehensive Flutter development documentation, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
