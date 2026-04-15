//
//  LogInViewController.swift
//  team39_FinalProject
//
//  Created by user269131 on 12/4/24.
//

import UIKit

class LogInViewController: UIViewController {
    

    //MARK: add the view to this controller while the view is loading...
    
    private let landingView = LandingView()

    override func loadView() {
        view = landingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        landingView.signInButton.addTarget(self, action: #selector(onSignInTapped), for: .touchUpInside)
        landingView.signUpButton.addTarget(self, action: #selector(onSignUpTapped), for: .touchUpInside)
    }
    
    @objc private func onSignInTapped() {
        let loginViewController = LoginViewControllerMain()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc private func onSignUpTapped() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
}
