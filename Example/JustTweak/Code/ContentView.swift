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

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    VStack {
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
                        .frame(width: geometry.size.width, height: geometry.size.height / 2)
                        Text(viewModel.tweakAccessor.labelText)
                            .font(.headline)
                            .padding()
                        Rectangle()
                            .border(Color.blue, width: 5)
                            .foregroundColor(backgroundColor)
                    }
                    #if !os(tvOS)
//                    .gesture(doubleTapGesture)
//                    .simultaneousGesture(singleTapGesture)
                    #endif

                    VStack(spacing: 16) {
                        #if os(iOS)
                        Button("Change configuration (present)") {
                            presentTweakView.toggle()
                        }
                        #endif
                        NavigationLink(destination: viewModel.tweakView) {
                            Text("Change configuration (push)")
                        }
                    }
                    .padding()
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

    #if !os(tvOS)
    var singleTapGesture: some Gesture {
        TapGesture()
            .onEnded {
                if viewModel.tweakAccessor.isTapGestureToChangeColorEnabled {
                    backgroundColor = viewModel.randomColor()
                }
            }
    }

    var doubleTapGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                viewModel.setMeaningOfLife()
                showingAlert = true
            }
    }
    #endif

}
