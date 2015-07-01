//
//  FSTableViewScene.m
//  foodSurvival
//
//  Created by Eduarda Pinheiro on 10/06/15.
//  Copyright (c) 2015 edu FUCAPI. All rights reserved.
//

#import "FoodInfoScene.h"

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
    
    NSString *cenouras = @"Cenouras contém vitamina A, essa vitamina ajuda melhorar a visão noturna.";
    NSString *doces = @"As vezes doces ou azedas as laranjas contém vitaminas que contribuem para evitar uma série de variedades de câncer e protege contra a gripe.";
    NSString *brocolis = @"Rico em vitamina C, brocólis ajuda na visão de detalhes, tanto a visão de longe como a visão de perto.";
    NSString *sanduiche = @"Sanduíches são deliciosos, mas não coma muito pois contém gorduras ruins que pode causar obesidade, doenças no coração e diabetes.";
    NSString *pirulito = @"Açúcar em excesso é um perigo. Cuidado! pirulitos causam cáries nos dentes.";
    
    _title = [[NSMutableArray alloc] initWithObjects: cenouras, doces, brocolis, sanduiche, pirulito, nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 30, 460, 300)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
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
    
    cell.textLabel.text = _title[indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:@"Playtime With Hot Toddies" size:12];
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UIImage *imageCenoura = [UIImage imageNamed:@"carrot.png"];
    UIImage *imageLaranja = [UIImage imageNamed:@"orange.png"];
    UIImage *imageBrocolis = [UIImage imageNamed:@"brocolis.png"];
    UIImage *imageSanduiche = [UIImage imageNamed:@"sandwich.png"];
    UIImage *imagePirulito = [UIImage imageNamed:@"lolipop"];
    
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = imageCenoura;
            break;
        case 1:
            cell.imageView.image = imageLaranja;
            break;
        case 2:
            cell.imageView.image = imageBrocolis;
            break;
        case 3:
            cell.imageView.image = imageSanduiche;
            break;
        case 4:
            cell.imageView.image = imagePirulito;
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"backButton"]) {
        _tableView.hidden = YES;
        [self.scene.view presentScene:[StartScene unarchiveFromFile:@"StartScene"]];
    }
}

@end
