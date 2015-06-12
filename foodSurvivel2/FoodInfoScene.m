//
//  FSTableViewScene.m
//  foodSurvival
//
//  Created by Eduarda Pinheiro on 10/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import "FoodInfoScene.h"
#define NODENAME_BACKBUTTON         @"backButton"

@interface FoodInfoScene ()

@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *title;

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation FoodInfoScene

- (void)didMoveToView:(SKView *)view {
    _title = [[NSMutableArray alloc]initWithObjects:@"Banana", nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width, self.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = NO;
    _tableView.scrollEnabled = YES;
    _tableView.allowsMultipleSelectionDuringEditing = NO;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_title count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellidentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    
    cell.textLabel.text = _title[indexPath.row];
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:NODENAME_BACKBUTTON]) {
        _tableView.hidden = YES;
        [self.scene.view presentScene:[StartScene unarchiveFromFile:@"StartScene"]];
    }
}

@end
