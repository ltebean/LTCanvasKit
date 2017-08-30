//
//  ViewController.swift
//  LTCanvasKit
//
//  Created by ltebean on 8/24/17.
//  Copyright © 2017 ltebean. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var canvasView: LTCanvasView!
    
    var cellInDragging: UICollectionViewCell?
    var cellSnapshot: UIView?
    var startCenter: CGPoint!
    var startLocation: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.dataSource = self
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view1 = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        view1.backgroundColor = UIColor.random()
        canvasView.add(object: LTCanvasObject(view: view1, center: CGPoint(x: 100, y : 100)))

        
        let drag = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleDrag(_:)))
        drag.minimumPressDuration = 0.3
        view.addGestureRecognizer(drag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func handleDrag(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: gesture.view)
        if gesture.state == .began {
            if let cell = collectionView.visibleCells.filter({ cell in
                let frame = cell.superview!.convert(cell.frame, to: view)
                return frame.contains(location)
            }).first {
                let frame = cell.superview!.convert(cell.frame, to: view)
                cellInDragging = cell
                cellSnapshot = cell.snapshotView(afterScreenUpdates: true)
                cellSnapshot!.alpha = 0.7
                cellSnapshot!.frame = frame
                view.addSubview(cellSnapshot!)
                startLocation = location
                startCenter = cellSnapshot!.center
            }
        }
        else if gesture.state == .changed {
            guard let cellSnapshot = cellSnapshot else { return }
            cellSnapshot.center = location
            cellSnapshot.center.x = location.x - startLocation.x + startCenter.x
            cellSnapshot.center.y = location.y - startLocation.y + startCenter.y
        }
        else if gesture.state == .ended {
            guard let cellSnapshot = cellSnapshot else { return }
            let center = cellSnapshot.center
            let view = UIView(frame: CGRect(x: 0, y: 0, width: cellSnapshot.frame.width, height: cellSnapshot.frame.height))
            view.backgroundColor = cellInDragging?.backgroundColor
            let object = LTCanvasObject(view: view, center: center)
            canvasView.add(object: object)
            canvasView.edit(object: object)
            cellSnapshot.removeFromSuperview()
            self.cellSnapshot = nil
            self.cellInDragging = nil
        }
    }

    @IBAction func toBack(_ sender: Any) {
        guard let object = canvasView.objectInEditing else { return }
        canvasView.sendObject(toBack: object)
    }
    
    @IBAction func toFront(_ sender: Any) {
        guard let object = canvasView.objectInEditing else { return }
        canvasView.bringObject(toFront: object)
    }


}

extension UIViewController: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.random()
        return cell
    }
}

