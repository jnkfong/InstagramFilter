//
//  EditVideoUtility.swift
//  InstagramFilter
//
//  Created by James Fong on 2018-01-07.
//  Copyright © 2018 James Fong. All rights reserved.
//

import Foundation
import AVKit

extension AVAsset {
    static func squareCropVideo(inputURL: NSURL, completion: @escaping (_ outputURL : NSURL?) -> ())
    {
        let videoAsset: AVAsset = AVAsset( url: inputURL as URL )
        let clipVideoTrack = videoAsset.tracks( withMediaType: AVMediaType.video ).first! as AVAssetTrack
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize( width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.height )
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
        
        transformer.setTransform(configureTransformation(clipVideoTrack: clipVideoTrack), at: kCMTimeZero)
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exportSession = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        let fileName: String = NSUUID().uuidString
        let croppedOutputFileUrl = URL( fileURLWithPath: NSTemporaryDirectory() + fileName + ".mov")
        
        exportSession.outputURL = croppedOutputFileUrl
        exportSession.outputFileType = AVFileType.mov
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously(completionHandler: {
            print("completion")
            if exportSession.status == .completed {
                DispatchQueue.main.async(execute: {
                    completion(croppedOutputFileUrl as NSURL)
                })
                return
            } else if exportSession.status == .failed {
                print("Export failed - \(String(describing: exportSession.error))")
            }
            
            completion(nil)
            return
        })
    }
    
    static func configureTransformation(clipVideoTrack:AVAssetTrack) -> CGAffineTransform {
        
        if(clipVideoTrack.naturalSize.width == clipVideoTrack.naturalSize.height){
            return clipVideoTrack.preferredTransform
        }
        
        let videoTransform:CGAffineTransform = clipVideoTrack.preferredTransform
        let orientation:UIInterfaceOrientation = getVideoOrientation(transform: videoTransform, track: clipVideoTrack)
        let transform1: CGAffineTransform
        var transform2: CGAffineTransform
        switch(orientation){
        case .portrait:
            transform1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
            transform2 = transform1.rotated(by: .pi/2)
            break
        case .portraitUpsideDown:
            transform1 = CGAffineTransform(translationX: 0, y:clipVideoTrack.naturalSize.width - ((clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2))
            transform2 = transform1.rotated(by: -.pi/2)
            break
        case .landscapeLeft:
            transform1 = CGAffineTransform(translationX:clipVideoTrack.naturalSize.width - ((clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2), y: clipVideoTrack.naturalSize.height)
            transform2 = transform1.rotated(by: .pi)
            break
        case .landscapeRight:
            transform1 = CGAffineTransform(translationX:0 - ((clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2),y: 0);
            transform2 =  transform1.rotated(by: 0)
            break
        default:
            transform1 = videoTransform
            transform2 = transform1.rotated(by: 0)
            break
        }
        
        return transform2
    }
    
    static func getVideoOrientation(transform:CGAffineTransform, track: AVAssetTrack) -> UIInterfaceOrientation {
        switch (transform.tx, transform.ty) {
        case (0, 0):
            return .landscapeRight
        case (track.naturalSize.width, track.naturalSize.height):
            return .landscapeLeft
        case (0, track.naturalSize.width):
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    func videoToUIImage()->UIImage {
        var image = UIImage()
        do {
            let imgGenerator = AVAssetImageGenerator(asset: self)
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 60), actualTime: nil)
            image = UIImage(cgImage: cgImage, scale:1.0, orientation: self.videoToUIImageOrientation())
        }
        catch let error {
            print(error.localizedDescription)
        }
        return image
    }
    
    private func videoToUIImageOrientation() -> UIImageOrientation{
        let clipVideoTrack:AVAssetTrack = self.tracks( withMediaType: AVMediaType.video ).first!
        let videoTransform:CGAffineTransform = clipVideoTrack.preferredTransform
        let videoUIInterfaceOrientation: UIInterfaceOrientation = AVAsset.getVideoOrientation(transform: videoTransform, track: clipVideoTrack)
        switch videoUIInterfaceOrientation {
        case .landscapeLeft:
            return UIImageOrientation.down
        case .landscapeRight:
            return UIImageOrientation.up
        case .portrait :
            return UIImageOrientation.right
        case .portraitUpsideDown :
            return UIImageOrientation.left
        default:
            return UIImageOrientation.right
        }
        
    }
    
    func exportFilterVideo(videoComposition:AVVideoComposition , completion: @escaping (_ outputURL : NSURL?) -> ()) {
        let exportSession = AVAssetExportSession(asset: self, presetName: AVAssetExportPresetHighestQuality)!
        let croppedOutputFileUrl = URL( fileURLWithPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")
        exportSession.outputURL = croppedOutputFileUrl
        exportSession.outputFileType = AVFileType.mov
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously(completionHandler: {
            guard exportSession.status != .failed else {
                completion(nil)
                return
            }
            if exportSession.status == .completed {
                DispatchQueue.main.async(execute: {
                    completion(croppedOutputFileUrl as NSURL)
                })
            }
            else {
                completion(nil)
            }
        })
    }


}
