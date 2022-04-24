//
//  File.swift
//  Private
//
//  Created by Ikmal Azman on 20/04/2022.
//

import UIKit

class WelcomeViewController : UIViewController {
    
    var headerLabel : UILabel!
    var authorlabel : UILabel!
    var learnMoreButton : UIButton!
    var landingImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryCream
        setupHeaderLabel()
        setupAuthorLabel()
        setupLearnMoreButton()
        setupIntroImageView()
    }
    
    func setupIntroImageView() {
        landingImageView = UIImageView()
        landingImageView.image = UIImage(named: "camera_launchscreen")
        landingImageView.contentMode = .scaleAspectFit
        landingImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(landingImageView)
        if UIDevice.current.userInterfaceIdiom == .pad  {
            NSLayoutConstraint.activate([
                landingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                landingImageView.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -25),
                landingImageView.heightAnchor.constraint(equalToConstant: 400),
                landingImageView.widthAnchor.constraint(equalToConstant: 400)
            ])
        } else {
            NSLayoutConstraint.activate([
                landingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                landingImageView.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -25),
                landingImageView.heightAnchor.constraint(equalToConstant: 250),
                landingImageView.widthAnchor.constraint(equalToConstant: 250)
            ])
        }
        
    }
    
    func setupHeaderLabel() {
        headerLabel = createSimpleLabel("Privacy Camera", alignment: .left, textColor: .black, numberOfLines: 0)
        if UIDevice.current.userInterfaceIdiom == .pad  {
            headerLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        } else {
            headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        }
        view.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            headerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupAuthorLabel() {
        authorlabel = createSimpleLabel("Ikmal Azman", alignment: .left, textColor: .gray, numberOfLines: 0)
        if UIDevice.current.userInterfaceIdiom == .pad  {
            authorlabel.font = UIFont.systemFont(ofSize: 25)
        } else {
            authorlabel.font = UIFont.systemFont(ofSize: 20)
        }
        view.addSubview(authorlabel)
        NSLayoutConstraint.activate([
            authorlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            authorlabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func setupLearnMoreButton() {
        learnMoreButton = createSimpleButton("Get Started",textColor: .white, bgColor: .systemBlue, cornerRadius: 10)
        if UIDevice.current.userInterfaceIdiom == .pad  {
            learnMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        } else {
            learnMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        learnMoreButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let action = UIAction { _ in
            let vc = IntroViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        learnMoreButton.addAction(action, for: .touchUpInside)
        view.addSubview(learnMoreButton)
        
        NSLayoutConstraint.activate([
            learnMoreButton.topAnchor.constraint(equalTo: authorlabel.bottomAnchor, constant: 25),
            learnMoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
