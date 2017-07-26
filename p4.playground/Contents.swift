// https://gist.github.com/ilyapuchka/1ae19259161a91f3a8a8

import UIKit

struct MainScene {
    let vc: UIViewController
    let nc: UINavigationController
    init(vc: UIViewController) {
        self.vc = vc
        self.nc = UINavigationController(rootViewController: vc)
    }
}

extension UIViewController {
    class func viewController(color: UIColor) -> UIViewController {
        let vc = UIViewController()
        vc.view = UIView(frame: UIScreen.main.bounds)
        vc.view.backgroundColor = color
        return vc
    }
}

class ButtonHandler: NSObject {
    let scene: MainScene
    init(scene: MainScene) {
        self.scene = scene
        super.init()
    }
    
    func buttonPressed(sender:UIButton) {
        println("button pressed")
        let vc = UIViewController.viewController(color: UIColor.yellowColor())
        self.scene.nc.pushViewController(vc, animated: true)
    }
}

let vc = UIViewController.viewController(color: UIColor.greenColor())
vc.title = "title"

let button = UIButton.withType(.System) as UIButton
button.setTitle("press me", for: UIControlState.Normal)
button.sizeToFit()
button.center = vc.view.center
vc.view.addSubview(button)

let mainScene = MainScene(vc: vc)

let handeler = ButtonHandler(scene: mainScene)

button.addTarget(handeler, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)


//Run playground
let window = UIWindow(frame: UIScreen.mainScreen.bounds)
window.rootViewController = mainScene.nc
window.makeKeyAndVisible()
CFRunLoopRun()
