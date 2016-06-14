// STStateDescription.h
// Copyright (c) 2016 Eden Vidal
//
// This software may be modified and distributed under the terms
// of the MIT license.  See the LICENSE file for details.

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
