//
//  PoiAnnotation.h
//  parcspirit
//
//  Created by Max on 15/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PoiAnnotation : MKPointAnnotation
@property int type;
@property (nonatomic,strong) NSDictionary * PoiDic;
@end
