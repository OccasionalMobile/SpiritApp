//
//  RequestManager.h
//  parcspirit
//
//  Created by Max on 20/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestManager : NSObject

@property (strong, nonatomic)  RequestManager *currentManager;

-(NSDictionary *)downloadParcList;
-(NSDictionary *)downloadVersion;

+(id)currentRequestManager;

@end
