//
//  AppleSignInVC.m
//  HJTemplate
//
//  Created by zl on 2019/10/28.
//  Copyright © 2019 LG. All rights reserved.
//

#import "AppleSignInVC.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "YostarKeychain.h"
#import "HJCommonLib.h"

#define KEYCHAIN_IDENTIFIER(a) ([NSString stringWithFormat:@"%@_%@",[[NSBundle mainBundle] bundleIdentifier],a])

@interface AppleSignInVC () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@property (weak, nonatomic) IBOutlet UILabel *userIdLab;
@property (weak, nonatomic) IBOutlet UILabel *giveNameLab;
@property (weak, nonatomic) IBOutlet UILabel *familyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;

@end

@implementation AppleSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Sign In with Apple";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performExistingAccountSetupFlows];
}
- (void)configUI {
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearStoreInfo)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    if(@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleBlack];
        appleIDBtn.frame = CGRectMake(30, self.view.frame.size.height / 2 + 20, self.view.bounds.size.width - 60, 80);
        [appleIDBtn addTarget:self action:@selector(handleAuthorizationAppleIDButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDBtn];
    }
}
- (void)handleAuthorizationAppleIDButtonPress:(UIButton *)sender {
    if(@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [provider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        authorizationController.delegate = self;
        authorizationController.presentationContextProvider = self;
        [authorizationController performRequests];
    }
}
- (void)clearStoreInfo {
    [YostarKeychain delete:KEYCHAIN_IDENTIFIER(@"userIdentifier")];
    self.userIdLab.text = @"";
}
- (void)performExistingAccountSetupFlows {
    NSString *userId = [YostarKeychain load:KEYCHAIN_IDENTIFIER(@"userIdentifier")];
    if(userId.length > 0) {
        self.userIdLab.text = userId;
    }
}
#pragma mark  -  Delegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(nonnull ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    NSLog(@" -------- %@", authorization.credential);
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *user = credential.user;
        NSString *familyName = credential.fullName.familyName;
        NSString *giveName = credential.fullName.givenName;
        NSString *email = credential.email;
        NSData *identityToken = credential.identityToken;
        NSLog(@"token is :  %@",[[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding]);
        NSData *authorizationCode = credential.authorizationCode;
         NSLog(@"code is :  %@",[[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding]);
        self.userIdLab.text = user;
        self.familyNameLab.text = familyName;
        self.giveNameLab.text = giveName;
        self.emailLab.text = email;
        [YostarKeychain save:KEYCHAIN_IDENTIFIER(@"userIdentifier") data:user];
    } else if([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *pwdCredential = authorization.credential;
        NSString *user = pwdCredential.user;
        NSString *pwd = pwdCredential.password;
       self.userIdLab.text = user;
        NSLog(@"-%@", pwd);
    }
}
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            break;
        case ASAuthorizationErrorFailed:
            break;
        case ASAuthorizationErrorInvalidResponse:
            break;
        case ASAuthorizationErrorNotHandled:
            break;
        case ASAuthorizationErrorUnknown:
            break;
        default:
            break;
    }
    NSLog(@"%@", error.localizedDescription);
}
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return self.view.window;
}


@end
