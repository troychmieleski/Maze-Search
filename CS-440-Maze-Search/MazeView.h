//
//  MazeView.h
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/24/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MazeViewDataSource.h"

@interface MazeView : UIView

@property (nonatomic, weak) id <MazeViewDataSource> dataSource;

- (void)reloadData;

@end
