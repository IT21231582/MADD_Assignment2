# 📺 TV Calculator & Unit Converter (tvOS App)

A modern, TV-friendly calculator and unit converter built for *Apple tvOS* using *SwiftUI*.  
Designed for remote-based input, large screens, and smooth navigation using the *tvOS Focus Engine*.

This project was developed as the Part B assignment requirement for SE4041 – Mobile Application Design & Development.

---

## 🎯 Purpose of the App
This application adapts everyday tools (calculator + unit conversion) into a *living-room friendly experience* on Apple TV.

Instead of small phone interactions, this app delivers:
- Large, readable display text  
- Remote-based navigation (arrow keys, D-pad)  
- Highlighted, focusable buttons  
- TV-optimized layouts  
- A pleasant gradient theme designed for distance viewing  

It demonstrates how simple utilities can be redesigned for tvOS user interaction models.

---

## ✨ Features

### 🔢 1. Standard Calculator
- Fully functional arithmetic calculator  
- Supports: +, −, ×, ÷, decimals  
- Large calculator buttons arranged in a 4×4 grid  
- Focusable buttons with:
  - Blue highlight
  - Glow effect  
  - Scale animation

### 🔄 2. Unit Converter (New Feature)
A simple, clean, fully button-based converter with *NO keyboard input required*.

Includes:
- *Length Conversion*
  - Meters ↔ Kilometers  
- *Weight Conversion*
  - Kilograms ↔ Grams  
- *Temperature Conversion*
  - Celsius ↔ Fahrenheit  

The user flows:
1. Select Conversion Category  
2. Choose specific conversion direction  
3. Use on-screen numeric keypad to enter values  
4. Press *Convert*  
5. Output displays instantly in large text  

Built to be extremely easy to operate with a remote.

### ✨ 3. Daily Inspiration (Optional Section)
- Displays a random quote or fun fact  
- Includes a random image  
- Appears at the top of the Home screen  
- Fully focusable section  
- Adds personality to the app

---

## 🎮 tvOS Navigation Features

- Uses the *tvOS Focus Engine* for:
  - Arrow key movement  
  - Siri Remote D-pad / clickpad  
  - Keyboard arrow key input  
- Highlight animations:
  - Blue glow  
  - Scale-up when focused  
  - Smooth transitions  
- Simple navigation controlled by NavigationStack

All buttons follow a *custom FocusableButtonStyle*.

---

## 🧩 App Screens

### 🏠 Home Screen
- Gradient blue–white background  
- Big, focusable buttons:
  - *Calculator*
  - *Unit Converter*
- Optional: Daily Inspiration card

### 🔢 Calculator Screen
- Large display area  
- Big button grid  
- Smooth focus transitions  
- tvOS-optimized layout  

### 🔄 Unit Converter Screen
- Category picker  
- Conversion type picker  
- Numeric keypad  
- Convert button  
- Instant results  

---

## 🛠️ Technologies Used

- *SwiftUI (tvOS)*  
- *NavigationStack*  
- *Focus Engine*  
- *Custom ButtonStyle*
- *State Management with @State*  
- *Reusable Components (Keypad, Converter Modes)*  

---

## 📐 Architecture

A lightweight, clean SwiftUI architecture:
- TVCalculatorApp.swift → Launches NavigationStack  
- HomeView.swift → Main screen  
- CalculatorView.swift → Standard calculator  
- UnitConverterView.swift → Full unit conversion tool  
- FocusableButtonStyle.swift → Reusable button highlight style  

Each screen is isolated, making future expansion easy.

---

## 🧪 Testing

Tested on:
- *Apple TV 1080p Simulator*
- *Apple TV 4K Simulator*

Scenarios tested:
- Button focus navigation  
- Calculator operations  
- All unit conversion flows  
- Keypad numeric input  
- Convert button execution  
- Input validation (empty fields, zero division)  
- Navigation back & forth between screens  

All core features successfully tested.

---

## ▶️ How to Run

1. Install *Xcode*  
2. Open the project folder  
3. Set target to:  
   - Apple TV 1080p Simulator  
   - OR Apple TV 4K Simulator  
4. Run the project (⌘ + R)  
5. Navigate using:
   - Keyboard arrow keys  
   - Return/Enter  
   - Or Siri Remote (if connected)

---

## 🚀 Future Enhancements

- Voice input using Siri Remote  
- More unit categories (currency, volume, time)  
- Theme customization  
- Calculation history  
- Multi-user profiles per Apple TV user  

---

## 📘 Academic Notes (For Assignment Submission)

This project demonstrates:
- Platform-specific design for *tvOS*  
- Focus-based interaction rather than touch input  
- Clean SwiftUI architecture  
- Interactive animations + custom components  
- A meaningful extension of the calculator concept (Unit Conversion)  
- Professional UI with gradient, spacing, and typography  
- Proper navigation and user flow design  
- Testing and functional prototype completeness  

---

## 📄 License
This project is developed for educational and academic submission purposes.
