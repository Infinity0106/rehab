//
//  EjerciciosViewController.swift
//  rehab
//
//  Created by Infinity0106 on 3/14/18.
//  Copyright © 2018 Bernardo Orozco Garza. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class EjerciciosViewController: UIViewController {
    
    @IBOutlet weak var playerView: UIView!
    
    var player = AVPlayer()
    var playerController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpVideo();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpVideo(){
        let videoURL = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/rehab-e26f7.appspot.com/o/prueba.mp4?alt=media")
        player = AVPlayer(url: videoURL! as URL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.addChildViewController(playerController)
        
        // Add your view Frame
        playerController.view.frame = self.playerView.frame;
        
        // Add sub view in your view
        self.view.addSubview(playerController.view)
        player.play()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
