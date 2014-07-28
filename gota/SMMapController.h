//
//  SMMapController.h
//  gota
//
//  Created by James Haggerty on 28/07/2014.
//  Copyright (c) 2014 James Haggerty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface SMMapController : UIViewController

@property (weak, nonatomic) IBOutlet GLKView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
