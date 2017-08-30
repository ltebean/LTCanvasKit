//
//  LTCanvasView.swift
//  LTCanvasKit
//
//  Created by ltebean on 8/24/17.
//  Copyright © 2017 ltebean. All rights reserved.
//

import UIKit

class LTCanvasView: UIView {

    var objects: [LTCanvasObject] = []
    
    var objectInEditing: LTCanvasObject?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LTCanvasView.handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    func add(object: LTCanvasObject) {
        objects.append(object)
        addSubview(object.view)
    }
    
    func bringObject(toFront object: LTCanvasObject) {
        guard let index = objects.index(of: object) else { return }
        bringSubview(toFront: object.view)
        objects.remove(at: index)
        objects.append(object)
    }
    
    func sendObject(toBack object: LTCanvasObject) {
        guard let index = objects.index(of: object) else { return }
        sendSubview(toBack: object.view)
        objects.remove(at: index)
        objects.insert(object, at: 0)
    }
    
    func edit(object: LTCanvasObject) {
        objects.forEach({
            $0.isEditing = (object == $0)
        })
    }

    
    func handleTap(_ gesture: UITapGestureRecognizer) {
        guard  gesture.state == .ended else { return }
        let location = gesture.location(in: self)
        if let object = objects.reversed().filter({ $0.view.frame.contains(location) }).first {
            objectInEditing = object
            objects.forEach({ o in
                if o == object {
                    o.isEditing = true
                } else {
                    o.isEditing = false
                }
            })
        }
        
    }

}
