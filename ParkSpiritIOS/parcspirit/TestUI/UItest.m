//
//  UItest.m
//  parcspirit
//
//  Created by Max on 26/01/2017.
//  Copyright © 2017 Max. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UItest : XCTestCase

@end

@implementation UItest

- (void)setUp {
    
    XCUIApplication *app = app2;
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"77 - Bailly-Romainvilliers - Parc Spirit Val d'Europe"] tap];
    
    XCUIElement *baillyScrollView = [app.scrollViews containingType:XCUIElementTypeImage identifier:@"BAILLY"].element;
    [baillyScrollView swipeUp];
    [baillyScrollView swipeDown];
    [baillyScrollView swipeDown];
    [[[app.navigationBars[@"77 - Bailly-Romainvilliers - Parc Spirit Val d'Europe"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    
    XCUIApplication *app2 = app;
    [app2.buttons[@"Location"] tap];
    [tablesQuery.staticTexts[@"77 - Bussy-Saint-Georges - Parc Spirit Graham Bell"] tap];
    [app.navigationBars[@"77 - Bussy-Saint-Georges - Parc Spirit Graham Bell"].buttons[@"Back"] tap];
    [app2.buttons[@"Achev\U00e9"] tap];
    [tablesQuery.staticTexts[@"77 - Chessy- Parc Spirit du Circulaire"] tap];
    [app.navigationBars[@"77 - Chessy- Parc Spirit du Circulaire"].buttons[@"Back"] tap];
    [app2.buttons[@"V.E.F.A."] tap];
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
