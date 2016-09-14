//
//  ViewController0.swift
//  Swipe Navigation Xcode 7
//
//  Created by PJ Vea on 7/22/15.
//  Copyright © 2015 Vea Software. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController0: UIViewController {
   
    @IBOutlet weak var pictureTaken:UIImageView!
    @IBOutlet weak var photoPreview: UIView!
    @IBOutlet weak var photoButton: UIButton!
    
    var videoSession = AVCaptureSession()
    var videoOutput = AVCaptureVideoDataOutput()
    var pictureOutput = AVCaptureStillImageOutput()
    var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // get the camera device
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in devices {
            // the back camera
            if device.position == AVCaptureDevicePosition.Back{
                // try to use the camera
                do {
                    let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    startPictureSession(input)
                    //                    startVideoSession(input)
                }
                catch{
                    print("---> Cannot use the camera")
                }
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // start recording and streaming
    @IBAction func startStreaming(sender: AnyObject) {
        print("---> Starting to stream video")
        if let video = videoOutput.connectionWithMediaType(AVMediaTypeVideo){
            let buffer = videoOutput.sampleBufferDelegate
            print(buffer)
        }
    }
    
    // capture still image
    @IBAction func captureStillImage(sender: AnyObject){
        if let picture = pictureOutput.connectionWithMediaType(AVMediaTypeVideo){
            pictureOutput.captureStillImageAsynchronouslyFromConnection(picture, completionHandler: {
                buffer, error in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
            })
        }
    }
    
    func startPictureSession(input: AVCaptureDeviceInput){
        // check if the camera is available
        if videoSession.canAddInput(input){
            // save the session
            videoSession.addInput(input)
            // output the session
            pictureOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            // if can add the output
            if videoSession.canAddOutput(pictureOutput){
                videoSession.addOutput(pictureOutput)
                videoSession.startRunning()
                // apply this to the preview layer
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: videoSession)
                // resize the video to fill
                videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                // position the layer
                videoPreviewLayer.position = CGPoint(x: self.photoPreview.frame.width/2, y: self.photoPreview.frame.height/2)
                videoPreviewLayer.bounds = self.photoPreview.frame
                
                // add the preview to the view
                photoPreview.layer.addSublayer(videoPreviewLayer)
            }
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

}