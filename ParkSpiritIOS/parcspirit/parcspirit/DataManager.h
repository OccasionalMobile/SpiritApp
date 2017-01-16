//
//  DataManager.h
//  parcspirit
//
//  Created by Max on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "RequestManager.h"
@interface DataManager : NSObject
{

}

@property (strong, nonatomic)  DataManager *currentManager;

@property (strong, nonatomic)  NSDictionary *tmpParcList;


@property (strong, nonatomic)  NSDictionary *parcList;
@property (strong, nonatomic)  NSDictionary *categoryKeyDic;
@property (strong, nonatomic)  NSArray *allParcArray;

@property BOOL requestResult;


-(BOOL)getRemoteData;
-(void) getLocalData;
+(id)currentDataManager;
-(BOOL)checkifVersionChanged;

-(void)simplifyData;


-(void)storeParcData:(NSDictionary *)parcData;
-(NSDictionary *)loadParcData;
-(UIImage *)getParcImageFromName:(NSString *)parcName andCategorie:(NSString *)ParcCategorie;
@end
