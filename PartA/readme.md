Furni47 – AR Furniture Preview App
ARKit + SwiftUI + Core Data

Furni47 is an iOS application that allows users to preview virtual furniture in real-world environments using augmented reality. The app uses ARKit for surface detection and object placement, SwiftUI for UI components and navigation, and Core Data to save user-selected furniture models.

This project was developed as part of the Mobile Application Design & Development coursework.

🚀 Features
🟣 Augmented Reality Placement

Detects horizontal surfaces using ARKit

Allows users to place 3D furniture models (.usdz) in real space

Supports movement, rotation, and scaling gestures

Real-time, stable AR tracking

🟣 3D Model Browser

Built-in selection menu for available furniture

Models include: Chair, Table, Lamp

Smooth transitions and custom UI components

🟣 Favorites System (Core Data)

Save frequently used furniture models

View and manage saved items

One-tap reloading into AR scene

🟣 Clean & Minimal UI

Fully built with SwiftUI

Custom buttons, animations, and layout

Works with Dark Mode

Adaptive layout for different screen sizes

📱 App Structure

The app contains three main screens:

Home Screen

App branding and quick navigation

Model previews

Buttons for AR mode and saved items

AR View

AR session with plane detection

Object placement with gestures

Floating action controls (reset, save, change object)

Saved Items Screen

List of user-saved furniture

Re-open models in AR instantly

🏛 Architectural Overview

The app is built using:

SwiftUI → UI, navigation, animations

RealityKit + ARKit → AR rendering and spatial tracking

Core Data → Local storage for favorites

MVVM pattern → Clean separation of View & Logic

Core components include:

ARViewContainer.swift

FurnitureModel.swift

FurnitureViewModel.swift

PersistenceController.swift

FurnitureEntity Core Data class

🧱 Technologies Used
Technology	Purpose
ARKit	Plane detection + object placement
RealityKit	Rendering 3D models with gestures
SwiftUI	Entire UI, layout, transitions
Core Data	Saving favorite objects
MVVM	App architecture
USDZ Models	3D furniture

