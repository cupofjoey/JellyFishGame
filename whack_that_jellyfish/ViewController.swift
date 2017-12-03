//
//  ViewController.swift
//  whack_that_jellyfish
//
//  Created by Joe Hill on 11/25/17.
//  Copyright © 2017 Dumb Unicorn. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var SceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.SceneView.session.run(configuration)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.SceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(_ sender: Any) {
        self.addNode()
        self.play.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
        
    }
    
    func addNode() {
        let jellyFishScene = SCNScene(named: "art.scnassets/Jellyfish.dataset/Jellyfish.scn")
        let jellyFishNode = jellyFishScene?.rootNode.childNode(withName: "Jellyfish", recursively: false)
        jellyFishNode?.position = SCNVector3(randomNumbers(firstNum: -1, secondNum: 1),randomNumbers(firstNum: -0.5, secondNum: 0.5),randomNumbers(firstNum: -1, secondNum: 1))
        self.SceneView.scene.rootNode.addChildNode(jellyFishNode!)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("Didn't touch anything")
        } else {
            let results = hitTest.first!
            let node = results.node
            if node.animationKeys.isEmpty {
                self.animateNode(node: node)
                node.removeFromParentNode()
            }
        }
    }
    
    func animateNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(node.presentation.position.x - 0.2,node.presentation.position.y - 0.2, node.presentation.position.z - 0.2)
        spin.duration = 0.08
        spin.autoreverses = true
        spin.repeatCount = 5
        node.addAnimation(spin, forKey: "position")
    }
    
}

func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}










