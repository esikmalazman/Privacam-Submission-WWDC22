//
//  File.swift
//  Private
//
//  Created by Ikmal Azman on 20/04/2022.
//

import UIKit

class IntroViewController : UIViewController {
    
    var explainBackgroundView : UIView!
    var explainLabel : UILabel!
    var continueButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryCream
        setupExplainBackgroundView()
        setupExplainLabel()
        setupContinueButton()
    }
    
    func setupExplainBackgroundView() {
        explainBackgroundView = createSimpleUIView(.secondaryLightBlue)
        explainBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        explainBackgroundView.layer.cornerRadius = 10
        view.addSubview(explainBackgroundView)
        
        NSLayoutConstraint.activate([
            explainBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            explainBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            explainBackgroundView.topAnchor.constraint(equalTo: guide.topAnchor),
            explainBackgroundView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10)
        ])
    }
    
    func setupExplainLabel() {
        explainLabel = createSimpleLabel(explainText, alignment: .justified, textColor: .black, numberOfLines: 0)
        if UIDevice.current.userInterfaceIdiom == .pad  {
            explainLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        } else {
            explainLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
        explainLabel.sizeToFit()
        explainBackgroundView.addSubview(explainLabel)
        
        NSLayoutConstraint.activate([
            explainLabel.topAnchor.constraint(equalTo: explainBackgroundView.topAnchor, constant: 15),
            explainLabel.leadingAnchor.constraint(equalTo: explainBackgroundView.leadingAnchor, constant: 15),
            explainLabel.trailingAnchor.constraint(equalTo: explainBackgroundView.trailingAnchor, constant: -15)
        ])
    }
    
    func setupContinueButton() {
        continueButton = createSimpleButton("Continue",textColor: .white, bgColor: .systemBlue, cornerRadius: 10)
        if UIDevice.current.userInterfaceIdiom == .pad  {
            continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        } else {
            continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        
        continueButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let action = UIAction { _ in
            let vc = LiveViewController()
#if targetEnvironment(simulator)
            let alert = self.createSimpleAlertController(message: "This app is not supported in simulator, please use physical device")
            self.present(alert, animated: true)
#else
            self.navigationController?.pushViewController(vc, animated: true)
#endif
            
        }
        continueButton.addAction(action, for: .touchUpInside)
        view.addSubview(continueButton)
        
        if UIDevice.current.userInterfaceIdiom == .pad  {
            NSLayoutConstraint.activate([
                continueButton.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: 50),
                continueButton.leadingAnchor.constraint(equalTo: explainBackgroundView.leadingAnchor, constant: 15),
                continueButton.trailingAnchor.constraint(equalTo: explainBackgroundView.trailingAnchor, constant: -15),
                continueButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        } else {
            NSLayoutConstraint.activate([
                continueButton.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: 30),
                continueButton.leadingAnchor.constraint(equalTo: explainBackgroundView.leadingAnchor, constant: 15),
                continueButton.trailingAnchor.constraint(equalTo: explainBackgroundView.trailingAnchor, constant: -15),
                continueButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
    }
    
    let explainText = "Humans can now solve complex problems like face detection and person segmentation using rapidly evolving computer vision technologies. The camera on smartphones can be easily accessed by pulling it out of the pocket and recording. People also take advantage of this to engage in illegal behaviour, such as recording in public without permission. For example, in 2019, the Swedish Data Protection Authority fined a school for launching a facial recognition pilot program without obtaining consent from students or the Data Protection Authority.\nThis project shows how to use face detection to protect others' privacy in public. PrivateCam is a video recorder app that lets you censor someone's face and protect their privacy. Other use cases include crime interviews in which we want to anonymise the witness and protect ourselves from potential crime/threats. So I was inspired to make this app to help other authorities utilise this technology to protect people who have been recording without their consent.\nBy tapping continue button, the app will ask for permission to use your camera. After granting access, you'll see a preview of your back camera's view and a record button. The app will then detect and censor other people's faces with a white square box. Then, tap the record button, and the app will ask for your permission to record your screen. Finally, you can stop recording by tapping a stop button, displaying a recording preview. You can trim it in the preview and save it to your album."
}





/*
 Humans can now solve complex problems like face detection and person segmentation using rapidly evolving computer vision technologies. The camera on smartphones can be easily accessed by pulling it out of the pocket and recording. People also take advantage of this to engage in illegal behaviour, such as recording in public without permission. For example, in 2019, the Swedish Data Protection Authority fined a school for launching a facial recognition pilot program without obtaining consent from students or the Data Protection Authority. This project shows how to use face detection to protect others' privacy in public. PrivateCam is a video recorder app that lets you censor someone's face and protect their privacy. Other use cases include crime interviews in which we want to anonymise the witness and protect ourselves from potential crime/threats. So I was inspired to make this app to help other authorities utilise this technology to protect people who have been recording without their consent. By tapping continue button, the app will ask for permission to use your camera. After granting access, you'll see a preview of your back camera's view and a record button. The app will then detect and censor other people's faces with a white square box. Then, tap the record button, and the app will ask for your permission to record your screen. Finally, you can stop recording by tapping a stop button, displaying a recording preview. You can trim it in the preview and save it to your album.
 */
