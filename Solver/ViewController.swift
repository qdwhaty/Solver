//
//  ViewController.swift
//  KeyboardCustom
//
//  Created by edi on 09.01.2015.
//  Copyright (c) 2015 edi. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, UITextFieldDelegate, ADBannerViewDelegate, ADInterstitialAdDelegate {
    
    @IBOutlet var chars: [UIButton]!
    @IBOutlet var __inputTfd: UITextField!
    @IBOutlet var __keyboardView : UIView!
    @IBOutlet var __webView: UIWebView!
    
    
    
    var bannerView:ADBannerView?
    var interstitialAdView:ADInterstitialAd?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println( chars.count );
        __webView.loadRequest( NSURLRequest( URL: NSURL( string: "http://www.geteasysolution.com/")! ) );
        __inputTfd.delegate = self;
       
        //ukryj systemowa klawiature
        __inputTfd.inputView = UIView( frame: CGRectMake(0, 0, 1, 1) );
        
        //self.textfie.inputDelegate = self;
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        //animacja klawiatury
        
        UIView.animateWithDuration(0, delay: 0.0, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5, options: nil, animations:
            {
                self.__keyboardView.transform = CGAffineTransformMakeTranslation(0,  self.__keyboardView.frame.height + 200)
            }, completion: nil)
        
    
        //reklamy
        
        canDisplayBannerAds = true
        bannerView?.delegate = self
        bannerView?.hidden = true
        
        interstitialAdView = ADInterstitialAd()
        interstitialAdView!.delegate = self
        
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!)
    {
        //self.interstitialAdView.hidden = false;
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!)
    {
        
    }
    
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool
    {
        return true;
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView?.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool
    {
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView?.hidden = true
    }
    
    
    
    func kolka ()
    {
    
        //okrogle butony
        var c:UIButton;
        
        for c in chars
        {
            //println( c.titleLabel?.text );
            //println( c.frame.size.width );
            
            c.layer.masksToBounds = true;
            c.layer.cornerRadius = c.frame.size.height / 2;
        }

    
    }
    override func viewDidLayoutSubviews()
    {
        
        kolka()
        
           }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        println( "touchesBegan" );
        
        // __inputTfd.resignFirstResponder();
        
        hideKeyboard();
        
        self.view.endEditing(true);
        super.touchesBegan(touches, withEvent: event);
    }
    */
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        //println( "touchesBegan \( touches, event ) " );
        
        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView( self.view )
        
        println( "point \(point )" );
        println( "keyboardview \( __keyboardView.frame ) " );
        
        println( "is point inside \( CGRectContainsPoint( __keyboardView.frame, point ) )" );
        
        if( CGRectContainsPoint( __keyboardView.frame, point ) )
        {
            return;
        }
        
        /*
        for touch: AnyObject in touches
        {
        let location = touch.locationInView( self.view )
        //let touchedNode = self.nodeAtPoint(location)
        //println( "touch, \( touch, location ) " );
        
        if( touch.view is UIImageView )
        {
        println("tlo")
        return;
        }
        }
        */
        
        hideKeyboard();
        
        self.view.endEditing(true);
        super.touchesBegan(touches, withEvent: event);
    }
    
    
    
    
    
    
    
    override func canBecomeFirstResponder() -> Bool {
        return false;
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        println( "textFieldDidBeginEditing" )
        
        showKeyboard();
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        println( "textFieldDidEndEditing" )
        
        //hideKeyboard();
    }
    
    func textDidChange(textInput: UITextInput)
    {
        println("textDidChange");
    }
    
    @IBAction func actionKeyTouchDown(sender: UIButton)
    {
        println( sender );
        
        sender.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0.95, alpha: 0.1).CGColor;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        println("textField")
        println( range.location.successor() );
        
        return true;
    }
    
    @IBAction func actionKeyPressed(sender: UIButton)
    {
        println( sender );
        
        sender.layer.backgroundColor = UIColor.whiteColor().CGColor;
        
        println( sender.titleLabel?.text );
        
        var key:String = sender.titleLabel!.text!;
        //var str:String = __inputTfd.text;
        
        //var pos = __inputTfd.getpo //caretRectForPosition( __inputTfd.selectedTextRange?.start );
        //println( "pos: \(pos)" );
        
        if( key == "deleteAll")
        {
            //str = "";
            __inputTfd.text = "";
            
            return;
        }
        else if( key == "del" )
        {
            __inputTfd.deleteBackward();
            
            return;
        }
        else if( key == "enter")
        {
            self.view.endEditing(true);

            sendRequest();
            
            return;
        }
        
        //println( str )
        
        __inputTfd.insertText( sender.titleLabel!.text! )
        //__inputTfd.text = str;
        
    }
    
    func sendRequest()
    {
        println("sendRequest");
        
        hideKeyboard();
        /*
        let requestURL = NSURL( fileURLWithPath: "http://www.geteasysolution.com/" )
        let request = NSURLRequest( requestURL !)
        __webview.loadRequest( request )
        */
        
        __webView.loadRequest( NSURLRequest( URL: NSURL( string: "http://www.geteasysolution.com/" + __inputTfd.text )! ) );
    }
    
    func hideKeyboard()
    {
        println("hideKeyboard");
        
        //__keyboardView.frame.origin.y = self.view.frame.height - __keyboardView.frame.height;
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5, options: nil, animations:
            {
                self.__keyboardView.transform = CGAffineTransformMakeTranslation(0,  self.__keyboardView.frame.height + 100 )
            }, completion: nil)
        
    }
    
    func showKeyboard()
    {
        println("showKeyboard");
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5, options: nil, animations:
            {
                self.__keyboardView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
        
    }
}

