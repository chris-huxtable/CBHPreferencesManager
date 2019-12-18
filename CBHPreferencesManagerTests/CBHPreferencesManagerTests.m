//  CBHPreferencesManagerTests.m
//  CBHPreferencesManagerTests
//
//  Created by Christian Huxtable <chris@huxtable.ca>, December 2019.
//  Copyright (c) 2019 Christian Huxtable. All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

@import XCTest;
@import CBHPreferencesManager;


#define CBHTestUserDefaults [[NSUserDefaults alloc] initWithSuiteName:NSStringFromSelector(_cmd)]

CBHPreferencesKey CBHPreferencesTestURLKey        = @"CBHPreferencesTestURLKey";
CBHPreferencesKey CBHPreferencesTestArrayKey      = @"CBHPreferencesTestArrayKey";
CBHPreferencesKey CBHPreferencesTestDictionaryKey = @"CBHPreferencesTestDictionaryKey";
CBHPreferencesKey CBHPreferencesTestStringKey     = @"CBHPreferencesTestStringKey";
CBHPreferencesKey CBHPreferencesTestDataKey       = @"CBHPreferencesTestDataKey";

CBHPreferencesKey CBHPreferencesTestBooleanKey    = @"CBHPreferencesTestBooleanKey";

CBHPreferencesKey CBHPreferencesTestIntegerKey    = @"CBHPreferencesTestIntegerKey";
CBHPreferencesKey CBHPreferencesTestUnsignedKey   = @"CBHPreferencesTestUnsignedKey";

CBHPreferencesKey CBHPreferencesTestFloatKey      = @"CBHPreferencesTestFloatKey";
CBHPreferencesKey CBHPreferencesTestDoubleKey     = @"CBHPreferencesTestDoubleKey";
CBHPreferencesKey CBHPreferencesTestCGFloatKey    = @"CBHPreferencesTestCGFloatKey";



@interface CBHPreferencesManagerTests : XCTestCase
{
	XCTestExpectation *_expectation;
}
@end


@implementation CBHPreferencesManagerTests

- (void)testFactory
{
	CBHPreferencesManager *manager = [CBHPreferencesManager sharedManager];
	XCTAssertNotNil(manager, @"Manager should not be nil.");
}


#pragma mark - Initialization

- (void)testInitialization_basic
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] init];
	XCTAssertNotNil(manager, @"Manager should not be nil.");
}

- (void)testInitialization_defaults
{
	CBHPreferencesKey testKey = @"CBHPreferencesTestKey";
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithDefaults:@{testKey: @42}];

	XCTAssertNotNil(manager, @"Manager should not be nil.");
	XCTAssertEqual([manager integerForKey:testKey], 42, @"Stored Value should be correct.");
}


#pragma mark - Synchronization

- (void)testSynchronization
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	XCTAssertNotNil(manager, @"Manager should not be nil.");
	[manager synchronize];
}


#pragma mark - Removing

- (void)testProperties_countAndDictionary
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setBool:YES forKey:CBHPreferencesTestBooleanKey];

	[manager setInteger:41 forKey:CBHPreferencesTestIntegerKey];
	[manager setInteger:42 forKey:CBHPreferencesTestIntegerKey];

	[manager setUnsignedInteger:41 forKey:CBHPreferencesTestUnsignedKey];
	[manager setUnsignedInteger:42 forKey:CBHPreferencesTestUnsignedKey];

	[manager setFloat:41.0 forKey:CBHPreferencesTestFloatKey];
	[manager setFloat:42.0 forKey:CBHPreferencesTestFloatKey];

	[manager setDouble:41.0 forKey:CBHPreferencesTestDoubleKey];
	[manager setDouble:42.0 forKey:CBHPreferencesTestDoubleKey];

	[manager setCGFloat:41.0 forKey:CBHPreferencesTestCGFloatKey];
	[manager setCGFloat:42.0 forKey:CBHPreferencesTestCGFloatKey];

	[manager setURL:[NSURL URLWithString:@"https://huxtable.ca"] forKey:CBHPreferencesTestURLKey];
	[manager setObject:@[@"this", @"is", @"an", @"array"] forKey:CBHPreferencesTestArrayKey];
	[manager setObject:@{@"this": @"is", @"a": @"dictionary"} forKey:CBHPreferencesTestDictionaryKey];
	[manager setObject:@"Some String" forKey:CBHPreferencesTestStringKey];
	[manager setObject:[@"Some Data" dataUsingEncoding:NSUTF8StringEncoding] forKey:CBHPreferencesTestDataKey];

	NSDictionary *dictionary = [manager dictionaryRepresentation];
	XCTAssertEqual([dictionary count], [manager count], @"Dictionary count should be correct.");


	/// Boolean
	XCTAssertEqual([manager boolForKey:CBHPreferencesTestBooleanKey], YES, @"Boolean should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestBooleanKey], @YES, @"Boolean should be correct in dictionary.");

	[manager setBool:NO forKey:CBHPreferencesTestBooleanKey];
	XCTAssertEqual([manager boolForKey:CBHPreferencesTestBooleanKey], NO, @"Boolean should be correct in manager.");


	/// Integer
	XCTAssertEqual([manager integerForKey:CBHPreferencesTestIntegerKey], 42, @"Integer should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestIntegerKey], @42, @"Integer should be correct in dictionary.");

	/// Unsigned Integer
	XCTAssertEqual([manager unsignedIntegerForKey:CBHPreferencesTestUnsignedKey], 42, @"Unsigned Integer should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestUnsignedKey], @42, @"Unsigned Integer should be correct in dictionary.");


	/// Float
	XCTAssertEqual([manager floatForKey:CBHPreferencesTestFloatKey], 42.0, @"Float should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestFloatKey], @42.0, @"Float should be correct in dictionary.");

	/// Double
	XCTAssertEqual([manager doubleForKey:CBHPreferencesTestDoubleKey], 42.0, @"Double should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestDoubleKey], @42.0, @"Double should be correct in dictionary.");

	/// CGFloat
	XCTAssertEqual([manager cgFloatForKey:CBHPreferencesTestCGFloatKey], 42.0, @"CGFloat should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestCGFloatKey], @42.0, @"CGFloat should be correct in dictionary.");


	/// URL
	XCTAssertEqualObjects([manager urlForKey:CBHPreferencesTestURLKey], [NSURL URLWithString:@"https://huxtable.ca"], @"URL should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestURLKey], @"https://huxtable.ca", @"URL should be correct in dictionary.");

	/// Array
	XCTAssertEqualObjects([manager arrayForKey:CBHPreferencesTestArrayKey], (@[@"this", @"is", @"an", @"array"]), @"Array should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestArrayKey], (@[@"this", @"is", @"an", @"array"]), @"Array should be correct in dictionary.");
	[manager removeEntryForKey:CBHPreferencesTestArrayKey];
	XCTAssertEqualObjects([manager arrayForKey:CBHPreferencesTestArrayKey], (@[]), @"Array should be correct in manager.");


	/// Dictionary
	XCTAssertEqualObjects([manager dictionaryForKey:CBHPreferencesTestDictionaryKey], (@{@"this": @"is", @"a": @"dictionary"}), @"Dictionary should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestDictionaryKey], (@{@"this": @"is", @"a": @"dictionary"}), @"Dictionary should be correct in dictionary.");
	[manager removeEntryForKey:CBHPreferencesTestDictionaryKey];
	XCTAssertEqualObjects([manager dictionaryForKey:CBHPreferencesTestDictionaryKey], (@{}), @"Array should be correct in manager.");

	/// String
	XCTAssertEqualObjects([manager stringForKey:CBHPreferencesTestStringKey], @"Some String", @"String should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestStringKey], @"Some String", @"String should be correct in dictionary.");
	[manager removeEntryForKey:CBHPreferencesTestStringKey];
	XCTAssertEqualObjects([manager stringForKey:CBHPreferencesTestStringKey], @"", @"Array should be correct in manager.");

	/// Data
	NSData *expectedData = [@"Some Data" dataUsingEncoding:NSUTF8StringEncoding];
	XCTAssertEqualObjects([manager dataForKey:CBHPreferencesTestDataKey], expectedData, @"Data should be correct in manager.");
	XCTAssertEqualObjects([dictionary objectForKey:CBHPreferencesTestDataKey], expectedData, @"Data should be correct in dictionary.");
	[manager removeEntryForKey:CBHPreferencesTestDataKey];
	XCTAssertEqualObjects([manager dataForKey:CBHPreferencesTestDataKey], [NSData data], @"Data should be correct in manager.");
}


#pragma mark - Removing

- (void)testRemove_all
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setBool:YES forKey:CBHPreferencesTestBooleanKey];

	[manager setInteger:-42 forKey:CBHPreferencesTestIntegerKey];
	[manager setUnsignedInteger:42 forKey:CBHPreferencesTestUnsignedKey];

	[manager setFloat:42.0 forKey:CBHPreferencesTestFloatKey];
	[manager setDouble:42.0 forKey:CBHPreferencesTestDoubleKey];
	[manager setCGFloat:42.0 forKey:CBHPreferencesTestCGFloatKey];

	[manager setURL:[NSURL URLWithString:@"https://huxtable.ca"] forKey:CBHPreferencesTestURLKey];
	[manager setObject:@[@"this", @"is", @"an", @"array"] forKey:CBHPreferencesTestArrayKey];
	[manager setObject:@{@"this": @"is", @"a": @"dictionary"} forKey:CBHPreferencesTestDictionaryKey];
	[manager setObject:@"Some String" forKey:CBHPreferencesTestStringKey];
	[manager setObject:[@"Some Data" dataUsingEncoding:NSUTF8StringEncoding] forKey:CBHPreferencesTestDataKey];

	XCTAssertEqual(11, [manager count], @"Dictionary count should be correct.");

	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestBooleanKey], @"Manager should contain boolean entry.");
	XCTAssertTrue([manager boolForKey:CBHPreferencesTestBooleanKey], @"Manager should contain the correct boolean entry.");


	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestIntegerKey], @"Manager should contain integer entry.");
	XCTAssertEqual([manager integerForKey:CBHPreferencesTestIntegerKey], -42, @"Manager should contain the correct integer entry.");

	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestUnsignedKey], @"Manager should contain unsigned integer entry.");
	XCTAssertEqual([manager unsignedIntegerForKey:CBHPreferencesTestUnsignedKey], 42, @"Manager should contain the correct unsigned integer entry.");


	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestFloatKey], @"Manager should contain unsigned float entry.");
	XCTAssertEqual([manager floatForKey:CBHPreferencesTestFloatKey], 42.0, @"Manager should contain the correct float entry.");

	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestDoubleKey], @"Manager should contain unsigned double entry.");
	XCTAssertEqual([manager doubleForKey:CBHPreferencesTestDoubleKey], 42.0, @"Manager should contain the correct double entry.");

	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestCGFloatKey], @"Manager should contain unsigned CGFloat entry.");
	XCTAssertEqual([manager cgFloatForKey:CBHPreferencesTestCGFloatKey], 42.0, @"Manager should contain the correct CGFloat entry.");


	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestURLKey], @"Manager should contain URL entry.");
	XCTAssertEqualObjects([manager urlForKey:CBHPreferencesTestURLKey], [NSURL URLWithString:@"https://huxtable.ca"], @"Manager should contain the correct URL entry.");

	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestArrayKey], @"Manager should contain Array entry.");
	XCTAssertEqualObjects([manager objectForKey:CBHPreferencesTestArrayKey], (@[@"this", @"is", @"an", @"array"]), @"Manager should contain the correct Array entry.");

	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestDictionaryKey], @"Manager should contain Dictionary entry.");
	XCTAssertEqualObjects([manager objectForKey:CBHPreferencesTestDictionaryKey], (@{@"this": @"is", @"a": @"dictionary"}), @"Manager should contain the correct Dictionary entry.");

	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestStringKey], @"Manager should contain String entry.");
	XCTAssertEqualObjects([manager objectForKey:CBHPreferencesTestStringKey], @"Some String", @"Manager should contain the correct String entry.");

	XCTAssertTrue([manager hasEntryForKey:CBHPreferencesTestDataKey], @"Manager should contain Data entry.");
	XCTAssertEqualObjects([manager objectForKey:CBHPreferencesTestDataKey], [@"Some Data" dataUsingEncoding:NSUTF8StringEncoding], @"Manager should contain the correct Data entry.");


	[manager removeAllEntries];

	XCTAssertEqual(0, [manager count], @"Dictionary should be empty.");
}


#pragma mark - Getting and Setting

- (void)testGetSetRemove_object
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setObject:@"Skookum" forKey:CBHPreferencesTestStringKey];
	XCTAssertEqualObjects(@"Skookum", [manager objectForKey:CBHPreferencesTestStringKey], @"Value should be @\"Skookum\".");

	[manager removeEntryForKey:CBHPreferencesTestStringKey];
	XCTAssertNil([manager objectForKey:CBHPreferencesTestStringKey], @"Value should be nil.");
}

- (void)testGetSetRemove_url
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];

	NSURL *url = [NSURL URLWithString:@"https://skookum.as.frig"];

	[manager setURL:url forKey:CBHPreferencesTestURLKey];
	XCTAssertEqualObjects(url, [manager urlForKey:CBHPreferencesTestURLKey], @"Value should be %@.", [url relativeString]);

	[manager removeEntryForKey:CBHPreferencesTestURLKey];
	XCTAssertNil([manager urlForKey:CBHPreferencesTestURLKey], @"Value should be nil.");
}


- (void)testGetSetRemove_boolean
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setBool:YES forKey:CBHPreferencesTestBooleanKey];
	XCTAssertTrue([manager boolForKey:CBHPreferencesTestBooleanKey], @"Value should be correct.");

	[manager removeEntryForKey:CBHPreferencesTestBooleanKey];
	XCTAssertFalse([manager boolForKey:CBHPreferencesTestBooleanKey], @"Value should be false.");
}

- (void)testGetSetRemove_integer
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setInteger:-42 forKey:CBHPreferencesTestIntegerKey];
	XCTAssertEqual(-42, [manager integerForKey:CBHPreferencesTestIntegerKey], @"Value should be -42.");

	[manager removeEntryForKey:CBHPreferencesTestIntegerKey];
	XCTAssertEqual(0, [manager integerForKey:CBHPreferencesTestIntegerKey], @"Value should be 0.");
}

- (void)testGetSetRemove_unsigned
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setUnsignedInteger:42 forKey:CBHPreferencesTestUnsignedKey];
	XCTAssertEqual(42, [manager unsignedIntegerForKey:CBHPreferencesTestUnsignedKey], @"Value should be 42.");

	[manager removeEntryForKey:CBHPreferencesTestUnsignedKey];
	XCTAssertEqual(0, [manager unsignedIntegerForKey:CBHPreferencesTestUnsignedKey], @"Value should be 0.");
}


- (void)testGetSetRemove_float
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setFloat:-42.0 forKey:CBHPreferencesTestFloatKey];
	XCTAssertEqual(-42.0, [manager floatForKey:CBHPreferencesTestFloatKey], @"Value should be -42.");

	[manager removeEntryForKey:CBHPreferencesTestFloatKey];
	XCTAssertEqual(0.0, [manager floatForKey:CBHPreferencesTestFloatKey], @"Value should be 0.");
}

- (void)testGetSetRemove_double
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setDouble:-42.0 forKey:CBHPreferencesTestDoubleKey];
	XCTAssertEqual(-42.0, [manager doubleForKey:CBHPreferencesTestDoubleKey], @"Value should be -42.");

	[manager removeEntryForKey:CBHPreferencesTestDoubleKey];
	XCTAssertEqual(0.0, [manager doubleForKey:CBHPreferencesTestDoubleKey], @"Value should be 0.");
}

- (void)testGetSetRemove_CGFloat
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setCGFloat:-42.0 forKey:CBHPreferencesTestCGFloatKey];
	XCTAssertEqual(-42.0, [manager cgFloatForKey:CBHPreferencesTestCGFloatKey], @"Value should be -42.");

	[manager removeEntryForKey:CBHPreferencesTestCGFloatKey];
	XCTAssertEqual(0.0, [manager cgFloatForKey:CBHPreferencesTestCGFloatKey], @"Value should be 0.");
}


#pragma mark - Resetting

- (void)testReset_sharedDefaults
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setBool:YES forKey:CBHPreferencesTestBooleanKey];
	[manager setInteger:42 forKey:CBHPreferencesTestIntegerKey];
	[manager setUnsignedInteger:42 forKey:CBHPreferencesTestUnsignedKey];

	[manager resetWithSharedDefaults];

	XCTAssertEqual(0, [manager count], @"Manager should be empty.");
}

- (void)testReset_sharedDefaultsForKey
{
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeAllEntries];

	[manager setBool:YES forKey:CBHPreferencesTestBooleanKey];
	[manager setInteger:42 forKey:CBHPreferencesTestIntegerKey];
	[manager setUnsignedInteger:42 forKey:CBHPreferencesTestUnsignedKey];

	[manager resetWithSharedDefaultForKey:CBHPreferencesTestIntegerKey];

	XCTAssertEqual(0, [manager integerForKey:CBHPreferencesTestIntegerKey], @"Manager should not manage this key.");

}


- (void)testReset_dictionaryDefaults
{
	NSDictionary *defaults = @{ CBHPreferencesTestCGFloatKey: @42.0 };
	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:defaults];
	[manager removeAllEntries];

	[manager setBool:YES forKey:CBHPreferencesTestBooleanKey];
	[manager setInteger:42 forKey:CBHPreferencesTestIntegerKey];
	[manager setUnsignedInteger:42 forKey:CBHPreferencesTestUnsignedKey];

	[manager resetWithDefaults:defaults];

	XCTAssertEqual(1, [manager count], @"Manager only contain single value.");
	XCTAssertEqual(42.0, [manager integerForKey:CBHPreferencesTestCGFloatKey], @"Manager should manage this key.");
}


#pragma mark - Notifications

- (void)testNotification
{
	CBHPreferencesKey CBHPreferencesTestNotificationKey = @"CBHPreferencesTestNotificationKey";

	CBHPreferencesManager *manager = [[CBHPreferencesManager alloc] initWithUserDefaults:CBHTestUserDefaults andDefaults:@{}];
	[manager removeEntryForKey:CBHPreferencesTestNotificationKey shouldNotify:NO];
	[manager registerObject:self withSelector:@selector(fulfillCallback:) forChangeOfKey:CBHPreferencesTestNotificationKey];

	_expectation = [self expectationWithDescription:@"Watching for set of preference."];
	[manager setObject:@"TEST" forKey:CBHPreferencesTestNotificationKey];
	[self waitForExpectations:@[_expectation] timeout:3.0];

	_expectation = [self expectationWithDescription:@"Watching for change of preference."];
	[manager setObject:@"CHANGE" forKey:CBHPreferencesTestNotificationKey];
	[self waitForExpectations:@[_expectation] timeout:3.0];

	_expectation = [self expectationWithDescription:@"Watching for removal of preference."];
	[manager removeEntryForKey:CBHPreferencesTestNotificationKey];
	[self waitForExpectations:@[_expectation] timeout:3.0];

	[manager unregisterObject:self forChangeOfKey:CBHPreferencesTestNotificationKey];
	[manager unregisterObject:self];

	_expectation = nil;
}


#pragma mark - Callbacks

- (void)fulfillCallback:(NSNotification *)notification
{
	XCTAssertNotNil(_expectation, @"The expectation should not be nil...");
	[_expectation fulfill];
}

@end
