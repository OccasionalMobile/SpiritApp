//
//  POIDetailViewController.h
//  parcspirit
//
//  Created by Max on 16/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POIDetailViewController : UIViewController
@property (nonatomic, strong) NSDictionary * SelectedPoi;

@property (nonatomic, strong) NSString * TiltleName;


@property (weak, nonatomic) IBOutlet UILabel *ParcLabel;
@property (weak, nonatomic) IBOutlet UILabel *CommuneLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *InterlocuteurLabel;
@property (weak, nonatomic) IBOutlet UIButton *LienCommercialButton;

- (IBAction)ClickOnCommercialLink:(id)sender;

@end
