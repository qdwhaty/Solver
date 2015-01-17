//
//  ViewController.swift
//  KeyboardCustom
//
//  Created by edi on 09.01.2015.
//  Copyright (c) 2015 edi. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var chars: [UIButton]!
    @IBOutlet var __inputTfd: UITextField!
    @IBOutlet var __keyboardView : UIView!
    @IBOutlet var __webView: UIWebView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println( chars.count );
        __webView.loadRequest( NSURLRequest( URL: NSURL( string: "http://www.geteasysolution.com/")! ) );
        __inputTfd.delegate = self;
       
        //ukryj systemowa klawiature
        __inputTfd.inputView = UIView( frame: CGRectMake(0, 0, 1, 1) );
        
        //animacja klawiatury
        
        hideKeyboard(0, delay: 0);
        
        //reklamy
        // self.canDisplayBannerAds = true
                self.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Automatic
        //self.requestInterstitialAdPresentation()
              //  self.interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Manual
               // self.requestInterstitialAdPresentation()
        
        
        //self.requestInterstitialAdPresentation()
    }
    
    override func viewWillAppear(animated: Bool) {
        NSLog("Requesting")
        self.requestInterstitialAdPresentation()
    }
    
    
    
    
        override func viewDidLayoutSubviews()
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        hideKeyboard( 1, delay: 0 );
        
        self.view.endEditing(true);
        super.touchesBegan(touches, withEvent: event);
        //self.requestInterstitialAdPresentation()
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
        
        hideKeyboard( 1, delay: 0 );
    }
    
    @IBAction func actionKeyTouchDown(sender: UIButton)
    {
        println( sender );
        
        sender.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0.95, alpha: 0.1).CGColor;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        return true;
    }
    
    func clearKeyBackgroundColor( sender : UIButton )
    {
         sender.layer.backgroundColor = UIColor.whiteColor().CGColor;
    }
    
    @IBAction func actionKeyPressed(sender: UIButton)
    {
        println( sender.titleLabel?.text );
        
        clearKeyBackgroundColor( sender );
        
        var key:String = sender.titleLabel!.text!;
        //var str:String = __inputTfd.text;
        
        //var pos = __inputTfd.getpo //caretRectForPosition( __inputTfd.selectedTextRange?.start );
        //println( "pos: \(pos)" );
        
        if( key == "deleteAll")
        {
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

            hideKeyboard( 1, delay: 0 );
            sendRequest( __inputTfd.text );
            self.requestInterstitialAdPresentation()
            return;
        }
        
        //println( str )
        
        __inputTfd.insertText( sender.titleLabel!.text! );
    }
    
    func sendRequest( equationStr__:String )
    {
        println("sendRequest \( equationStr__ )");
        
        __webView.loadRequest( NSURLRequest( URL: NSURL( string: "http://www.geteasysolution.com/" + equationStr__.stringByAddingPercentEscapesUsingEncoding( NSUTF8StringEncoding )! )! ) );
    }
    
    func hideKeyboard( time:NSTimeInterval, delay:NSTimeInterval )
    {
        println("hideKeyboard");
        
        UIView.animateWithDuration( time, delay: delay, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5, options: nil, animations:
            {
                self.__keyboardView.transform = CGAffineTransformMakeTranslation(0,  self.__keyboardView.frame.height + 100 )
            },
            completion:
            {
                success in
                println( "keyboard is hidden ");
            })
        //self.requestInterstitialAdPresentation()
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

