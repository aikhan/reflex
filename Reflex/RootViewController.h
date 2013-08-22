//
//  RootViewController.h
//  Reflex
//
//  Created by Arslan Malik on 9/22/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController {
    UIInterfaceOrientation lastOrientation;
    
}
@property (nonatomic, strong)UIView *loadingView;
@property (nonatomic, strong)IBOutlet UIActivityIndicatorView *spinnerView;
- (void)showLoadingView;
- (void)hideLoadingView;
@end
