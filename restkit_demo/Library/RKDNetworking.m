//
//  RKDNetworking.m
//  restkit_demo
//
//  Created by Andrea Dal Ponte on 22/10/13.
//  Copyright (c) 2013 ACME Inc. All rights reserved.
//

#import "RKDNetworking.h"
#import <RestKit/RestKit.h>
#import "RKDCompany.h"

@implementation RKDNetworking

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setupRestKit];
    }
    
    return self;
}


# pragma mark - Setup Methods

- (void)setupRestKit
{
    // Object magager
    NSURL *baseApiUrl = [NSURL URLWithString:@"https://api.parse.com/1/classes/"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseApiUrl];
    [RKObjectManager setSharedManager:objectManager];
    
    //Header auth
    NSString *appId = @"9iAK0wz3ot3BCNGRjAjilu8lh5sQmeZkBUr9GXHJ";
    NSString *restKey = @"Vflbewcl5FxcarCFzQRt6z5DII219d5tDQpFbPQ9";
    [objectManager.HTTPClient setDefaultHeader:@"X-Parse-Application-Id" value:appId];
    [objectManager.HTTPClient setDefaultHeader:@"X-Parse-REST-API-KEY" value:restKey];
    
    // Format
    objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    // Resource mapping
    RKObjectMapping *companyMapping = [RKObjectMapping mappingForClass:[RKDCompany class]];
    [companyMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"name" toKeyPath:@"name"]];
    [companyMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"email" toKeyPath:@"email"]];
    [companyMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"objectId" toKeyPath:@"objectId"]];

    // Responce
    RKResponseDescriptor *companyResponse = [RKResponseDescriptor responseDescriptorWithMapping:companyMapping method:RKRequestMethodGET pathPattern:@"Company" keyPath:@"results" statusCodes:nil];
    [objectManager addResponseDescriptor:companyResponse];
    
    RKResponseDescriptor *companyResponsePost = [RKResponseDescriptor responseDescriptorWithMapping:companyMapping method:RKRequestMethodPOST pathPattern:@"Company" keyPath:nil statusCodes:nil];
    [objectManager addResponseDescriptor:companyResponsePost];
    
    RKResponseDescriptor *getCompanyResponse = [RKResponseDescriptor responseDescriptorWithMapping:companyMapping method:RKRequestMethodAny pathPattern:@"Company/:objectId" keyPath:nil statusCodes:nil];
    [objectManager addResponseDescriptor:getCompanyResponse];
    
    // Request
    RKRequestDescriptor *companyRequest = [RKRequestDescriptor requestDescriptorWithMapping:[companyMapping inverseMapping] objectClass:[RKDCompany class] rootKeyPath:nil method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:companyRequest];
    
    // Routing
    RKRoute *companyRouteGet = [RKRoute routeWithClass:[RKDCompany class] pathPattern:@"Company/:objectId" method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:companyRouteGet];
    
    RKRoute *companyRoutePost = [RKRoute routeWithClass:[RKDCompany class] pathPattern:@"Company" method:RKRequestMethodPOST];
    [objectManager.router.routeSet addRoute:companyRoutePost];
}

# pragma mark - API Methods

- (void)companies:(RKDNetworkingCompaniesBlock)completion
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"Company" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        completion(mappingResult.array, nil);
    }
    failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        completion(nil, error);
    }];
}

- (void)getCompany:(RKDCompany *)company completion:(RKDNetworkingCompanyBlock)completion
{
     [[RKObjectManager sharedManager] getObject:company path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         completion(mappingResult.firstObject, nil);
     }
     failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         completion(nil, error);
     }];
}

- (void)addCompany:(RKDCompany *)company completion:(RKDNetworkingCompanyBlock)completion
{
    [[RKObjectManager sharedManager] postObject:company path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         completion(mappingResult.firstObject, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
         completion(nil, error);
    }];
}

@end
