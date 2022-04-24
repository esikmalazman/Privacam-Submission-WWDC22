import UIKit

class MainSceneDelegate: NSObject, UIWindowSceneDelegate {
    var window:UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let vc = WelcomeViewController()
            let navController = UINavigationController(rootViewController: vc)

            window.rootViewController = navController
            window.makeKeyAndVisible()
            window.overrideUserInterfaceStyle = .light
            self.window = window
        }
    }
}



