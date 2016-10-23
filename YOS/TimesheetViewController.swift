//
//  TimesheetViewController.swift
//  YOS
//
//  Created by Zhongtian Chen on 10/19/16.
//  Copyright © 2016 University High School. All rights reserved.
//

import UIKit

class TimesheetViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingLabel.isHidden = false
        let myURL = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScjaCp-T-iwksvDHsN-DM0o4kGZRhchLB5puebiiJvLdnnj1w/viewform")
        let myRequest = URLRequest(url: myURL!)
        webView.delegate = self
        webView.loadRequest(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingLabel.isHidden = true
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
