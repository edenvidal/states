//
//  State.m
//  States
//
//  Created by Dmitry Rodionov on 01/06/16.
//  Copyright © 2016 Internals Exposed. All rights reserved.
//

#import "STStateDescription.h"

@interface STStateDescription()
@property (readwrite, copy) NSString *title;
@property (readwrite, copy) NSUUID *UUID;
@end

@implementation STStateDescription

- (instancetype)initWithTitle: (NSString *)title
{
	if ((self = [super init])) {
		self.UUID = [NSUUID UUID];
		self.title = title;
	}
	return self;
}

- (instancetype)initWithTitle: (NSString *)title UUID: (NSUUID *)UUID
{
	if ((self = [self initWithTitle: title])) {
		self.UUID = UUID;
	}
	return self;
}

- (instancetype)initWithDictionary: (NSDictionary <NSString *, id> *)dictionaryRepresentation
{
	NSParameterAssert(dictionaryRepresentation[@"title"] != nil);
	NSParameterAssert(dictionaryRepresentation[@"UUID"] != nil);

	NSString *title = dictionaryRepresentation[@"title"];
	NSUUID *UUID = [[NSUUID alloc] initWithUUIDString: dictionaryRepresentation[@"UUID"]];

	return [self initWithTitle: title UUID: UUID];
}

- (NSDictionary <NSString *, id> *)dictionaryRepresentation
{
	return @{
		@"title": self.title,
		@"UUID" : self.UUID.UUIDString
	};
}

- (instancetype)stateByAlteringTitle: (NSString *)title
{
	STStateDescription *newState = [[STStateDescription alloc] initWithTitle: title];
	newState.UUID = self.UUID;
	return newState;
}

- (instancetype)duplicate
{
	return [[STStateDescription alloc] initWithTitle: self.title];
}

- (BOOL)isEqual: (id)object
{
	typeof(self) another = object;

	if (![another isKindOfClass: [self class]]) {
		return NO;
	}

	if (![another.UUID isEqual: self.UUID]) {
		return NO;
	}

	if (![another.title isEqualToString: self.title]) {
		return NO;
	}
	return YES;
}

- (NSUInteger)hash
{
	return self.UUID.hash + self.title.hash;
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"<%@: %p> (UUID = %@, title = \"%@\" @ %p)",
			NSStringFromClass([self class]), (void *)self, self.UUID.UUIDString, self.title, (void *)self.title];
}

@end
