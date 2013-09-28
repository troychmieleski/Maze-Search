//
//  DepthFirstSearchOperation.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/25/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "DepthFirstSearchOperation.h"
#import "Frontier.h"
#import "CellState.h"

@implementation DepthFirstSearchOperation

- (void)main {
	NSLog(@"perform depth first search here");
	
	[self depthFirstSearch];
	
	[self didFinish];
}

- (void)depthFirstSearch {
	Cell *startingCell = self.maze.startingCell;
	Cell *goalCell = self.maze.goalCell;
	
	if (startingCell == goalCell) {
		// goal reached
		return;
	}
	
	Frontier *frontier = [[Frontier alloc] init];
	NSMutableSet *explored = [NSMutableSet set];
	
	// add the starting cell to the frontier
	[frontier enqueue:startingCell];
	
	while (frontier.count) {
		// dfs uses a stack
		// choose the shallowest cell in the frontier
		Cell *cell = [frontier dequeueLastObject];
		
		// add cell to explored
		[explored addObject:cell];
		[cell setVisited:YES];
		
		BOOL goalReached = [cell isEqual:goalCell];
		
		[self.delegate tookStep];
		
		if (goalReached) {
			return;
		}
		
		// look at the child cells
		NSArray *children = [self.maze childrenForParent:cell];
		
		for (Cell *child in children) {
			// if not in explored or frontier
			if (![explored containsObject:child] && ![frontier containsObject:child]) {
				[frontier enqueue:child];
			}
		}
	}
	
	// frontier is empty, no goal found, return failure
	return;
}

@end
