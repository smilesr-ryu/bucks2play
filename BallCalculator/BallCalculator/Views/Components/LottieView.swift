//
//  LottieView.swift
//  BallCalculator
//
//  Created by Yunki on 5/1/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let randomNumber: Int
    let loopMode: LottieLoopMode
    
    var name: String {
        switch randomNumber {
        case 0:
            return "ausopen"
        case 1:
            return "rolandgarros"
        case 2:
            return "us"
        case 3:
            return "wimbledon"
        default:
            return "ausopen"
        }
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()

        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
