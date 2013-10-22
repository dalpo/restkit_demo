//
//  RKDViewController.m
//  restkit_demo
//
//  Created by Andrea Dal Ponte on 22/10/13.
//  Copyright (c) 2013 ACME Inc. All rights reserved.
//

#import "RKDViewController.h"
#import "RKDNetworking.h"

@interface RKDViewController ()

@property (strong, nonatomic) RKDNetworking *networking;

@end

@implementation RKDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.networking = [[RKDNetworking alloc] init];
    
    [self.networking companies:^(NSArray *elements, NSError *error) {
        if (nil == error)
        {
            NSLog(@"elements: %@", elements);
        }
    }];
    
    RKDCompany *company = [[RKDCompany alloc] init];
    company.objectId = @"InUmxdJisz";
    
    [self.networking getCompany:company completion:^(RKDCompany *element, NSError *error)
    {
        if (nil == error)
        {
            NSLog(@"company: %@", element);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCompanyButtonTouched:(id)sender
{
    RKDCompany *company = [[RKDCompany alloc] init];
    
    company.name = @"Metalabs";
    company.email = @"info@metalabs.net";
    
    [self.networking addCompany:company completion:^(RKDCompany *element, NSError *error){
        if(nil == error)
        {
            NSLog(@"Company saved with id: %@", element.objectId);
        }
    }];
    
}
@end
