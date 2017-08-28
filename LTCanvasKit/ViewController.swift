//
//  ViewController.swift
//  LTCanvasKit
//
//  Created by ltebean on 8/24/17.
//  Copyright © 2017 ltebean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: LTCanvasView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        canvasView.add(object: LTCanvasObject(frame: CGRect(x: 50, y: 50, width: 100, height: 100)))
        canvasView.add(object: LTCanvasObject(frame: CGRect(x: 50, y: 200, width: 100, height: 100)))
    }

    @IBAction func toBack(_ sender: Any) {
        guard let object = canvasView.objectInEditing else { return }
        canvasView.sendObject(toBack: object)
    }
    
    @IBAction func toFront(_ sender: Any) {
        guard let object = canvasView.objectInEditing else { return }
        canvasView.bringObject(toFront: object)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

