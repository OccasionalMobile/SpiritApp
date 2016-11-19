//
//  DataManager.m
//  parcspirit
//
//  Created by Max on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()
@property (strong, nonatomic)  NSDictionary *tmpParcList;

@end

@implementation DataManager

- (instancetype)init
{
    self = [super init];
    
    
    if (self) {
        _currentManager=self;
    }
    
    return self;
}

+(id)currentDataManager
{
    static DataManager *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil)
            sharedManager = [[self alloc] init];
    }
    return sharedManager;
}


-(void)getLocalData
{
    NSString * parcListString;
    
    NSError *deserializingError;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"parclist" ofType:@"json"];

    NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
    NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
    NSDictionary * downloadedParcDic = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                                options:NSJSONReadingMutableLeaves
                                                  error:&deserializingError];
    _tmpParcList = [NSDictionary dictionaryWithDictionary:[downloadedParcDic objectForKey:@"kml"]];
    [self simplifyData];
}

-(void)simplifyData
{
    NSMutableDictionary *parcDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *folderArray = [[NSMutableArray alloc] init];

    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    NSMutableArray * tmpPOIArray = [[NSMutableArray alloc] init];

    
    [folderArray addObjectsFromArray:[[_tmpParcList objectForKey:@"Document"] objectForKey:@"Folder"]];

    for (NSDictionary * dic in folderArray) {
        NSMutableDictionary * tmpDic = [[NSMutableDictionary alloc] init];
        
        [tmpDic setValue:[dic objectForKey:@"Placemark"] forKey:[dic objectForKey:@"name"]];
        [tmpPOIArray addObjectsFromArray:[dic objectForKey:@"Placemark"]];

        NSString * keyName = [dic objectForKey:@"name"];
        
        if ([keyName containsString:@"V.E.F.A"])
            [categoryDic setValue:keyName forKey:keyVEFA];
        if ([keyName containsString:@"Location." ])
            [categoryDic setValue:keyName forKey:keyLocation];
        if ([keyName containsString:@"Achevés"])
            [categoryDic setValue:keyName forKey:keyAchieved];
        if ([keyName containsString:@"main"])
            [categoryDic setValue:keyName forKey:keyCEM];

        [parcDic addEntriesFromDictionary:tmpDic];
        tmpDic = nil;
    }
    _categoryKeyDic = [NSDictionary dictionaryWithDictionary:categoryDic];
    _parcList = [NSDictionary dictionaryWithDictionary:parcDic];
    _allParcArray = [NSArray arrayWithArray:tmpPOIArray];
    tmpPOIArray = nil;
    _tmpParcList = nil;
    categoryDic = nil;
    folderArray = nil;
    parcDic = nil;
    
}

@end
