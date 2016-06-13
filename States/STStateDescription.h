//
//  State.h
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

@import Foundation;

/// Represents a State model. Each state has a title and an unique identifier.
@interface STStateDescription : NSObject

@property (readonly, copy) NSString *title;
@property (readonly, copy) NSUUID *UUID;

/// Returns a new state description with the given title and random UUID
- (instancetype)initWithTitle: (NSString *)title;
/// Returns a new state description from the given dictionary.
/// Expected keys: "title" and "UUID".
- (instancetype)initWithDictionary: (NSDictionary <NSString *, id> *)dictionaryRepresentation;

/// Returns a copy of the current state with the same UUID but different title. You're supposed
/// to replace all copies of the old state with the new one.
- (instancetype)stateByAlteringTitle: (NSString *)title;
/// Returns a new state with random UUID and title equal to the current state's title with " Copy" suffix
- (instancetype)duplicate;

/// Returns a dictionary representation of this state model
- (NSDictionary <NSString *, id> *)dictionaryRepresentation;

@end
