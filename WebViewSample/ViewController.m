//
//  ViewController.m
//  WebViewSample
//
//  Created by dmitry on 02/02/17.
//  Copyright © 2017 DSR. All rights reserved.
//


#import <WebKit/WebKit.h>
#import "ViewController.h"

@interface NotificationScriptMessageHandler : NSObject <WKScriptMessageHandler>


@end

@implementation NotificationScriptMessageHandler

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"message.body %@", message.body);
    NSLog(@"message.name %@", message.name);
}

@end

NSString *const defaultURLString = @"https://www.google.com";
NSString *const urlKey = @"url";

@class NotificationScriptMessageHandler;

@interface ViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *webViewURLString;

@property (nonatomic, strong) UIAlertAction *okAction;
@property (nonatomic, strong) NSString *temporaryURLString;


@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    self.view = self.webView;
}

- (WKWebView *)webView
{
    if (!_webView)
    {
        //NSString *source = @"document.body.style.background = \"#643\";";
        //NSString *source = @"window.webkit.messageHandlers.notification.postMessage('hello world!')";
        NSString *source = @"function timhook(){ return 'hello world';}; timhook();";
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addUserScript:userScript];
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        
        NotificationScriptMessageHandler *handler = [[NotificationScriptMessageHandler alloc] init];
        [userContentController addScriptMessageHandler:handler name:@"notification"];

        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        
        void (^handler1)(_Nullable id sa, NSError *_Nullable error) = ^void(_Nullable id sa, NSError * _Nullable error)
        {
        
        };
        
        [_webView evaluateJavaScript:source completionHandler:handler1];
    }
    return _webView;
}

- (NSString *)webViewURLString
{
    if (!_webViewURLString)
    {
        NSString *defaultsValue = [[NSUserDefaults standardUserDefaults] objectForKey:urlKey];
        if(!defaultsValue)
        {
            _webViewURLString = defaultURLString;
        }
        else
        {
            _webViewURLString = defaultsValue;
        }
    }
    return _webViewURLString;
}

- (void)loadURLString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadURLString:self.webViewURLString];
    [self setupEditButton];
}

- (void)setupEditButton
{
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"editPlaceholder", @"Edit")
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(editButtonPressed)];
    self.navigationItem.rightBarButtonItem = editBarButtonItem;
}

- (void)editButtonPressed
{
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:NSLocalizedString(@"changeURLPlaceholder", @"Change url")
                                            message:@""
                                     preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"urlPlaceholder", @"enter your url");
            textField.text = self.webViewURLString;
            [textField addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
            textField.keyboardType = UIKeyboardTypeURL;
    }];

    __weak typeof (self)welf = self;
    void (^okHandler)(UIAlertAction *action) = ^void(UIAlertAction *action)
    {
        welf.webViewURLString = welf.temporaryURLString;
        [welf saveURLToStorage:welf.webViewURLString];
        [welf loadURLString:welf.webViewURLString];
    };
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"okPlaceholder", @"OK action")
                                                       style:UIAlertActionStyleDefault
                                                     handler:okHandler];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancelPlaceholder", @"Cancel action")
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];

    self.okAction = okAction;

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)validateUrl:(NSString *)candidate
{
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

#pragma mark - UITextField

- (void)checkTextField:(UIControl *)sender
{
    UITextField *textFiled = (UITextField *)sender;
    NSString *stringToCheck = textFiled.text;

    if ([self validateUrl:stringToCheck])
    {
        self.temporaryURLString = stringToCheck;
        self.okAction.enabled = YES;
    }
    else
    {
        self.okAction.enabled = NO;
    }
}

#pragma mark - WKNavigationDelegate

//- (void)webView:(WKWebView *)webView
//    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
//                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    decisionHandler(WKNavigationActionPolicyAllow);
//    NSLog(@"1");
//}
//
//- (void)webView:(WKWebView *)webView
//    decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
//                      decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
//
//{
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    NSLog(@"2");
//}
//
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
//{
//    NSLog(@"3");
//}
//
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
//{
//    NSLog(@"4");
//}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"invalidURLPlaceholder", @"Invalid url")
                                        message:NSLocalizedString(@"invalidURLMessagePlaceholder", @"Please, check your url once again")
                                 preferredStyle:UIAlertControllerStyleAlert];

    
    __weak typeof (self)welf = self;
    void (^okHandler)(UIAlertAction *action) = ^void(UIAlertAction *action)
    {
        [welf editButtonPressed];
    };

    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"okPlaceholder", @"OK action")
                                                       style:UIAlertActionStyleDefault
                                                     handler:okHandler];
    
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}
//
//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
//{
//    NSLog(@"6");
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
//{
//    NSLog(@"7");
//}
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
//{
//    NSLog(@"8");
//}
//
//- (void)webView:(WKWebView *)webView
//    didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//                    completionHandler:
//                        (void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *_Nullable credential))completionHandler
//{
//    //completionHandler(NSURLSessionAuthChallengeUseCredential, )
//    NSLog(@"9");
//}
//
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
//{
//    NSLog(@"10");
//}

#pragma mark - storage

-(void)saveURLToStorage:(NSString*)urlString
{
    [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:urlKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
