//
//  RequestManager.m
//  parcspirit
//
//  Created by Max on 20/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager


- (instancetype)init
{
    self = [super init];
    
    /*
    if (self) {
    }
     */
    
    return self;
}

+(id)currentRequestManager
{
    static RequestManager *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil)
            sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

-(NSDictionary *)downloadParcList
{
    NSError * dlError;
    NSString * urlString = [NSString stringWithFormat:@"https://drive.google.com/uc?export=download&id=0B8kYg_hBEFpbQjNOMFNOcU94Nkk"];
    NSURL * parcUrl = [[NSURL alloc] initWithString:urlString];
    NSData * parcData = [NSData dataWithContentsOfURL:parcUrl];
    NSDictionary * dic;
    if (parcData) {
        dic = [NSJSONSerialization JSONObjectWithData:parcData
                                                             options:kNilOptions
                                                               error:&dlError];
    }
    
    return dic;
    
}

-(NSDictionary *)downloadVersion
{
    NSError * dlError;
    NSString * urlString = [NSString stringWithFormat:@"https://drive.google.com/uc?export=download&id=0B8kYg_hBEFpbZFUwNVE3bjVGZU0"];
    NSURL * versionUrl = [[NSURL alloc] initWithString:urlString];
    NSData * versionData = [NSData dataWithContentsOfURL:versionUrl];
    NSDictionary * dic;
    if (versionData) {
        dic = [NSJSONSerialization JSONObjectWithData:versionData
                                              options:kNilOptions
                                                error:&dlError];
    }
    
    return dic;
    
}

@end
