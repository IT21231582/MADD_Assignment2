TV Calculator & Unit Converter – Documentation
1. Introduction

This document presents the design, functionality, and technical implementation of the TV Calculator & Unit Converter, a prototype tvOS application developed using SwiftUI. The goal of the app is to reimagine simple everyday utilities—such as calculators and unit converters—for a living-room environment where users rely on a remote control instead of touch input.

The app was developed as part of the SE4041 – Mobile Application Design and Development assignment, focusing on platform-specific design for tvOS and demonstrating the ability to adapt interaction models to a television interface.

2. Purpose of the Application

Traditional calculators and converters are typically built for mobile devices. This project aims to shift those tools into a TV context, where the user interacts using:

Arrow keys

Siri Remote (D-pad or clickpad)

Large on-screen navigation focus

Spacious UI designed for distance viewing

The app provides:

A standard calculator

A unit converter with common conversion categories

A simple, clear, and accessible interface suitable for TV usage.

3. Key Features
3.1 Standard Calculator

The calculator offers basic arithmetic operations:

Addition

Subtraction

Multiplication

Division

Decimal support

Buttons are arranged in a large 4×4 grid with:

Clear typography

Custom blue highlight

Animated focus scaling

Smooth tvOS navigation

3.2 Unit Converter

A fully button-driven unit converter, designed to require no keyboard input, offering:

Conversion Categories

Length

Meters ↔ Kilometers

Weight

Kilograms ↔ Grams

Temperature

Celsius ↔ Fahrenheit

Conversion Flow

User selects a category

Selects a conversion type

Enters a value using an on-screen numeric keypad

Presses Convert

The result appears instantly in large, readable text

This section demonstrates clean state handling and modular UI design for tvOS.

3.3 Daily Inspiration (Optional)

A dynamic section on the Home screen displaying:

A random motivational quote or fun fact

A random background image

Includes smooth focus animation and optional interaction.

4. User Experience & Interaction Design
4.1 tvOS Navigation

The app relies heavily on the tvOS Focus Engine, enabling navigation using:

Siri Remote

Arrow keys

Standard keyboard

To support this:

All interactive elements implement .focusable(true)

A custom FocusableButtonStyle provides:

Blue highlight

Glow

Scale effect

Smooth transition animations

The layout is spaced generously to prevent focus ambiguity.

4.2 Visual Design

The visual language emphasizes:

A blue-white gradient background

Large spacing between UI components

Crisp, high-contrast text

Minimum visual clutter

Consistent rounded corners and transparencies

This aligns with best practices for 10-foot UI experiences.

5. Technical Implementation
5.1 Technologies Used

SwiftUI for tvOS

NavigationStack for screen transitions

State management using @State

Custom ButtonStyle for focus animations

Reusable numeric keypad component

5.2 Architecture

A lightweight modular architecture was used:

TVCalculatorApp.swift
Launches the app and sets the NavigationStack.

HomeView.swift
Displays the main navigation to the Calculator and Unit Converter.

CalculatorView.swift
Contains grid layout, arithmetic logic, and display output.

UnitConverterView.swift
Provides:

Category picker

Conversion selector

Keypad input

Conversion logic

FocusableButtonStyle.swift
Custom style for all tvOS buttons (highlight/glow/scale).

This modular structure supports easy expansion and debugging.

6. Testing
6.1 Testing Environment

Testing was performed on:

Apple TV 1080p Simulator

Apple TV 4K Simulator

6.2 Manual Test Scenarios
Calculator

Basic operations

Decimal input

Large numbers

Rapid button navigation

Correct parsing and calculation using NSExpression

Unit Converter

All conversions tested with various values

Conversion formulas validated:

Meters ↔ Kilometers

Grams ↔ Kilograms

Celsius ↔ Fahrenheit

Keypad input behavior tested

Output accuracy confirmed

Navigation

Arrow key/D-pad movement

Focus highlighting

Returning between screens

No loss of focus when navigating between keypad buttons

7. Reflection

This project reinforced understanding of tvOS-specific interaction design, particularly:

How the Focus Engine changes UI layouts

Importance of large typography and spacing

Designing input flows without a system keyboard

Using custom button styles to improve user experience

The unit converter in particular showcased how a simple tool can be redesigned to work without text fields—purely through remote-friendly UI components.

If extended, this app could support:

Voice input

Additional conversion modules

User profiles

Theme customization

8. Conclusion

The TV Calculator & Unit Converter successfully demonstrates a fully functional tvOS prototype that is:

Visually appropriate for large screens

Remotely navigable

Modular

Useful

Simple to understand
