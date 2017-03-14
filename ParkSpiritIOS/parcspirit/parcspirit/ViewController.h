//
//  ViewController.h
//  parcspirit
//
//  Created by Max on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "Constant.h"
#import "PoiAnnotation.h"
#import "POIDetailViewController.h"
#import "RequestManager.h"


@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *VefaView;
/*
@property (weak, nonatomic) IBOutlet UIView *LocationView;
@property (weak, nonatomic) IBOutlet UIView *AchieveView;
@property (weak, nonatomic) IBOutlet UIView *CEMView;
 */
@property (weak, nonatomic) IBOutlet UIButton *VEFASelectorButton;
@property (weak, nonatomic) IBOutlet UIButton *AchievedSelectorButton;
@property (weak, nonatomic) IBOutlet UIButton *CEMSelectorButton;
@property (weak, nonatomic) IBOutlet UIButton *LocationSelectorButton;



@property (weak, nonatomic) IBOutlet UIView *AllView;
@property (weak, nonatomic) IBOutlet UITableView *POITableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyParcLabel;

@property (weak, nonatomic) IBOutlet UILabel *CategoryLabel;
 
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ViewSelector;

@property (strong, nonatomic) NSDictionary *POIDictionnary;
@property (strong, nonatomic) NSMutableArray *localPOIArray;

@property (weak, nonatomic) IBOutlet UIImageView *logoEmptyImView;

- (IBAction)selectorValueChanged:(UISegmentedControl *)sender;

- (IBAction)VEFAButtonPushed:(id)sender;
- (IBAction)AchevedButtonPushed:(id)sender;
- (IBAction)CEMButtonPushed:(id)sender;
- (IBAction)LocationButtonPushed:(id)sender;



@end

