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
    _title = [[NSMutableArray alloc]initWithObjects:@"Cenoura",@"Laranja",@"Maça", nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(50, 10, self.frame.size.width, self.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = NO;
    _tableView.scrollEnabled = YES;
    _tableView.allowsMultipleSelectionDuringEditing = NO;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    //adicionado imagem na tableview
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background1.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    cell.textLabel.text = _title[indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:@"Courier" size:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    
    UIImage *imageCenoura=[UIImage imageNamed:@"cenoura.png"];
    UIImage *imageMaca=[UIImage imageNamed:@"maca.png"];
    UIImage *imageLaranja=[UIImage imageNamed:@"laranja.png"];
    
    
    switch (indexPath.row) {
            
        case 0:
            cell.imageView.image=imageCenoura;
            break;
        case 1:
            cell.imageView.image=imageLaranja;
            
            break;
        case 2:
            cell.imageView.image=imageMaca;
            
            break;
            
        default:
            break;
    }
    return cell;
}

//Mudar o tamanho das células
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retVal =0.0f;
    
    if(indexPath.section==0 || indexPath.section==1 )
    {
        if(indexPath.row==0 || indexPath.row==1)
        {
            retVal=50.0f;//the height you want.
        }
        else
            retVal=50.0f;
    }
    else
        retVal=50.0f;
    
    return retVal;
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
