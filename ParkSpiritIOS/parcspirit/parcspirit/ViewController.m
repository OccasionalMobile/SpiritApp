//
//  ViewController.m
//  parcspirit
//
//  Created by Max on 14/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "ViewController.h"

#define SegmentVefa 0
#define SegmentLocation 1
#define SegmentAchieved 2
#define SegmentCEM 3
#define SegmentAll 4

#define PinVefa 1
#define PinLocation 2
#define PinAchieved 3
#define PinCEM 4

@interface ViewController ()
@property int selectedPin;
@property (strong,nonatomic) NSDictionary * selectedPoi;
@property (strong,nonatomic) NSString * nextTitle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_VefaView setHidden:false]; // a l'arrivé on affiche que la premiere vue
    [_AllView setHidden:true];
    _POIDictionnary = [[NSDictionary alloc] init];
    [_MapView setDelegate:self];
    _selectedPin = 0;
    [self prepareTheMap ];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [[DataManager currentDataManager] getLocalData];
    _POIDictionnary = [NSDictionary dictionaryWithDictionary:[[DataManager currentDataManager] parcList]];
    
    NSString * catKey;
    catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyVEFA];
    _localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
    [_CategoryLabel setText:catKey];

    
    [_POITableView reloadData];
    
    [self addPOIToTheMap ];
}

- (IBAction)selectorValueChanged:(UISegmentedControl *)sender {
    
    NSString * catKey;
    
    if (sender.selectedSegmentIndex == SegmentVefa) {
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyVEFA];
        _localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
        
        [_VefaView setHidden:false];
        [_AllView setHidden:true];
    }else if (sender.selectedSegmentIndex == SegmentLocation)
    {
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyLocation];
        _localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
        [_VefaView setHidden:false];
        [_AllView setHidden:true];
    }else if (sender.selectedSegmentIndex == SegmentAchieved) {
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyAchieved];
        _localPOIArray = [[NSArray alloc] initWithArray:[_POIDictionnary objectForKey:catKey]];
        [_VefaView setHidden:false];
        [_AllView setHidden:true];
    }else if (sender.selectedSegmentIndex == SegmentCEM) {
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
    
    [_CategoryLabel setText:catKey];
    [_POITableView reloadData];
    
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
    
    if (_ViewSelector.selectedSegmentIndex == SegmentVefa) {
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyVEFA];
        nbRow = [[_POIDictionnary objectForKey:catKey] count];
    }else if (_ViewSelector.selectedSegmentIndex == SegmentLocation) {
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyLocation];
        nbRow = [[_POIDictionnary objectForKey:catKey] count];
    }else if (_ViewSelector.selectedSegmentIndex == SegmentAchieved) {
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyAchieved];
        nbRow = [[_POIDictionnary objectForKey:catKey] count];
    }else if (_ViewSelector.selectedSegmentIndex == SegmentCEM) {
        catKey = [[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyCEM];
        nbRow = [[_POIDictionnary objectForKey:catKey] count];
    }else
    return 0;

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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(parisCoordinate.coordinate, 10000, 10000);
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
        point.coordinate =pointCC;
        point.title = [PoiDic objectForKey:@"name"];
        point.type = PinVefa;
        [_MapView addAnnotation:point];

    }
    
    _selectedPin = 0;
    categorisedPOI = [_POIDictionnary objectForKey:[[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyLocation]];
    for (NSDictionary * PoiDic in categorisedPOI) {
        
        PoiAnnotation *point = [[PoiAnnotation alloc] init];
        CLLocationCoordinate2D pointCC = [self getCoordianteFromString:[[PoiDic objectForKey:@"Point"] objectForKey:@"coordinates"]];
        point.coordinate =pointCC;
        point.title = [PoiDic objectForKey:@"name"];
        point.type = PinLocation;
        [_MapView addAnnotation:point];
        
    }
    
    _selectedPin = 0;
    categorisedPOI = [_POIDictionnary objectForKey:[[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyAchieved]];
    for (NSDictionary * PoiDic in categorisedPOI) {
        
        PoiAnnotation *point = [[PoiAnnotation alloc] init];
        CLLocationCoordinate2D pointCC = [self getCoordianteFromString:[[PoiDic objectForKey:@"Point"] objectForKey:@"coordinates"]];
        point.coordinate =pointCC;
        point.title = [PoiDic objectForKey:@"name"];
        point.type = PinAchieved;
        [_MapView addAnnotation:point];
        
    }
    
    _selectedPin = 0;
    categorisedPOI = [_POIDictionnary objectForKey:[[[DataManager currentDataManager] categoryKeyDic] objectForKey:keyCEM]];
    for (NSDictionary * PoiDic in categorisedPOI) {
        PoiAnnotation *point = [[PoiAnnotation alloc] init];
        CLLocationCoordinate2D pointCC = [self getCoordianteFromString:[[PoiDic objectForKey:@"Point"] objectForKey:@"coordinates"]];
        point.coordinate =pointCC;
        point.title = [PoiDic objectForKey:@"name"];
        point.type = PinCEM;
        [_MapView addAnnotation:point];
        
    }
    
    
    
    
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [mapView addAnnotation:point];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    
    NSString *reuseId = @"annov";
    MKPinAnnotationView *annov = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if(!annov)
    {
        annov = [[MKPinAnnotationView alloc]initWithAnnotation:annotation
                                               reuseIdentifier:reuseId];
    }
    annov.canShowCallout = YES;
    
    annov.pinTintColor = [UIColor blueColor];
    
    
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
    
    
    return annov;
}

#pragma mark Navgation Management  -
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    POIDetailViewController * detailVC;
    [detailVC setTiltleName:_nextTitle];
    detailVC = (POIDetailViewController *)[segue destinationViewController];
    detailVC.SelectedPoi = _selectedPoi;
}

@end
