🪑 FerniFresh – AR Furniture Preview App

An Augmented Reality furniture placement experience built with SwiftUI and ARKit.

FerniFresh is a simple and intuitive AR application that lets users place 3D furniture models into their real environment using the iPhone’s camera. Built entirely with SwiftUI + ARKit + RealityKit, the app provides a clean UI, fast AR placement, and smooth model interaction.

This project is part of the Mobile Application Development coursework.

🎯 Features
🟦 Augmented Reality Placement

Detects horizontal surfaces using ARKit.

Places 3D furniture models (chair, table, lamp) into the real world.

Anchors objects accurately based on raycasting.

Works in real-time on ARKit-supported iPhones.

🟦 Minimal & Clean UI

SwiftUI-powered interface.

Bottom bar for furniture selection.

"Place" button to drop the selected model into AR.

Modern icons and layout.

🟦 3D Furniture Models

The app includes three USDZ models:

Modern Chair (chair.usdz)

Dining Table (table.usdz)

Floor Lamp (lamp.usdz)

📱 App Structure
FerniFresh/
│
├── Models/
│   ├── chair.usdz
│   ├── table.usdz
│   └── lamp.usdz
│
├── Views/
│   ├── ContentView.swift
│   └── LaunchScreen.storyboard
│
├── AR/
│   └── ARViewContainer.swift
│
├── Resources/
│   └── Assets.xcassets (LaunchLogo, icons, etc.)
│
└── FerniFreshApp.swift

🧱 Technologies Used
Technology	Purpose
SwiftUI	UI layout, animation, and screen structure
ARKit	Surface detection + camera tracking
RealityKit	Rendering 3D models and placing objects
USDZ Models	Apple’s native 3D model format
Storyboard Launch Screen	App launch logo
🚀 How to Run the App
Requirements:

iPhone 8 or newer

iOS 15+

Mac with Xcode 15+

ARKit support

Camera permission enabled

Steps:

Clone the repository or download the project.

Open FerniFresh.xcodeproj in Xcode.

Connect an ARKit-capable iPhone to your Mac.

Select your iPhone as the build target.

Run the app using the ▶️ Run button.

Move your phone around until ARKit detects a plane (floor/table).

Select a furniture item and tap Place.

🎨 Launch Screen

This project includes a fully customized launch screen featuring the FurniFresh logo.
If the launch screen does not update, reinstall the app on your device (iOS caches launch screens).

🧪 Testing

Manual testing includes:

Surface detection on different environments.

Object placement stability.

Camera permission handling.

UI responsiveness and tap gestures.

Performance testing includes:

Load time of USDZ models.

Smoothness of AR interactions.

🧭 Future Improvements

Multi-object placement

Furniture rotation / scaling gestures

Saving placed objects

Room scanning features

More detailed 3D models

👨‍💻 Developer

Name: Kojitha
Project Title: FerniFresh
Tech: SwiftUI + ARKit + RealityKit
