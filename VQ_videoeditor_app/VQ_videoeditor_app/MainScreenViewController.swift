//
//  MainScreenViewController.swift
//  VQ_videoeditor_app
//
//  Created by Roman Kravtsov on 08/07/2019.
//  Copyright © 2019 Roman Kravtsov. All rights reserved.
//

import UIKit
import AVKit

class MainScreenViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let mintGreen = UIColor(red: 0.44, green: 0.81, blue: 0.59, alpha: 1.0)
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 5
        }
    }
   
    @IBAction func button5(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @IBOutlet weak var framesCollectionView: UICollectionView! {
        didSet {
            framesCollectionView.dataSource = self
            framesCollectionView.delegate = self
        }
    }
    
    @IBOutlet var firstFrame: UIImageView!
    
    var videoURL: URL? {
        didSet {
            guard let videoURL = videoURL else { return }
            getVideoFrames(videoURL: videoURL)
        }
    }
    private var frames = [UIImage]()
    private var generator: AVAssetImageGenerator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstFrame.image = frames.first
        
        let lineOrigin = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY)
        let lineEnd = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 185)
        let line = UIBezierPath()
        line.move(to: lineOrigin)
        line.addLine(to: lineEnd)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = line.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0).cgColor
        view.layer.addSublayer(shapeLayer)
        
    }
    
    private func getVideoFrames(videoURL: URL) {
        let asset = AVAsset(url: videoURL)
        let duration = CMTimeGetSeconds(asset.duration)
        generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        for index in 0..<Int(duration) {
            getFrame(fromTime: Float64(index))
        }
        
    }
    
    private func getFrame(fromTime: Float64) {
        let time = CMTimeMakeWithSeconds(fromTime, preferredTimescale: 600)
        if let image = try? generator.copyCGImage(at: time, actualTime: nil) {
            frames.append(UIImage(cgImage: image))
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Frame", for: indexPath) as? FrameCell else {
            fatalError("Unable to dequeue Frame cell")
        }
        
        cell.frameImage.image = frames[indexPath.item]
        cell.frameImage.layer.cornerRadius = 3
        
        cell.soundImage.image = UIImage.equalizerImage.getRandomEqualizerImage()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 180)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDidEnd(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDidEnd(scrollView)
    }
    
    func scrollDidEnd(_ scrollView: UIScrollView) {
        
        let centerPoint = CGPoint(x: 185, y: 695)
        let collectionViewCenterPoint = view.convert(centerPoint, to: framesCollectionView)
        
        if let indexPath = framesCollectionView.indexPathForItem(at: collectionViewCenterPoint) {
            if let collectionViewCell = framesCollectionView.cellForItem(at: indexPath) as? FrameCell {
                collectionViewCell.frameImage.backgroundColor = mintGreen
                firstFrame.image = frames[indexPath.item]
            }
            
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollWillBegin(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollWillBegin(scrollView)
    }
    
    func scrollWillBegin(_ scrollView: UIScrollView) {
        for index in 0..<frames.count {
            if let cell = framesCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? FrameCell {
                if cell.frameImage.backgroundColor == mintGreen {
                    cell.frameImage.backgroundColor = .lightGray
                }
            }
        }
    }
    
}
