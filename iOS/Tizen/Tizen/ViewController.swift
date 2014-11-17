//
//  ViewController.swift
//  Tizen
//
//  Created by wov on 11/13/14.
//  Copyright (c) 2014 EIZ. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController {
    let captureSession = AVCaptureSession()
    
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var input : AVCaptureInput?


    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        let devices = AVCaptureDevice.devices();
        
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    input = AVCaptureDeviceInput(device: device as AVCaptureDevice, error: nil)
                    
                    
                    
                }
            }
        }
        if captureDevice != nil {
            beginSession()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            if(device.lockForConfiguration(nil)) {
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    //
                })
                device.unlockForConfiguration()
            }
        }
    }
    
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var anyTouch = touches.anyObject() as UITouch
        var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var anyTouch = touches.anyObject() as UITouch
        var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    

    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = AVCaptureFocusMode.Locked
            device.whiteBalanceMode = AVCaptureWhiteBalanceMode.Locked
            
            let minISO = device.activeFormat.minISO
            
            device.setExposureModeCustomWithDuration(AVCaptureExposureDurationCurrent, ISO: minISO, completionHandler: { (time) -> Void in
                //
            })
            println(device.maxWhiteBalanceGain);

        
            
            //find out at http://digital-lighting.150m.com/ch08lev1sec3.html
            

            device.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(AVCaptureWhiteBalanceGains(redGain: 2.2,greenGain: 1.0,blueGain: 1.7), completionHandler: nil)
            
            
//            device.setExposureModeCustomWithDuration(CMTime(value: 1, timescale: 2, flags: CMTimeFlags.allZeros, epoch: CMTimeEpoch.allZeros), ISO: 100 , completionHandler: nil )
            
            
            println(device.ISO);
            
            device.unlockForConfiguration()
        }
        
    }

    func beginSession() {
        
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    
    
    
    func takePhoto(){
    
    
    
    }
    
    
    
//    
//    func takePhoto(){
//        
//        
//        if let stillOutput = self.stillImageOutput {
//            // we do this on another thread so that we don't hang the UI
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//                //find the video connection
//                var videoConnection : AVCaptureConnection?
//                for connecton in stillOutput.connections {
//                    //find a matching input port
//                    for port in connecton.inputPorts!{
//                        if port.mediaType == AVMediaTypeVideo {
//                            videoConnection = connecton as? AVCaptureConnection
//                            break //for port
//                        }
//                    }
//                    
//                    if videoConnection  != nil {
//                        break// for connections
//                    }
//                }
//                if videoConnection  != nil {
//                    stillOutput.captureStillImageAsynchronouslyFromConnection(videoConnection){
//                        (imageSampleBuffer : CMSampleBuffer!, _) in
//                        
//                        let imageDataJpeg = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
//                        var pickedImage: UIImage = UIImage(data: imageDataJpeg)!
//                        
//                        let scaledImage:UIImage = self.squareImageFromImage(pickedImage, newSize: 320.0)
//                        //let scaledImage = self.imageWithImage(pickedImage, scaledToSize: CGSizeMake(320, 320))
//                        
//                        let imageData = UIImagePNGRepresentation(scaledImage)
//                        var imageFile:PFFile = PFFile(data: imageData)
//                        
//                        var userPost = PFObject(className:"UserPost")
//                        
//                        userPost["imageFile"] = imageFile
//                        userPost["from"] = PFUser.currentUser()
//                        userPost.saveInBackground()
//                        
//                        
//                    }
//                    self.captureSession.stopRunning()
//                }
//            }
//        }
//        println("take photo pressed")
//    }
    
    

    
    
}

