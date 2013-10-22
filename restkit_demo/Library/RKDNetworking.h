//
//  RKDNetworking.h
//  restkit_demo
//
//  Created by Andrea Dal Ponte on 22/10/13.
//  Copyright (c) 2013 ACME Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKDCompany.h"

typedef void(^RKDNetworkingCompaniesBlock)(NSArray *elements, NSError *error);
typedef void(^RKDNetworkingCompanyBlock)(id element, NSError *error);

@interface RKDNetworking : NSObject

- (void)companies:(RKDNetworkingCompaniesBlock)completion;
- (void)getCompany:(RKDCompany *)company completion:(RKDNetworkingCompanyBlock)completion;
- (void)addCompany:(RKDCompany *)company completion:(RKDNetworkingCompanyBlock)completion;

@end
