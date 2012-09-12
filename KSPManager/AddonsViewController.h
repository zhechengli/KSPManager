//
//  AddonsViewController.h
//  KSPManager
//
//  Created by Erik O'Shaughnessy on 9/11/12.
//  Copyright (c) 2012 Symbolic Armageddon. All rights reserved.
//

#import "KSPViewController.h"

#import "DropView.h"

@interface AddonsViewController : KSPViewController <DropViewDelegate>

@property (strong) IBOutlet NSArrayController *installedArrayController;
@property (strong) IBOutlet NSArrayController *availableArrayController;
@property (strong) IBOutlet DropView *installedDropView;
@property (strong) IBOutlet DropView *availableDropView;
@property (strong) IBOutlet NSTableView *installedTableView;
@property (strong) IBOutlet NSTableView *availableTableView;
@property (strong) IBOutlet NSButton *addButton;
@property (strong) IBOutlet NSButton *removeButton;
@property (strong) IBOutlet NSButton *actionButton;
@property (strong) IBOutlet NSSegmentedControl *categoryControl;

- (IBAction)didPushAddButton:(NSButton *)sender;
- (IBAction)didPushRemoveButton:(NSButton *)sender;
- (IBAction)didPushActionButton:(NSButton *)sender;
- (IBAction)controlDidChange:(NSSegmentedControl *)sender;

@end