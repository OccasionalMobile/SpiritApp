//
//  InitDataViewController.m
//  parcspirit
//
//  Created by Max on 20/11/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "InitDataViewController.h"

@interface InitDataViewController ()
@property BOOL result;
@end

@implementation InitDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self getParcData];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self getversion];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getversion
{
    NSDictionary * dic;
    bool shouldDL = [[DataManager currentDataManager] checkifVersionChanged];
    if (shouldDL) {
        [self getParcData];
        if (_result==false) {//pas pu télécharger les donnée
            dic = [[DataManager currentDataManager] loadParcData];// on regarde s'il y en a local
            if (dic && [dic count]>0)//il y en a
            {
                [[DataManager currentDataManager] setTmpParcList:dic];
                [[DataManager currentDataManager] simplifyData];
                [self moveForxard];

                
            }else // il n'y en a pas ni local ni remote
            {
                [self showerrorMesssage];
            }
        }else
        {
            [self moveForxard];
        }
    }else// pas besoin de DL
    {
        dic = [[DataManager currentDataManager] loadParcData];// on regarde s'il y en a local
        if (dic && [dic count]>0)//il y en a
        {
            [[DataManager currentDataManager] setTmpParcList:dic];
            [[DataManager currentDataManager] simplifyData];
            [self moveForxard];

        }else // il n'y en a pas ni local ni remote
        {
            [self showerrorMesssage];
        }
    }

    
}
-(void)getParcData
{
    
    
    [[DataManager currentDataManager] performSelectorOnMainThread:@selector(getRemoteData)
                                                       withObject:nil
                                                    waitUntilDone:YES];
    
    //BOOL result = [[DataManager currentDataManager] getRemoteData];
    _result = [[DataManager currentDataManager] requestResult];
    
    /*
    if (_result == true) {
        [self performSegueWithIdentifier:@"InitSegue" sender:self];
    }
    else
    {
        NSLog(@"no data");
        if ([UIAlertController class])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erreur de téléchargement" message:@"une erreur c'est produite durant le téléchargement des données, merci de rééssayer plus tard" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Erreur de téléchargement" message:@"une erreur c'est produite durant le téléchargement des données, merci de rééssayer plus tard" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
     
    }
     */
}
-(void)moveForxard
{
    [self performSegueWithIdentifier:@"InitSegue" sender:self];
}
-(void)showerrorMesssage
{
    NSLog(@"no data");
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erreur de téléchargement" message:@"une erreur c'est produite durant le téléchargement des données, merci de rééssayer plus tard" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Erreur de téléchargement" message:@"une erreur c'est produite durant le téléchargement des données, merci de rééssayer plus tard" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
