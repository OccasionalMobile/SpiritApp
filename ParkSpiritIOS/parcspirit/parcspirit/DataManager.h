//
//  DataManager.h
//  parcspirit
//
//  Created by Max on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@interface DataManager : NSObject
{

}

@property (strong, nonatomic)  DataManager *currentManager;

@property (strong, nonatomic)  NSDictionary *parcList;
@property (strong, nonatomic)  NSDictionary *categoryKeyDic;
@property (strong, nonatomic)  NSArray *allParcArray;

-(void) getLocalData;
+(id)currentDataManager;

@end
