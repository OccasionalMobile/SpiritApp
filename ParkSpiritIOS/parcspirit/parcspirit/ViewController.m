//
//  ViewController.m
//  parcspirit
//
//  Created by Max on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "ViewController.h"
#import <Crashlytics/Crashlytics.h>

/*
#define SegmentVefa 0
#define SegmentLocation 1
#define SegmentAchieved 2
#define SegmentCEM 3
#define SegmentAll 4
*/
#define SegmentListe 0
#define SegmentMap 1


#define PinVefa 1
#define PinLocation 2
#define PinAchieved 3
#define PinCEM 4

@interface ViewController ()
@property int selectedPin;
@property (strong,nonatomic) NSDictionary * selectedPoi;
@property (strong,nonatomic) NSString * nextTitle;
@property (strong,nonatomic) NSString * currentCategorie;
@property (strong,nonatomic) NSMutableArray * VefaPoiArray;
@property (strong,nonatomic) NSMutableArray * LocationPoiArray;
@property (strong,nonatomic) NSMutableArray * AchievedPoiArray;
@property (strong,nonatomic) NSMutableArray * CEMPoiArray;

@property BOOL isfirstLaunch;
@property NSString * catKey;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_VefaView setHidden:false]; // a l'arrivé on affiche que la premiere vue
    [_AllView setHidden:true];
    _POIDictionnary = [[NSDictionary alloc] init];
    _localPOIArray = [[NSMutableArray alloc] init];
    
    _VefaPoiArray = [[NSMutableArray alloc] init];
    _LocationPoiArray = [[NSMutableArray alloc] init];
    _AchievedPoiArray = [[NSMutableArray alloc] init];
    _CEMPoiArray = [[NSMutableArray alloc] init];

    
    
    [_MapView setDelegate:self];
    _selectedPin = 0;
    [self prepareTheMap ];
    _isfirstLaunch = true;
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    if (_isfirstLaunch) {
        [self initcontext];
        _isfirstLaunch = false;
    }
    
    [_POITableView reloadData];

    
    
}

-(void)initcontext
{
    _POIDictionnary = [NSDictionary dictionaryWithDictionary:[[DataManager currentDataManager] parcList]];
    
    NSString * catKey;
    _currentCategorie = keyVEFA;
    catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyVEFA];
    //_localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
    [_CategoryLabel setText:catKey];
    
    [self addPOIToTheMap ];
    
}
- (IBAction)selectorValueChanged:(UISegmentedControl *)sender {
    
    NSString * catKey;
    
    if (sender.selectedSegmentIndex == SegmentListe) {
        //_currentCategorie = keyVEFA;
        //catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyVEFA];
        
        [_VefaView setHidden:false];
        [_AllView setHidden:true];
    }else
    {
        catKey = @"Tous nos parcs";
        [_VefaView setHidden:true];
        [_AllView setHidden:false];
    }
    
    /*
    if (sender.selectedSegmentIndex == SegmentVefa) {
        _currentCategorie = keyVEFA;
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyVEFA];
        _localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
        
        [_VefaView setHidden:false];
        [_AllView setHidden:true];
    }else if (sender.selectedSegmentIndex == SegmentLocation)
    {
        _currentCategorie = keyLocation;
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyLocation];
        _localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
        [_VefaView setHidden:false];
        [_AllView setHidden:true];
    }else if (sender.selectedSegmentIndex == SegmentAchieved) {
        _currentCategorie = keyAchieved;
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyAchieved];
        _localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
        [_VefaView setHidden:false];
        [_AllView setHidden:true];
    }else if (sender.selectedSegmentIndex == SegmentCEM) {
        _currentCategorie = keyCEM;
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyCEM];
        _localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
        [_VefaView setHidden:false];
        [_AllView setHidden:true];
    }else
    {
        catKey = @"Tous nos parcs";
        [_VefaView setHidden:true];
        [_AllView setHidden:false];
    }
    */
    
    [_CategoryLabel setText:catKey];
    [_POITableView reloadData];
    
}


#pragma mark Selection des parcs -

- (IBAction)VEFAButtonPushed:(id)sender {
    [_VEFASelectorButton setSelected:![_VEFASelectorButton isSelected]];
    
    if ([_VEFASelectorButton isSelected]) {
        [self addPoiForKey:keyVEFA];
        [self addPoiToTheMapForKey:keyVEFA];
    } else {
        [self removePoiForKey:keyVEFA];
        [self removePoiFromTheMapForKey:keyVEFA];

    }
    
    [_POITableView reloadData];
}


- (IBAction)AchevedButtonPushed:(id)sender {
    [_AchievedSelectorButton setSelected:![_AchievedSelectorButton isSelected]];
    
    if ([_AchievedSelectorButton isSelected]) {
        [self addPoiForKey:keyAchieved];
        [self addPoiToTheMapForKey:keyAchieved];
    } else {
        [self removePoiForKey:keyAchieved];
        [self removePoiFromTheMapForKey:keyAchieved];
    }
    
    [_POITableView reloadData];
}

- (IBAction)CEMButtonPushed:(id)sender {
    [_CEMSelectorButton setSelected:![_CEMSelectorButton isSelected]];
    if ([_CEMSelectorButton isSelected]) {
        [self addPoiForKey:keyCEM];
        [self addPoiToTheMapForKey:keyCEM];
    } else {
        [self removePoiForKey:keyCEM];
        [self removePoiFromTheMapForKey:keyCEM];
    }
    [_POITableView reloadData];
}

- (IBAction)LocationButtonPushed:(id)sender {
    [_LocationSelectorButton setSelected:![_LocationSelectorButton isSelected]];
    if ([_LocationSelectorButton isSelected]) {
        [self addPoiForKey:keyLocation];
        [self addPoiToTheMapForKey:keyLocation];
    } else {
        [self removePoiForKey:keyLocation];
        [self removePoiFromTheMapForKey:keyLocation];
    }
    [_POITableView reloadData];
}

#pragma mark Ajout des parc à la liste  -


-(void)removePoiForKey:(NSString *)key
{
    _catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:key];
    [_localPOIArray removeObjectsInArray:[[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:_catKey]]];
    
}


-(void)addPoiForKey:(NSString *)key
{
    _catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:key];
    [_localPOIArray addObjectsFromArray:[[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:_catKey]]];
    
}


-(void)addPoiToTheMapForKey:(NSString *)key
{
 
    NSArray * annoArray;// = [[NSArray alloc] init];
    
    if ([key isEqualToString:keyVEFA]) {
        annoArray = [NSArray arrayWithArray:_VefaPoiArray];
    }
    else  if ([key isEqualToString:keyLocation]) {
        annoArray = [NSArray arrayWithArray:_LocationPoiArray];
    }
    else  if ([key isEqualToString:keyCEM]) {
        annoArray = [NSArray arrayWithArray:_CEMPoiArray];
    }
    else  if ([key isEqualToString:keyAchieved]) {
        annoArray = [NSArray arrayWithArray:_AchievedPoiArray];
    }
    
        
        
    [_MapView addAnnotations:annoArray];

    
}

-(void)removePoiFromTheMapForKey:(NSString *)key
{
    NSArray * annoArray;// = [[NSArray alloc] init];
    
    if ([key isEqualToString:keyVEFA]) {
        annoArray = [NSArray arrayWithArray:_VefaPoiArray];
    }
    else  if ([key isEqualToString:keyLocation]) {
        annoArray = [NSArray arrayWithArray:_LocationPoiArray];
    }
    else  if ([key isEqualToString:keyCEM]) {
        annoArray = [NSArray arrayWithArray:_CEMPoiArray];
    }
    else  if ([key isEqualToString:keyAchieved]) {
        annoArray = [NSArray arrayWithArray:_AchievedPoiArray];
    }
    
    
    
    [_MapView removeAnnotations:annoArray];

}

#pragma mark Tableview dataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * catKey;
    NSInteger nbRow = 0;
    nbRow = [_localPOIArray count];
    
    return nbRow;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];

    /*
     *   If the cell is nil it means no cell was available for reuse and that we should
     *   create a new one.
     */
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIdentifier"] ;
    }
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        NSDictionary * POI = [_localPOIArray objectAtIndex:[indexPath row]];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellIdentifier"] ;
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setText:[POI objectForKey:@"name"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedPoi = [NSDictionary dictionaryWithDictionary:[_localPOIArray objectAtIndex:[indexPath row]]];
    
    _nextTitle = [_selectedPoi  objectForKey:@"name"];
    [self performSegueWithIdentifier:@"showPoiDetails" sender:self];
}
#pragma mark mapView Management  -
-(CLLocationCoordinate2D) getCoordianteFromString: (NSString *) coordinateInstring
{
    float lat = 0;
    float longi = 0;
    NSRange  comaRange = [coordinateInstring rangeOfString:@","];
    NSString * latString = [coordinateInstring substringToIndex:comaRange.location];
    
    NSString * leftString = [coordinateInstring substringFromIndex:comaRange.location+1];
    NSRange  ndComaRange = [leftString rangeOfString:@","];
    
    NSString * longiString = [leftString substringToIndex:ndComaRange.location];

    lat = [latString floatValue];
    longi = [longiString floatValue];
    
    
    return CLLocationCoordinate2DMake(longi,lat);
    
    
}
-(void)prepareTheMap
{
    
    CLLocation *parisCoordinate = [[CLLocation alloc] initWithLatitude:48.861774 longitude:2.340001];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(parisCoordinate.coordinate, 30000, 30000);
    [_MapView setRegion:[_MapView regionThatFits:region] animated:YES];
    
}
-(void)addPOIToTheMap
{
    //méthode déguelasse pour metre les POI par catégory
    NSArray * categorisedPOI;
    
    _selectedPin = 0;
    categorisedPOI = [_POIDictionnary objectForKey:[[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyVEFA]];
    for (NSDictionary * PoiDic in categorisedPOI) {
        
        PoiAnnotation *point = [[PoiAnnotation alloc] init];
        CLLocationCoordinate2D pointCC = [self getCoordianteFromString:[[PoiDic objectForKey:@"Point"] objectForKey:@"coordinates"]];
        point.PoiDic = PoiDic;
        point.coordinate =pointCC;
        point.title = [PoiDic objectForKey:@"name"];
        point.type = PinVefa;
        [_VefaPoiArray addObject:point];

    }
    
    _selectedPin = 0;
    categorisedPOI = [_POIDictionnary objectForKey:[[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyLocation]];
    for (NSDictionary * PoiDic in categorisedPOI) {
        
        PoiAnnotation *point = [[PoiAnnotation alloc] init];
        CLLocationCoordinate2D pointCC = [self getCoordianteFromString:[[PoiDic objectForKey:@"Point"] objectForKey:@"coordinates"]];
        point.PoiDic = PoiDic;
        point.coordinate =pointCC;
        point.title = [PoiDic objectForKey:@"name"];
        point.type = PinLocation;
        [_LocationPoiArray addObject:point];
        
    }
    
    _selectedPin = 0;
    categorisedPOI = [_POIDictionnary objectForKey:[[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyAchieved]];
    for (NSDictionary * PoiDic in categorisedPOI) {
        
        PoiAnnotation *point = [[PoiAnnotation alloc] init];
        CLLocationCoordinate2D pointCC = [self getCoordianteFromString:[[PoiDic objectForKey:@"Point"] objectForKey:@"coordinates"]];
        point.coordinate =pointCC;
        point.PoiDic = PoiDic;
        point.title = [PoiDic objectForKey:@"name"];
        point.type = PinAchieved;
        [_AchievedPoiArray addObject:point];
        
    }
    
    _selectedPin = 0;
    categorisedPOI = [_POIDictionnary objectForKey:[[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyCEM]];
    for (NSDictionary * PoiDic in categorisedPOI) {
        PoiAnnotation *point = [[PoiAnnotation alloc] init];
        CLLocationCoordinate2D pointCC = [self getCoordianteFromString:[[PoiDic objectForKey:@"Point"] objectForKey:@"coordinates"]];
        point.coordinate =pointCC;
        point.PoiDic = PoiDic;
        point.title = [PoiDic objectForKey:@"name"];
        point.type = PinCEM;
        [_CEMPoiArray addObject:point];

    }
    
    
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    
    NSString *reuseId = @"annov";
    //MKPinAnnotationView *annov = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    MKAnnotationView *annov = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];

    if(!annov)
    {
        annov = [[MKAnnotationView alloc]initWithAnnotation:annotation
                                               reuseIdentifier:reuseId];
    }
    annov.canShowCallout = YES;
    annov.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIImage *im =[UIImage imageNamed:@"LOGO_Map.png"];
    [annov setImage:im];

    //annov.pinTintColor = [UIColor blueColor];
    
    
    
    /*
    if ([(PoiAnnotation*)annotation type] == PinVefa) {
        
        annov.pinTintColor = [UIColor redColor];
    }
    if ([(PoiAnnotation*)annotation type] == PinLocation) {
        annov.pinTintColor = [UIColor orangeColor];
    }
    if ([(PoiAnnotation*)annotation type] == PinAchieved) {
        annov.pinTintColor = [UIColor cyanColor];
    }
    if ([(PoiAnnotation*)annotation type] == PinCEM) {
        annov.pinTintColor = [UIColor purpleColor];
    }
    */
    
    return annov;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //launch a new view upon touching the disclosure indicator
    
    _selectedPoi = [(PoiAnnotation*)[view annotation] PoiDic];
    
    if ([(PoiAnnotation*)[view annotation] type]==PinVefa) {
        _currentCategorie = keyVEFA;
    }
    if ([(PoiAnnotation*)[view annotation] type]==PinCEM) {
        _currentCategorie = keyCEM;
    }
    if ([(PoiAnnotation*)[view annotation] type]==PinAchieved) {
        _currentCategorie = keyAchieved;
    }
    if ([(PoiAnnotation*)[view annotation] type]==PinLocation) {
        _currentCategorie = keyLocation;
    }
    
    _nextTitle = [_selectedPoi  objectForKey:@"name"];
    [self performSegueWithIdentifier:@"showPoiDetails" sender:self];

}

#pragma mark Navgation Management  -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    POIDetailViewController * detailVC;
    detailVC = (POIDetailViewController *)[segue destinationViewController];
    [detailVC setParcCategorie:_currentCategorie];
    [detailVC setTiltleName:_nextTitle];
    detailVC.SelectedPoi = _selectedPoi;
}

@end
