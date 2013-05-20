//
//  GHR_RootViewController.h
//  Github Reader
//
//  Created by Christopher Apolzon on 5/19/13.
//  Copyright (c) 2013 Apples on the Tree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UAGithubEngine/UAGithubEngine.h>

@interface GHR_RootViewController : UIViewController
@property (nonatomic, readwrite) UAGithubEngine* gh_engine;
@end
