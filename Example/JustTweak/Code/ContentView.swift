//
//  ContentView.swift
//  Copyright © 2021 Just Eat. All rights reserved.
//

import SwiftUI
import JustTweak

struct ContentView: View {

    @State private var showingAlert = false
    @State private var presentTweakView = false
    @State private var backgroundColor: Color = .white

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
                        ZStack(alignment: .top) {
                            Rectangle()
                                .foregroundColor(backgroundColor)
                            Text(viewModel.tweakAccessor.labelText)
                        }
                    }
                    #if !os(tvOS)
                    .gesture(doubleTapGesture)
                    .simultaneousGesture(singleTapGesture)
                    #endif

                    VStack(spacing: 16) {
                        Button("Change configuration (present)") {
                            presentTweakView.toggle()
                        }
                        NavigationLink(destination: viewModel.tweakView) {
                            Text("Change configuration (push)")
                        }
                    }
                }
            }
            #if os(iOS)
            .navigationBarTitle("JustTweak", displayMode: .inline)
            #endif
            .background(backgroundColor)
        }
        .sheet(isPresented: $presentTweakView) {
            NavigationView {
                viewModel.tweakView
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
