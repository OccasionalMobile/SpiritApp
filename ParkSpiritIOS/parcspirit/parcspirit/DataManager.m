//
//  DataManager.m
//  parcspirit
//
//  Created by Max on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()
@property (nonatomic,strong) NSDictionary * imageDic;

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

-(BOOL)getRemoteData
{
    NSDictionary * dlDic = [[RequestManager currentRequestManager] downloadParcList];
    
    if (!dlDic && [dlDic count]<1) {
        [self setRequestResult:false];
        return false;
    }
    
    _tmpParcList = [NSDictionary dictionaryWithDictionary:[dlDic objectForKey:@"kml"]];

    if (_tmpParcList && [_tmpParcList count]>0) {
        [self storeParcData:_tmpParcList];// je stocke en local au cas oou
        [self storeLastUpdateDate];
        [self simplifyData];
        [self setRequestResult:true];
        return true;
    }else
    {
        [self setRequestResult:false];
        return false;
    }
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
-(BOOL)checkifVersionChanged
{
    BOOL shouldDL = false;
    NSDate * lastDate = [self getLastUpdateDate];
    NSDate * newDate;
    if (lastDate) {
        NSDictionary * dic = [[RequestManager currentRequestManager] downloadVersion];
        if (dic && [dic count]>0)
            newDate = [self extractDateFromDic:dic];// récupération de la date en ligne
        
        if ([newDate compare:lastDate] == NSOrderedDescending) {//La nouvelle date est plus recente donc je dl
            shouldDL = true;
        }else// la version stocker en local est plus récente que celle en ligne pas besoin de dl
        {
            shouldDL =false;
        }
        
    }
    else // il n'y a pas de date donc je lance d'office le ddl
    {
        shouldDL = true;
    }
    return shouldDL;
}

-(NSDate *)extractDateFromDic:(NSDictionary *) dic
{
    NSDate * date;
    NSString * dateString = [dic objectForKey:@"date"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [df dateFromString: dateString];
    return date;
}
#pragma mark UserDefaultManagement - 
-(void)storeParcData:(NSDictionary *)parcData
{
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:parcData];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ParcData"];
}
-(NSDictionary *)loadParcData
{
    NSDictionary * parcDic;
    //parcDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParcData"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"ParcData"];
    parcDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return parcDic;
}

-(void)storeLastUpdateDate

{
    NSDate * date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"LastStoredDate"];
}

-(NSDate *)getLastUpdateDate
{
    NSDate * lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastStoredDate"];
    
    return lastDate;
}

#pragma mark parc statique Image management -
-(UIImage *)getParcImageFromName:(NSString *)parcName andCategorie:(NSString *)ParcCategorie
{
    UIImage * parcImage;
    NSDictionary * localDic;
    if (!_imageDic || [_imageDic count]<1) {
        [self loadImageDic];
    }
    
    if (!_imageDic || [_imageDic count]<1) {
        return nil;
    }
    
    if ([ParcCategorie isEqualToString:keyVEFA]) {
        localDic = [_imageDic objectForKey:@"VEFA"];
        parcImage = [UIImage imageNamed:[localDic objectForKey:parcName]];
    }
    else if ([ParcCategorie isEqualToString:keyLocation]) {
        localDic = [_imageDic objectForKey:@"Location"];
        parcImage = [UIImage imageNamed:[localDic objectForKey:parcName]];
    }
    else if ([ParcCategorie isEqualToString:keyAchieved]) {
        localDic = [_imageDic objectForKey:@"Acheve"];
        parcImage = [UIImage imageNamed:[localDic objectForKey:parcName]];
    }
    else
    {
        parcImage = nil;
    }
    
    //parcImage = [UIImage imageNamed:@"acheve_stains"];

    return parcImage;
}

-(void)loadImageDic
{
    
    NSError *deserializingError;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Spirit_parc_images" ofType:@"json"];
    
    NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
    NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
    _imageDic = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                                                       options:NSJSONReadingMutableLeaves
                                                                         error:&deserializingError];
}

@end
