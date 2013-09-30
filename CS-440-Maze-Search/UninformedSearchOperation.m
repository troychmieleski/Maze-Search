//
//  UninformedSearchOperation.m
//  CS-440-Maze-Search
//
//  Created by Troy Chmieleski on 9/29/13.
//  Copyright (c) 2013 Troy Chmieleski. All rights reserved.
//

#import "UninformedSearchOperation.h"
#import "Frontier.h"

@implementation UninformedSearchOperation {
	BOOL _isQueue;
}

- (id)initWithFrontierTypeIsQueue:(BOOL)isQueue {
	self = [super init];
	
	if (self) {
		_isQueue = isQueue;
	}
	
	return self;
}

- (void)main {
	[self depthFirstSearch];
	
	[self didFinish];
}

- (void)depthFirstSearch {
	Cell *startingCell = self.maze.startingCell;
	Cell *goalCell = self.maze.goalCell;
	
	if ([startingCell isEqual:goalCell]) {
		// goal reached
		[startingCell setVisited:YES];
		[self.delegate tookStep];
		
		return;
	}
	
	Frontier *frontier = [[Frontier alloc] init];
	NSMutableSet *explored = [NSMutableSet set];
	
	// add the starting cell to the frontier
	[frontier enqueueObject:startingCell];
	
	self.maximumFrontierSize = frontier.count;
	
	while (frontier.count) {
		Cell *cell;
		
		if (_isQueue) {
			// bfs uses a queue
			// dequeue shallowest unexpanded node
			cell = [frontier dequeueFirstObject];
		}
		
		else {
			// dfs uses a stack
			// dequeue the deepest unexpanded noded
			cell = [frontier dequeueLastObject];
		}
		
		[explored addObject:cell];
		[cell setVisited:YES];
		
		BOOL goalReached = [cell isEqual:goalCell];
		
		if (goalReached) {
			self.pathCost = cell.costIncurred;
			
			// show the path solution by following the cell's parent chain back to the root
			[self pathSolutionUsingGoalCell:goalCell];
			[self.delegate tookStep];
			
			return;
		}
		
		[self.delegate tookStep];
		// add cell to explored
		
		// update the number of nodes expandned
		self.numberOfNodesExpanded++;
		
		// look at the child cells
		NSArray *children = [self.maze childrenForParent:cell];
		
		for (Cell *child in children) {
			// if not in explored or frontier
			if (![explored containsObject:child] && ![frontier containsObject:child]) {
				[frontier enqueueObject:child];
				
				// update the maximum frontier size
				if (frontier.count > self.maximumFrontierSize) {
					self.maximumFrontierSize = frontier.count;
				}
				
				// set the child's parent
				[child setParent:cell];
				
				// set the cost incurred
				[child setCostIncurred:cell.costIncurred + 1];
			}
			
			// update the depth
			[child setDepth:cell.depth + 1];
			
			if (child.depth > self.maximumTreeDepthSearched) {
				self.maximumTreeDepthSearched = child.depth;
			}
		}
	
	}
	
	// frontier is empty, no goal found, return failure
	return;
}

@end
