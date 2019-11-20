//
//  SignInVC.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 20/07/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class SignInVC: UIViewController {
    private(set) var button = GIDSignInButton()
    override func viewDidLoad() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    override func loadView() {
        self.view = button
    }
}
