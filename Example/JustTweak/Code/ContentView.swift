//
//  ContentView.swift
//  Copyright © 2021 Just Eat. All rights reserved.
//

import SwiftUI
import JustTweak

struct ContentView: View {

    @State private var showingAlert = false
    @State private var presentTweakView = false
    @State private var backgroundColor: Color?

    @ObservedObject var viewModel: ContentViewModel

    @ViewBuilder
    private var viewBackground: some View {
        if backgroundColor != nil {
            Rectangle()
                .foregroundColor(backgroundColor)
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func rectanglesView(with height: CGFloat) -> some View {
        VStack {
            if viewModel.tweakAccessor.canShowRedView {
                let alpha = viewModel.tweakAccessor.redViewAlpha
                Rectangle()
                    .foregroundColor(.red.opacity(alpha))
            }
            if viewModel.tweakAccessor.canShowYellowView {
                Rectangle()
                    .foregroundColor(.yellow)
            }
            if viewModel.tweakAccessor.canShowGreenView {
                Rectangle()
                    .foregroundColor(.green)
            }
        }
        .frame(height: height)
    }

    @ViewBuilder
    private var tweakViewButtons: some View {
        VStack(spacing: 16) {
            #if os(iOS)
            Button("Change configuration (present)") {
                presentTweakView.toggle()
            }
            #endif
            #if !os(OSX)
            NavigationLink(destination: viewModel.tweakView) {
                Text("Change configuration (push)")
            }
            #endif
        }
        .padding()
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    viewBackground
                    ScrollView {
                        VStack(spacing: 16) {
                            rectanglesView(with: geometry.size.height / 2)

                            Text(viewModel.tweakAccessor.labelText)
                                .font(.headline)

                            Button("Set meaning of life") {
                                viewModel.setMeaningOfLife()
                                showingAlert = true
                            }

                            Button("Change background color") {
                                backgroundColor = viewModel.randomColor()
                            }
                            .disabled(!viewModel.tweakAccessor.isTapGestureToChangeColorEnabled)

                            tweakViewButtons
                        }
                    }
                }
            }
            .navigationTitle("JustTweak")
        }
        .sheet(isPresented: $presentTweakView) {
            NavigationView {
                viewModel.tweakView
                    .toolbar(content: {
                        #if os(iOS)
                        let placement: ToolbarItemPlacement = .navigationBarLeading
                        #else
                        let placement: ToolbarItemPlacement = .automatic
                        #endif
                        ToolbarItem(placement: placement) {
                            Button(action: {
                                presentTweakView = false
                            }, label: {
                                Text("Done")
                                    .bold()
                            })
                        }
                    })
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("The Meaning of Life"),
                message: Text(String(describing: viewModel.tweakAccessor.meaningOfLife))
            )
        }
    }

}
