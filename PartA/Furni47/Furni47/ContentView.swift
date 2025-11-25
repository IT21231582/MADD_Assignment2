//
//  ContentView.swift
//  Furni47
//
//  Created by IM Student on 2025-11-25.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @StateObject private var arViewModel = ARViewModel()
    @State private var selectedFurniture: FurnitureItem?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // AR View Container
                ARViewContainer(selectedModelName: selectedFurniture?.modelName)
                    .edgesIgnoringSafeArea(.all)
                
                // Furniture Selection Bar
                furnitureSelectionBar
            }
            .navigationTitle("Furni47 AR")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Furniture Saved", isPresented: $arViewModel.showSaveAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(arViewModel.alertMessage)
            }
        }
    }
    
    // MARK: - Furniture Selection Bar
    private var furnitureSelectionBar: some View {
        VStack(spacing: 12) {
            // Selected Furniture Info
            if let furniture = selectedFurniture {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(furniture.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("Tap to place in AR")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        arViewModel.selectFurniture(furniture)
                    }) {
                        Text("Place")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        arViewModel.saveFurniture()
                    }) {
                        Image(systemName: arViewModel.isSaved ? "heart.fill" : "heart")
                            .foregroundColor(arViewModel.isSaved ? .red : .gray)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            
            // Furniture Options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(SampleFurniture.all) { furniture in
                        furnitureButton(for: furniture)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground).opacity(0.9))
    }
    
    // MARK: - Furniture Button
    private func furnitureButton(for furniture: FurnitureItem) -> some View {
        Button(action: {
            selectedFurniture = furniture
        }) {
            VStack(spacing: 8) {
                // Placeholder icon for furniture
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: furnitureIcon(for: furniture.modelName))
                            .font(.title2)
                            .foregroundColor(.blue)
                    )
                
                Text(furniture.name)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helper Methods
    private func furnitureIcon(for modelName: String) -> String {
        switch modelName {
        case "chair":
            return "chair.lounge"
        case "table":
            return "table.furniture"
        case "lamp":
            return "lamp.floor"
        default:
            return "cube.box"
        }
    }
}

#Preview {
    ContentView()
}
