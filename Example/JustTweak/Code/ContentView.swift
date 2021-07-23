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
                    .gesture(doubleTapGesture)
                    .simultaneousGesture(singleTapGesture)

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
            .navigationBarTitle("JustTweak", displayMode: .inline)
            .background(backgroundColor)
        }
        .sheet(isPresented: $presentTweakView) { viewModel.tweakView }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("The Meaning of Life"),
                message: Text(String(describing: viewModel.tweakAccessor.meaningOfLife)),
                dismissButton: .default(Text("OK"))
            )
        }
    }

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

}
