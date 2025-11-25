# MADD_Assignment2
# TV Calculator (tvOS)

TV Calculator is a simple, tvOS-based prototype application designed for use on Apple TV.  
It provides a large-screen calculator and a bill-splitting tool that can be operated entirely via the Apple TV remote or keyboard arrow keys.

This project was developed as part of a Mobile Application Design and Development assignment, focusing on platform-specific design and interaction patterns for tvOS.

---

## 🎯 Purpose & Goal

The goal of this app is to explore how everyday utilities like calculators can be reimagined for the living room context on Apple TV.

Instead of being a single-user, phone-only tool, TV Calculator:

- Runs on the **big screen**
- Supports **remote-based navigation**
- Uses **focus-based UI** patterns built for tvOS
- Demonstrates how a simple idea can be adapted to a different platform with different interaction models

---

## 📺 Key Features

### 1. Home Screen
- Simple landing page with two large, easy-to-select options:
  - **Calculator**
  - **Bill Splitter**
- Designed for readability from a distance.

### 2. Calculator
- Basic arithmetic:
  - Addition
  - Subtraction
  - Multiplication
  - Division
- Large display area for the current expression / result.
- Button grid laid out in a familiar calculator layout.
- Fully operable via:
  - Apple TV Remote D-pad / touch surface
  - Keyboard arrow keys + Return/Enter

### 3. Bill Splitter
- Allows the user to:
  - Enter a total bill amount
  - Enter number of people
  - Calculate the amount each person needs to pay
- Handles invalid input safely and shows a simple validation message.

---

## 🧩 tvOS-Specific Design & Interaction

This app has been structured specifically around **tvOS interaction patterns**:

- **Focus Engine**  
  All interactive elements are made focusable, allowing navigation via arrow keys and the Apple TV remote.

- **Large, Spaced-Out UI**  
  Buttons and text fields are sized and spaced for viewing on a TV from a distance.

- **High-Contrast, Simple Layout**  
  The interface avoids clutter and uses clear visual grouping to keep the experience comfortable on a large screen.

Even though the core logic is simple, the app demonstrates how to adapt UI/UX when the input method changes from touch to remote/keyboard.

---

## 🏗️ Architecture & Technologies

- **Platform**: tvOS  
- **Language**: Swift  
- **UI Framework**: SwiftUI  
- **Navigation**: `NavigationStack`  
- **Pattern**: Simple, screen-based SwiftUI views (can be extended into MVVM if needed)

### Main Components

- `TVCalculatorApp.swift`  
  - Entry point of the app, sets up the `NavigationStack` and initial `HomeView`.

- `HomeView.swift`  
  - Landing screen with navigation options to the Calculator and the Bill Splitter.

- `CalculatorView.swift`  
  - Implements the calculator interface and logic.
  - Uses `NSExpression` to evaluate arithmetic expressions after mapping operators to standard symbols (`×` → `*`, `÷` → `/`, `−` → `-`).

- `BillSplitterView.swift`  
  - Handles the UI and logic for splitting a total bill between a number of people.
  - Contains basic validation for empty / invalid inputs.

- `FocusableButtonStyle.swift`  
  - A custom `ButtonStyle` used to make buttons feel consistent across the app and to support focusable behavior.

---

## 🧪 Testing & Validation

The app was tested using the **Apple TV Simulator** in Xcode.

### Manual Test Scenarios

- **Calculator**
  - Simple operations: `2 + 2`, `10 − 3`, `5 × 4`, `20 ÷ 5`
  - Mixed operations in one expression: `2 + 3 × 4`
  - Edge cases: pressing `=` multiple times, multiple operators, starting with `0`, use of decimal point.

- **Bill Splitter**
  - Valid inputs: total = `100`, people = `4` → result `25.00`
  - Invalid inputs:
    - Total or people left empty
    - People = 0
    - Non-numeric values (handled by conversion checks)

- **Navigation**
  - Arrow-key navigation between all calculator buttons.
  - Transition between Home → Calculator → Back → Home.
  - Transition between Home → Bill Splitter → Back → Home.

---

## ▶️ How to Run

1. Open the project in **Xcode**.
2. Make sure **tvOS** is selected as the platform.
3. Select a target like:
   - `Apple TV` (1080p) Simulator  
   - or `Apple TV 4K` Simulator
4. Click **Run**.

The app will launch into the Home screen on the tvOS simulator.

---

## 🚀 Possible Future Improvements

This prototype can be extended with:

- History of calculations stored locally.
- Multiple profiles (e.g., each family member saving presets).
- Theming support (light/dark or color themes).
- Voice input via Siri Remote for entering numbers or commands.
- More advanced financial modes (tips, tax, budgeting presets).

---

## 📚 Assignment Context

This project was built as a **tvOS prototype application** to demonstrate:

- Understanding of **platform-specific interaction** (focus-based navigation).
- Ability to adapt a simple utility app to the **large-screen living room environment**.
- Use of **SwiftUI** and **tvOS simulator** for rapid prototyping.

