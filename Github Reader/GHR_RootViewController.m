//
//  GHR_RootViewController.m
//  Github Reader
//
//  Created by Christopher Apolzon on 5/19/13.
//  Copyright (c) 2013 Apples on the Tree. All rights reserved.
//

#import "GHR_RootViewController.h"
#import <UAGithubEngine/UAGithubEngine.h>

@interface GHR_RootViewController ()

@end

@implementation GHR_RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView {
    UIWindow* app_window = [[UIApplication sharedApplication] keyWindow];
    UIView* base_view = [[UIView alloc] initWithFrame:[app_window frame]];
    base_view.backgroundColor = [UIColor greenColor];
    self.view = base_view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel* app_label = [[UILabel alloc] init];
    [self.view addSubview:app_label];
    app_label.text = @"Github Reader Application";
    app_label.autoresizingMask = (
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin
    );
    [app_label sizeToFit];
    app_label.backgroundColor = [UIColor clearColor];
    app_label.center = CGPointMake(CGRectGetMidX(self.view.frame), 25);
    app_label.frame = CGRectIntegral(app_label.frame);
    
    UITextField* username_text_field = [[UITextField alloc] init];
    username_text_field.tag = 1;
    username_text_field.delegate = (id)self;
    username_text_field.borderStyle = UITextBorderStyleRoundedRect;
    username_text_field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    username_text_field.keyboardType = UIKeyboardTypeEmailAddress;
    username_text_field.backgroundColor = [UIColor whiteColor];
    username_text_field.placeholder = @"GitHub Username";
    username_text_field.autoresizingMask = (
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleRightMargin
    );
    [username_text_field sizeToFit];
    CGRect username_frame = username_text_field.frame;
    username_frame.origin.y = app_label.frame.origin.y + 50;
    username_frame.origin.x = 20;
    username_frame.size.width = (self.view.frame.size.width*2/3);
    username_text_field.frame = username_frame;
    
    UITextField* password_text_field = [[UITextField alloc] init];
    password_text_field.tag = 2;
    password_text_field.delegate = (id)self;
    password_text_field.borderStyle = UITextBorderStyleRoundedRect;
    password_text_field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    password_text_field.secureTextEntry = YES;
    password_text_field.backgroundColor = [UIColor whiteColor];
    password_text_field.placeholder = @"GitHub Password";
    password_text_field.autoresizingMask = (
        UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleRightMargin
    );
    [password_text_field sizeToFit];
    CGRect password_frame = password_text_field.frame;
    password_frame.origin.y = username_frame.origin.y + username_frame.size.height + 10;
    password_frame.origin.x = 20;
    password_frame.size.width = username_frame.size.width;
    password_text_field.frame = password_frame;

    UIButton* login_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    login_button.tag = 3;
    [login_button setTitle:@"Do Login" forState:UIControlStateNormal];
    [login_button sizeToFit];

    [login_button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect login_frame = login_button.frame;
    login_frame.origin.x = 20;
    login_frame.origin.y = password_frame.origin.y + password_frame.size.height + 20;
    login_button.frame = login_frame;
    
    [self.view addSubview: username_text_field];
    [self.view addSubview: password_text_field];
    [self.view addSubview: login_button];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UIButton action handler:
- (void)handleClick:(id)button {
    NSLog(@"HANDLED CLICK!");
    UITextField* username_field = (UITextField*)[self.view viewWithTag:1];
    UITextField* password_field = (UITextField*)[self.view viewWithTag:2];
    UIButton* login_button = (UIButton*)[self.view viewWithTag:3];

    NSLog(@"attempting to contact github!");
    NSLog(@"username val: %@", username_field.text);
    NSLog(@"password val: %@", password_field.text);
    
    UAGithubEngine* engine = [[UAGithubEngine alloc] initWithUsername:username_field.text password:password_field.text withReachability:YES];
    [engine repositoriesWithSuccess:^(id response) {
        NSLog(@"LOOPING");
        NSMutableArray* repo_names = [NSMutableArray arrayWithCapacity:[response count]];
        for(NSDictionary* repo in response) {
            [repo_names addObject:[repo objectForKey:@"full_name"]];
        }
        NSLog(@"FINISHED LOOP");
        NSLog(@"repo names: %@", repo_names);
        [login_button setTitle:@"SUCCESS" forState:UIControlStateNormal];
    } failure:^(NSError* err) {
        NSLog(@"GITHUB FAIL -- %@", err);
        [login_button setTitle:@"FAILURE" forState:UIControlStateNormal];
    }];
}

// UITextFieldDelegate methods:
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    [self handleClick:nil];
    return NO;
}

@end
