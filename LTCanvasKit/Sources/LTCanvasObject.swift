//
//  LTCanvasObject.swift
//  LTCanvasKit
//
//  Created by ltebean on 8/24/17.
//  Copyright © 2017 ltebean. All rights reserved.
//

import UIKit

class LTCanvasObject: NSObject {

    let view = UILabel()
    
    var isAjustingPerspective = false
    
    var isEditing = false {
        didSet {
            view.isUserInteractionEnabled = isEditing
            view.layer.borderWidth = isEditing ? 3 : 0
        }
    }
    
    convenience init(frame: CGRect) {
        self.init()
        view.frame = frame
        setupGestures()
        view.layer.borderColor = UIColor.blue.cgColor
        view.text = "haaha"
        view.textAlignment = .center
        view.backgroundColor = UIColor.red
        isEditing = false
    }
    
    func setupGestures() {

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(LTCanvasObject.handlePinch(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(LTCanvasObject.handlePan(_:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(LTCanvasObject.handleRotate(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(LTCanvasObject.handleLongPress(_:)))
        
        pinchGesture.delegate = self
        panGesture.delegate = self
        rotateGesture.delegate = self
        longPressGesture.delegate = self
        
        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(rotateGesture)
        // view.addGestureRecognizer(longPressGesture)

    }
    
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        let center = view.center
        let width = view.bounds.width
        let height = view.bounds.height
        view.bounds = CGRect(x: 0, y: 0, width: width * gesture.scale, height: height * gesture.scale)
        view.center = center
        gesture.scale = 1
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .changed else { return }
        let translation = gesture.translation(in: view)
        if isAjustingPerspective {
            var transform = view.layer.transform
            transform.m34 = 1.0 / -600.0
            transform = CATransform3DRotate(transform, translation.x * CGFloat(M_PI_2) / 100, 0, 1, 0);
            view.layer.transform = transform
            gesture.setTranslation(CGPoint.zero, in: view)
        } else {
            view.layer.transform = CATransform3DTranslate(view.layer.transform, translation.x, translation.y, 0)
            gesture.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            isAjustingPerspective = true
        }
        if gesture.state == .ended {
            isAjustingPerspective = false
        }

    }
    
    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        view.layer.transform = CATransform3DRotate(view.layer.transform, gesture.rotation, 0, 0, 1)
//        view.transform = view.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
}

extension LTCanvasObject: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
