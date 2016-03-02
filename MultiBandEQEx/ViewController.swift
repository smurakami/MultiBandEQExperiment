//
//  ViewController.swift
//  MultiBandEQEx
//
//  Created by 村上晋太郎 on 2016/03/02.
//  Copyright © 2016年 R. Fushimi and S. Murakami. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()
    
    let equalizer = AVAudioUnitEQ(numberOfBands: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup equalizer
        let bands = equalizer.bands
        
        let param = bands.first!
        param.filterType = .LowPass
        param.frequency = 440
        param.bypass = false
        
        // setup player
        let path = NSBundle.mainBundle().pathForResource("sound", ofType: "mp3")!
        let url = NSURL(fileURLWithPath: path)
        let file = try! AVAudioFile(forReading: url)
        
        // setup engine
        engine.attachNode(player)
        engine.attachNode(equalizer)
//        engine.connect(player, to: engine.mainMixerNode, format: file.processingFormat)
        engine.connect(player, to: equalizer, format: file.processingFormat)
        engine.connect(equalizer, to: engine.mainMixerNode, format: file.processingFormat)
        try! engine.start()
        
        // start playing
        let buffer = AVAudioPCMBuffer(PCMFormat: file.processingFormat, frameCapacity: UInt32(file.length))
        try! file.readIntoBuffer(buffer)
        
        player.scheduleBuffer(buffer, atTime: nil, options: .Loops, completionHandler: nil)
        player.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

