//
//  POIDetailViewController.m
//  parcspirit
//
//  Created by Max on 16/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "POIDetailViewController.h"

@interface POIDetailViewController ()
@property (nonatomic, strong) NSString * ParcName;
@property (nonatomic, strong) NSString * ParcDescription;
@property (nonatomic, strong) NSString * ParcCommune;
@property (nonatomic, strong) NSString * ParcInterlocuteur;
@property (nonatomic, strong) NSString * ParcLink;

@end

@implementation POIDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:_TiltleName];
    // Do any additional setup after loading the view.
    [[[self navigationController] navigationBar] setBackgroundColor:[UIColor redColor]];
    [[self parcScrollView] setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+_LienCommercialButton.frame.origin.y+_LienCommercialButton.frame.size.height)];
    [self prepareParcInfo];
    [self refreshDisplay];
}
-(void)viewDidAppear:(BOOL)animated
{

}
-(void)prepareParcInfo
{
    if ([_SelectedPoi objectForKey:@"name"])
    _ParcName = [_SelectedPoi objectForKey:@"name"];
    NSArray * parcDetailArray = [[_SelectedPoi objectForKey:@"ExtendedData"] objectForKey:@"Data"];
    for (NSDictionary * aParcDic in parcDetailArray) {
        NSString * dicKey;
        if ([aParcDic objectForKey:@"_name"])
            dicKey = [aParcDic objectForKey:@"_name"];
        else
            break;
        
        //NSDictionary * extendData = []
        
        if ([dicKey isEqualToString:@"Commune"])
            _ParcCommune = [aParcDic objectForKey:@"value"];
        
        if ([dicKey isEqualToString:@"Description"])
            _ParcDescription = [aParcDic objectForKey:@"value"];
        
        if ([dicKey isEqualToString:@"Interlocuteur"])
            _ParcInterlocuteur = [aParcDic objectForKey:@"value"];
        
        if ([dicKey isEqualToString:@"Lien vers le dossier commercial"])
            _ParcLink = [aParcDic objectForKey:@"value"];

    }
}
-(void)refreshDisplay
{
    [_ParcLabel setText:_ParcName];
    [_InterlocuteurLabel setText:_ParcInterlocuteur];
    [_CommuneLabel setText:_ParcCommune];
    [_DescriptionLabel setText:_ParcDescription];
    [_LienCommercialButton setTitle:_ParcLink forState:UIControlStateNormal];
    [_parcImageView setImage:[[DataManager currentDataManager] getParcImageFromName:_ParcName andCategorie:_ParcCategorie]];
    if (!_parcImageView.image) {
        [_parcImageView setImage:[UIImage imageNamed:@"Spirit_375_200.jpg"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ClickOnCommercialLink:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:_ParcLink];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",_ParcLink,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",_ParcLink,success);
    }
    
}
@end
