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
    _title = [[NSMutableArray alloc]initWithObjects:@"Cenouras contém vitamina A, essa vitamina ajuda melhorar a visão noturna.",@"As vezes doces ou azedas as laranjas contém vitaminas que contribuem para evitar uma série de variedades de câncer e protege contra a gripe.",@"Rico em vitamina C, brocólis ajuda na visão de detalhes, tanto a visão de longe como a visão de perto.", @"Sanduíches são deliciosos, mas não coma muito pois contém gorduras ruins que pode causar obesidade, doenças no coração e diabetes.",@"Chocolates são deliciosos mas comer muito pode provocar diabetes que é o aumento de açúcar no sangue.",@"Açúcar em excesso é um perigo. Cuidado! pirulitos causam cáries nos dentes.",nil];
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
    cell.textLabel.numberOfLines=5;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    

    
    UIImage *imageCenoura=  [UIImage imageNamed:@"carrot.png"];
    UIImage *imageLaranja=  [UIImage imageNamed:@"orange.png"];
    UIImage *imageBrocolis= [UIImage imageNamed:@"brocolis.png"];
    UIImage *imageSanduiche=[UIImage imageNamed:@"sandwich.png"];
    UIImage *imageChocolate=[UIImage imageNamed:@"chocolate"];
    UIImage *imagePirulito= [UIImage imageNamed:@"lolipop"];
    
    

    

    
    switch (indexPath.row) {
            
        case 0:
            cell.imageView.image=imageCenoura;
            break;
        case 1:
            cell.imageView.image=imageLaranja;
            
            break;
        case 2:
            cell.imageView.image=imageBrocolis;
            
            break;
        case 3:
            cell.imageView.image=imageSanduiche;
            break;
            
        case 4:
            cell.imageView.image=imageChocolate;
            break;
        case 5:
            cell.imageView.image=imagePirulito;
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
