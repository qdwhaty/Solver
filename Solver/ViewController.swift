//
//  ViewController.swift
//  KeyboardCustom


import UIKit
import iAd

class ViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate, GADInterstitialDelegate
{
    
    @IBOutlet var chars: [UIButton]!
    @IBOutlet var __inputTfd: UITextField!
    @IBOutlet var __keyboardView : UIView!
    @IBOutlet var __webView: UIWebView!
    var l: CALayer{
        return __keyboardView.layer
    }

    private var __admobAds: GADInterstitial!
    private var __counter:uint = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //
        l.backgroundColor = UIColor.grayColor().CGColor
        l.borderWidth = 10.0
        l.borderColor = UIColor.clearColor().CGColor
        l.shadowOpacity = 0.7
        l.shadowRadius = 10.0
        
        
        //
        UIApplication.sharedApplication().statusBarHidden = true;
        
        __webView.delegate = self;
        //__webView.loadRequest( NSURLRequest( URL: NSURL( string: "http://www.geteasysolution.com/")! ) );
        __webView.loadHTMLString( NSLocalizedString("Help", comment:"" ), baseURL:nil );
        
        //ukryj systemowa klawiature / fake na klawiaturze
        __inputTfd.delegate = self;
        __inputTfd.inputView = UIView( frame: CGRectMake(0, 0, 1, 1) );
        
        //schowanie klawiatury
        hideKeyboard(0, delay: 0);
        
        println( NSLocalizedString( "Help", comment:"" ) )
        
        //reklamy
        canDisplayBannerAds = true;
        interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Automatic;
        
        __admobAds = createAndLoadInterstitial();
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSLog("Requesting")
        self.requestInterstitialAdPresentation()
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    override func viewDidLayoutSubviews()
    {
        //okragle butony
        var c:UIButton;
        
        for c in chars
        {
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
        
        hideKeyboard( 1, delay: 0 );
        
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
            
            __counter += 1;
            
            hideKeyboard( 1, delay: 0 );
            sendRequest( __inputTfd.text );
            
            return;
        }
        
        //println( str )
        
        __inputTfd.insertText( sender.titleLabel!.text! );
    }
    
    func sendRequest( equationStr__:String )
    {
        println("sendRequest \( equationStr__ )");
        
        if( __counter % 5 == 1 )
        {
            // wywolanie interstitialAd
            //self.requestInterstitialAdPresentation()
            
            // wywolanie admoba
            //
            
            println( "hasbeenUsed: \( __admobAds.hasBeenUsed )" );
            
            if( !__admobAds.hasBeenUsed && __admobAds.isReady )
            {
                __admobAds.presentFromRootViewController( self );
            }
        }
        
        __webView.loadRequest( NSURLRequest( URL: NSURL( string: "http://www.geteasysolution.com/" + equationStr__.stringByAddingPercentEscapesUsingEncoding( NSUTF8StringEncoding )! )! ) );
    }
    
    func hideKeyboard( time:NSTimeInterval, delay:NSTimeInterval )
    {
        println("hideKeyboard");
        
        UIView.animateWithDuration( time, delay: delay, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5, options: nil, animations:
            {
                self.__keyboardView.transform = CGAffineTransformMakeTranslation(0,  self.__keyboardView.frame.height + 200 )
            },
            completion:
            {
                success in
                println( "keyboard is closed ");
            })
    }
    
    func showKeyboard()
    {
        println("showKeyboard");
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5, options: nil, animations:
            {
                self.__keyboardView.transform = CGAffineTransformMakeTranslation(0, 0)
            },
            completion:
            {
                success in
                println( "keyboard is open ");
            })
    }
    
    //////////////////////////////////////////////////////////
    // uiwebview delegate funcs
    //////////////////////////////////////////////////////////
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        println( " content of website is loaded \( __counter )" );
        
        
    }
    
    ///
    // admob and delegate funcs
    ///
    
    func createAndLoadInterstitial() -> GADInterstitial
    {
        //reklamy googla
        //__admobAds = nil;
        var admobAds = GADInterstitial();
        admobAds.delegate = self;
        admobAds.adUnitID = "ca-app-pub-3940256099942544/4411468910";
        let request:GADRequest = GADRequest();
        request.testDevices = ["GAD_SIMULATOR_ID"];
        admobAds.loadRequest( GADRequest() );
        
        return admobAds;
    }
    
    func interstitialDidDismissScreen( ad: GADInterstitial! )
    {
        println( "interstitialDidDismissScreen" );
        
        __admobAds = createAndLoadInterstitial();
    }
    
}

