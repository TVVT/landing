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
    
    
//    @IBAction func photoBtn(sender: AnyObject) {
//        
//        takePhoto()
//        
//    }
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
            
            focusTo(Float(0.5))
            
            let minISO = device.activeFormat.minISO
            
            device.setExposureModeCustomWithDuration(AVCaptureExposureDurationCurrent, ISO: minISO, completionHandler: { (time) -> Void in
                //
            })
//            println(device.maxWhiteBalanceGain);
            
            
            //find out at http://digital-lighting.150m.com/ch08lev1sec3.html
            

            device.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(AVCaptureWhiteBalanceGains(redGain: 2.75,greenGain: 1.4,blueGain: 2.7), completionHandler: nil)
            
            println(device.ISO);
            
            device.unlockForConfiguration()
        }
        
    }

    func beginSession() {
        
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        //添加outputs
        captureSession.addOutput(AVCaptureStillImageOutput())
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = CGRect(x: 0, y: 0, width: self.view.layer.frame.width, height: self.view.layer.frame.height)
        captureSession.startRunning()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.32, target: self, selector: Selector("takePhoto"), userInfo: nil, repeats: true)

    }
    
    
    func takePhoto(){
        let outPut:AVCaptureStillImageOutput = captureSession.outputs[0] as AVCaptureStillImageOutput
        let inPut:AVCaptureInput = captureSession.inputs[0] as AVCaptureInput
        println(outPut.connections.count)
        var connection:AVCaptureConnection = outPut.connections[0] as AVCaptureConnection
        outPut.captureStillImageAsynchronouslyFromConnection(connection, completionHandler:{
            (buffer: CMSampleBuffer!,error:NSError!) in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)

            let image:UIImage = UIImage(data: imageData)!
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
        })
        
        
    }
    
    func handler(buffer:CMSampleBufferRef,error:NSError){
        
    }
    

    
    
    

    
    

    
    
}

