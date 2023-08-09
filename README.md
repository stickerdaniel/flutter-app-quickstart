# Flutter App Quickstart

Jumpstart your next Flutter project with this template, which includes a settings screen to display the app version and offers an option to switch between light, dark, or system default themes.

## Features

- **Settings Screen:** A dedicated screen to display app-related settings.
  - **App Version:** Shows the current version of the app.
  - **Theme Toggle:** Lets users switch between light, dark, or system default themes.

## Getting Started

### Prerequisites

Ensure you have Flutter installed on your machine. If not, head over to the official [Flutter installation guide](https://docs.flutter.dev/get-started/install) to set up your local development machine.

### Installation

1. Create a new Flutter project:
   ```sh
   flutter create your_project_name
   ```
2. Navigate into the new project directory:
   ```sh
   cd your_project_name
   ```
3. Delete the existing `lib` folder:
   ```sh
   rm -r lib
   ```
4. Clone the `lib` directory from the Quickstart repository:
   ```sh
   git clone --depth 1 https://github.com/stickerdaniel/FlutterAppQuickstart.git .tmp && mv .tmp/lib . && rm -r .tmp
   ```
5. Install the dependencies:
   ```sh
   flutter pub get
   ```

## Resources

If this is your first time with Flutter, here are some resources to help you get started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For comprehensive Flutter development documentation, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
