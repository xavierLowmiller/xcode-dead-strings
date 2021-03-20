//
//  SwiftViewController.swift
//  MixedObjCProjectForLocalizedString
//
//  Created by Xaver Lohmüller on 20.03.21.
//

import UIKit
import SwiftUI

final class SwiftViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = NSLocalizedString("my_swift_view_controller", comment: "")

        let button = UIButton(type: .custom, primaryAction: UIAction { _ in
            let host = UIHostingController(rootView: ContentView())
            self.present(host, animated: true)
        })
        button.setTitle(NSLocalizedString("push_second_vc", comment: ""), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
}
