//
//  GTCacheUnit.m
//  GTravel
//
//  Created by Raynay Yue on 5/22/15.
//  Copyright (c) 2015 Xi'an Tripshow Information Technology Co., Ltd. All rights reserved.
//

#import "GTCacheUnit.h"
#import "DTKeychain.h"
#import "RYCommon.h"
#import "GTravelUserItem.h"
#import "GTravelImageItem.h"
#import "GTravelToolItem.h"
#import "GTravelCityItem.h"
#import "GTravelTownItem.h"
#import "GTravelRouteItem.h"
#import "GTCacheUnit.h"

#define kGTLaunchImageVersion @"kGTLaunchImageVersion"
#define kGTBannerImageVersion @"kGTBannerImageVersion"
#define kGTTipImageVersion @"kGTTipImageVersion"
#define kGTTitleOfCities @"kGTTitleOfCities"
#define kGTTitleOfTowns @"KGTTitleOfTowns"
#define kGTTitleOfRoutes @"kGTTitleOfRoutes"
#define kGTLineID @"kGTLineID"

#define kGTravelUserID @"kGTravelUserID"
#define kGTravelPassWord @"kGTravelPassWord"
#define kGTravelUserNickName @"kGTravelUserNickName"
#define kGTDeviceToken @"kGTDeviceToken"

#define kFolderCacheRoot @"Cache"
#define kFolderLaunchImages @"LaunchImages"
#define kFileLaunchImages @"LaunchImages.plist"
#define kFolderBanners @"Banners"
#define kFileBanners @"Banners.plist"
#define kFolderTips @"Tips"
#define kFileTips @"Tips.plist"
#define kFolderCities @"Cities"
#define kFileCities @"Cities.plist"
#define kFileCityIDs @"cityids.plist"
#define kFolderRoutes @"Routes"
#define kFileRoutes @"Routes.plist"
#define kFolderRecentUsers @"RecentUsers"
#define kFileRecentUsers @"users.plist"

@interface GTCacheUnit ()
@property (nonatomic, readonly) NSUserDefaults *userDefaults;

@property (nonatomic, copy) NSString *cacheFolderRoot;
@property (nonatomic, copy) NSString *cacheFolderLaunchImages;
@property (nonatomic, copy) NSString *cacheFileLaunchImages;
@property (nonatomic, copy) NSString *cacheFolderBanners;
@property (nonatomic, copy) NSString *cacheFileBanners;
@property (nonatomic, copy) NSString *cacheFolderTips;
@property (nonatomic, copy) NSString *cacheFileTips;
@property (nonatomic, copy) NSString *cacheFolderCities;
@property (nonatomic, copy) NSString *cacheFileCities;
@property (nonatomic, copy) NSString *cacheFileTowns;
@property (nonatomic, copy) NSString *cacheFolderRoutes;
@property (nonatomic, copy) NSString *cacheFileRoutes;
@property (nonatomic, copy) NSString *cacheFolderRecentUsers;
@property (nonatomic, copy) NSString *cacheFileRecentUsers;
@property (nonatomic, copy) NSString *cacheFileCityIDs;

@property (nonatomic, strong) NSMutableArray *cityIDs;

- (void)initializedCache;
- (void)saveLaunchImages;
- (void)removeLaunchImages;

- (void)saveBanners;
- (void)removeBanners;

- (void)saveTipItems;
- (void)removeTipItems;

- (void)saveCityItems;
- (void)removeCityItems;

- (void)saveTownItems;
- (void)removeTownItems;

- (void)saveRouteItems;
- (void)removeRouteItems;

- (void)saveRecentUsers;
- (void)removeRecentUsers;

- (void)saveCityIDs;
- (void)removeCityIDs;
@end

@implementation GTCacheUnit
#pragma mark - Property Methods
- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (NSString *)userID
{
    return [self valueInKeyChainForKey:kGTravelUserID];
}

- (void)setUserID:(NSString *)userID
{
    [self saveValueToKeyChain:userID forKey:kGTravelUserID];
}

- (NSString *)passWord
{
    return [self valueInKeyChainForKey:kGTravelPassWord];
}

- (void)setPassWord:(NSString *)passWord
{
    [self saveValueToKeyChain:passWord forKey:kGTravelPassWord];
}

- (NSString *)userNickName
{
    return [self valueInKeyChainForKey:kGTravelUserNickName];
}

- (void)setUserNickName:(NSString *)userNickName
{
    [self saveValueToKeyChain:userNickName forKey:kGTravelUserNickName];
}

- (NSString *)deviceToken
{
    return [self valueInUserDefaultsForKey:kGTDeviceToken];
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    [self saveValueToUserDefaults:deviceToken forKey:kGTDeviceToken];
}

- (NSString *)launchImageVersion
{
    return [self valueInUserDefaultsForKey:kGTLaunchImageVersion];
}

- (void)setLaunchImageVersion:(NSString *)launchImageVersion
{
    [self saveValueToUserDefaults:launchImageVersion forKey:kGTLaunchImageVersion];
}

- (NSString *)bannerImageVersion
{
    return [self valueInUserDefaultsForKey:kGTBannerImageVersion];
}

- (void)setBannerImageVersion:(NSString *)bannerImageVersion
{
    [self saveValueToUserDefaults:bannerImageVersion forKey:kGTBannerImageVersion];
}

- (NSString *)tipImageVersion
{
    return [self valueInUserDefaultsForKey:kGTTipImageVersion];
}

- (void)setTipImageVersion:(NSString *)tipImageVersion
{
    [self saveValueToUserDefaults:tipImageVersion forKey:kGTTipImageVersion];
}

- (NSString *)titleOfCities
{
    return [self valueInUserDefaultsForKey:kGTTitleOfCities];
}

- (void)setTitleOfCities:(NSString *)titleOfCities
{
    [self saveValueToUserDefaults:titleOfCities forKey:kGTTitleOfCities];
}

- (NSString *)titleOfTowns
{
    return [self valueInUserDefaultsForKey:kGTTitleOfTowns];
}

- (void)setTitleOfTowns:(NSString *)titleOfTowns
{
    [self saveValueToUserDefaults:titleOfTowns forKey:kGTTitleOfTowns];
}

- (NSString *)titleOfRoutes
{
    return [self valueInUserDefaultsForKey:kGTTitleOfRoutes];
}

- (void)setTitleOfRoutes:(NSString *)titleOfRoutes
{
    [self saveValueToUserDefaults:titleOfRoutes forKey:kGTTitleOfRoutes];
}

- (NSString *)lineID
{
    return [self valueInKeyChainForKey:kGTLineID];
}

- (void)setLineID:(NSString *)lineID
{
    [self saveValueToKeyChain:lineID forKey:kGTLineID];
}

#pragma mark - Non-Public Methods
- (void)initializedCache
{
    NSString *cacheFolderRoot = [kFolderCacheRoot absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:cacheFolderRoot isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:cacheFolderRoot withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFolderRoot = cacheFolderRoot;
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else
        self.cacheFolderRoot = cacheFolderRoot;

    NSString *cacheFolderLaunchImage = [cacheFolderRoot stringByAppendingPathComponent:kFolderLaunchImages];
    isDirectory = YES;

    if (![fileManager fileExistsAtPath:cacheFolderLaunchImage isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:cacheFolderLaunchImage withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFolderLaunchImages = cacheFolderLaunchImage;
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else
        self.cacheFolderLaunchImages = cacheFolderLaunchImage;

    NSString *cacheFolderBanners = [cacheFolderRoot stringByAppendingPathComponent:kFolderBanners];
    isDirectory = YES;

    if (![fileManager fileExistsAtPath:cacheFolderBanners isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:cacheFolderBanners withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFolderBanners = cacheFolderBanners;
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else
        self.cacheFolderBanners = cacheFolderBanners;


    NSString *cacheFolderTips = [cacheFolderRoot stringByAppendingPathComponent:kFolderTips];
    isDirectory = YES;

    if (![fileManager fileExistsAtPath:cacheFolderTips isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:cacheFolderTips withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFolderTips = cacheFolderTips;
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else
        self.cacheFolderTips = cacheFolderTips;

    NSString *cacheFolderCities = [cacheFolderRoot stringByAppendingPathComponent:kFolderCities];
    isDirectory = YES;
    if (![fileManager fileExistsAtPath:cacheFolderCities isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:cacheFolderCities withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFolderCities = cacheFolderCities;
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else
        self.cacheFolderCities = cacheFolderCities;

    NSString *cacheFolderRoutes = [cacheFolderRoot stringByAppendingPathComponent:kFolderRoutes];
    isDirectory = YES;
    if (![fileManager fileExistsAtPath:cacheFolderRoutes isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:cacheFolderRoutes withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFolderRoutes = cacheFolderRoutes;
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else
        self.cacheFolderRoutes = cacheFolderRoutes;

    NSString *cacheFolderRecentUsers = [cacheFolderRoot stringByAppendingPathComponent:kFolderRecentUsers];
    if (![fileManager fileExistsAtPath:cacheFolderRecentUsers]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:cacheFolderRecentUsers withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFolderRecentUsers = cacheFolderRecentUsers;
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else
        self.cacheFolderRecentUsers = cacheFolderRecentUsers;

    self.launchImages = [NSMutableArray array];
    NSString *fileLaunchImagesInfo = [self.cacheFolderLaunchImages stringByAppendingPathComponent:kFileLaunchImages];
    isDirectory = NO;
    if (![fileManager fileExistsAtPath:fileLaunchImagesInfo isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:fileLaunchImagesInfo withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFileLaunchImages = fileLaunchImagesInfo;
            [self.launchImages writeToFile:fileLaunchImagesInfo atomically:YES];
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else {
        self.cacheFileLaunchImages = fileLaunchImagesInfo;
        NSArray *images = [NSArray arrayWithContentsOfFile:fileLaunchImagesInfo];
        for (NSDictionary *dict in images) {
            GTLaunchImage *item = [GTLaunchImage launchImageFromDictionary:dict];
            [self.launchImages addObject:item];
        }
    }

    self.banners = [NSMutableArray array];
    NSString *fileBannersInfo = [self.cacheFolderBanners stringByAppendingPathComponent:kFileBanners];
    isDirectory = NO;
    if (![fileManager fileExistsAtPath:fileBannersInfo isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:fileBannersInfo withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFileBanners = fileBannersInfo;
            [self.banners writeToFile:fileBannersInfo atomically:YES];
        }
        else
            RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    else {
        self.cacheFileBanners = fileBannersInfo;
        NSArray *images = [NSArray arrayWithContentsOfFile:fileBannersInfo];
        for (NSDictionary *dict in images) {
            GTBannerImage *item = [GTBannerImage bannerImageFromDictionary:dict];
            [self.banners addObject:item];
        }
    }

    self.tipItems = [NSMutableArray array];
    NSString *fileTipsInfo = [self.cacheFolderTips stringByAppendingPathComponent:kFileTips];
    isDirectory = NO;
    if (![fileManager fileExistsAtPath:fileTipsInfo isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:fileTipsInfo withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFileTips = fileTipsInfo;
            [self.tipItems writeToFile:fileTipsInfo atomically:YES];
        }
    }
    else {
        self.cacheFileTips = fileTipsInfo;
        NSArray *items = [NSArray arrayWithContentsOfFile:fileTipsInfo];
        for (NSArray *ar in items) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSMutableDictionary *dict in ar) {
                GTravelToolItem *item = [GTravelToolItem toolItemFromDictionary:dict];
                [arr addObject:item];
            }
            if (RYIsValidArray(arr)) {
                [self.tipItems addObject:arr];
            }
        }
    }

    self.cities = [NSMutableArray array];
    NSString *fileCitiesInfo = [self.cacheFolderCities stringByAppendingPathComponent:kFileCities];
    isDirectory = NO;
    if (![fileManager fileExistsAtPath:fileCitiesInfo isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:fileCitiesInfo withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFileCities = fileCitiesInfo;
            [self.cities writeToFile:fileCitiesInfo atomically:YES];
        }
    }
    else {
        self.cacheFileCities = fileCitiesInfo;
        NSArray *items = [NSArray arrayWithContentsOfFile:fileCitiesInfo];
        for (NSDictionary *dict in items) {
            GTravelCityItem *item = [GTravelCityItem cityItemFromDictionary:dict];
            [self.cities addObject:item];
        }
    }

    self.routes = [NSMutableArray array];
    NSString *fileRoutesInfo = [self.cacheFolderRoutes stringByAppendingPathComponent:kFileRoutes];
    isDirectory = NO;
    if (![fileManager fileExistsAtPath:fileRoutesInfo isDirectory:&isDirectory]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:fileRoutesInfo withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFileRoutes = fileRoutesInfo;
            [self.routes writeToFile:fileRoutesInfo atomically:YES];
        }
    }
    else {
        self.cacheFileRoutes = fileRoutesInfo;
        NSArray *items = [NSArray arrayWithContentsOfFile:fileRoutesInfo];
        for (NSDictionary *dict in items) {
            GTravelRouteItem *item = [GTravelRouteItem itemFromDictionary:dict];
            [self.routes addObject:item];
        }
    }

    self.recentUsers = [NSMutableArray array];
    NSString *fileRecentUsers = [self.cacheFolderRecentUsers stringByAppendingPathComponent:kFileRecentUsers];
    if (![fileManager fileExistsAtPath:fileRecentUsers]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:fileRecentUsers withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFileRecentUsers = fileRecentUsers;
            [self.recentUsers writeToFile:fileRecentUsers atomically:YES];
        }
    }
    else {
        self.cacheFileRecentUsers = fileRecentUsers;
        NSArray *items = [NSArray arrayWithContentsOfFile:fileRecentUsers];
        for (NSDictionary *dict in items) {
            GTUserBase *userBase = [GTUserBase userFromDictionary:dict];
            [self.recentUsers addObject:userBase];
        }
    }

    self.cityIDs = [NSMutableArray array];
    NSString *fileCityIDs = [self.cacheFolderCities stringByAppendingPathComponent:kFileCityIDs];
    if (![fileManager fileExistsAtPath:fileCityIDs]) {
        NSError *error = NULL;
        if ([fileManager createDirectoryAtPath:fileCityIDs withIntermediateDirectories:YES attributes:nil error:&error]) {
            self.cacheFileCityIDs = fileCityIDs;
            [self.cityIDs writeToFile:fileCityIDs atomically:YES];
        }
    }
    else {
        self.cacheFileCityIDs = fileCityIDs;
        NSArray *items = [NSArray arrayWithContentsOfFile:fileCityIDs];
        for (NSDictionary *dict in items) {
            GTCityBase *city = [GTCityBase cityFromDictionary:dict];
            [self.cityIDs addObject:city];
        }
    }
}

- (void)saveLaunchImages
{
    NSMutableArray *arr = [NSMutableArray array];
    for (GTravelImageItem *item in self.launchImages) {
        [arr addObject:[item dictionaryFormat]];
    }
    [arr writeToFile:self.cacheFileLaunchImages atomically:YES];
}

- (void)removeLaunchImages
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = NULL;
    for (GTravelImageItem *item in self.launchImages) {
        if (RYIsValidString(item.localImagePath)) {
            if ([fileManager fileExistsAtPath:item.localImagePath] && ![fileManager removeItemAtPath:[item.localImagePath absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                RYCONDITIONLOG(DEBUG, @"%@", error);
            }
        }
    }
    if (![fileManager removeItemAtPath:self.cacheFileLaunchImages error:&error]) {
        RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    [self.launchImages removeAllObjects];
}

- (void)saveBanners
{
    NSMutableArray *arr = [NSMutableArray array];
    for (GTravelImageItem *item in self.banners) {
        [arr addObject:[item dictionaryFormat]];
    }
    [arr writeToFile:self.cacheFileBanners atomically:YES];
}

- (void)removeBanners
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = NULL;
    for (GTravelImageItem *item in self.launchImages) {
        if (RYIsValidString(item.localImagePath)) {
            if ([fileManager fileExistsAtPath:item.localImagePath] && ![fileManager removeItemAtPath:[item.localImagePath absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                RYCONDITIONLOG(DEBUG, @"%@", error);
            }
        }
    }
    if (![fileManager removeItemAtPath:self.cacheFileBanners error:&error]) {
        RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    [self.banners removeAllObjects];
}

- (void)saveTipItems
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSArray *ar in self.tipItems) {
        NSMutableArray *arr = [NSMutableArray array];
        for (GTravelToolItem *item in ar) {
            [arr addObject:[item dictionaryFormat]];
        }
        if (RYIsValidArray(arr)) {
            [array addObject:arr];
        }
    }
    [array writeToFile:self.cacheFileTips atomically:YES];
}

- (void)removeTipItems
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = NULL;
    for (NSArray *ar in self.tipItems) {
        for (GTravelToolItem *item in ar) {
            if (RYIsValidString(item.localImage)) {
                if ([fileManager fileExistsAtPath:item.localImage] && ![fileManager removeItemAtPath:[item.localImage absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                    RYCONDITIONLOG(DEBUG, @"%@", error);
                }
            }

            if (RYIsValidString(item.localThumbnail)) {
                if ([fileManager fileExistsAtPath:item.localThumbnail] && ![fileManager removeItemAtPath:[item.localThumbnail absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                    RYCONDITIONLOG(DEBUG, @"%@", error);
                }
            }
        }
    }

    if (![fileManager removeItemAtPath:self.cacheFileTips error:&error]) {
        RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    [self.tipItems removeAllObjects];
}

- (void)saveCityItems
{
    NSMutableArray *arr = [NSMutableArray array];
    for (GTravelCityItem *item in self.cities) {
        [arr addObject:[item dictionaryFormat]];
    }
    [arr writeToFile:self.cacheFileCities atomically:YES];
}

- (void)saveTownItems
{
    NSMutableArray *arr = [NSMutableArray array];
    for (GTravelTownItem *item in self.towns) {
        [arr addObject:[item dictionaryFormat]];
    }
    [arr writeToFile:self.cacheFileTowns atomically:YES];
}

- (void)removeCityItems
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = NULL;
    for (GTravelCityItem *item in self.cities) {
        if (RYIsValidString(item.localThumbnail)) {
            if ([fileManager fileExistsAtPath:item.localThumbnail] && ![fileManager removeItemAtPath:[item.localThumbnail absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                RYCONDITIONLOG(DEBUG, @"%@", error);
            }
        }
    }

    error = NULL;
    if (![fileManager removeItemAtPath:self.cacheFileCities error:&error]) {
        RYCONDITIONLOG(DEBUG, @"");
    }
    [self.cities removeAllObjects];
}

- (void)removeTownItems
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = NULL;
    for (GTravelTownItem *item in self.towns) {
        if (RYIsValidString(item.localThumbnail)) {
            if ([fileManager fileExistsAtPath:item.localThumbnail] && ![fileManager removeItemAtPath:[item.localThumbnail absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                RYCONDITIONLOG(DEBUG, @"%@", error);
            }
        }
    }

    error = NULL;
    if (![fileManager removeItemAtPath:self.cacheFileTowns error:&error]) {
        RYCONDITIONLOG(DEBUG, @"");
    }
    [self.towns removeAllObjects];
}

- (void)saveRouteItems
{
    NSMutableArray *arr = [NSMutableArray array];
    for (GTravelRouteItem *item in self.routes) {
        [arr addObject:[item dictionary]];
    }
    [arr writeToFile:self.cacheFileRoutes atomically:YES];
}

- (void)removeRouteItems
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = NULL;
    for (GTravelRouteItem *item in self.routes) {
        if (RYIsValidString(item.localThumbnail)) {
            if ([fileManager fileExistsAtPath:item.localThumbnail] && ![fileManager removeItemAtPath:[item.localThumbnail absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                RYCONDITIONLOG(DEBUG, @"%@", error);
            }
        }
        if (RYIsValidString(item.userItem.localImageURL)) {
            if ([fileManager fileExistsAtPath:item.userItem.localImageURL] && ![fileManager removeItemAtPath:[item.userItem.localImageURL absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                RYCONDITIONLOG(DEBUG, @"%@", error);
            }
        }
    }

    error = NULL;
    if (![fileManager removeItemAtPath:self.cacheFileRoutes error:&error]) {
        RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    [self.routes removeAllObjects];
}

- (void)saveRecentUsers
{
    NSMutableArray *arr = [NSMutableArray array];
    for (GTDistanceUser *user in self.recentUsers) {
        [arr addObject:[user dictionary]];
    }
    [arr writeToFile:self.cacheFileRecentUsers atomically:YES];
}

- (void)removeRecentUsers
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = NULL;
    for (GTDistanceUser *user in self.recentUsers) {
        if (RYIsValidString(user.localImageURL)) {
            if ([fileManager fileExistsAtPath:user.localImageURL] && ![fileManager removeItemAtPath:[user.localImageURL absolutePathStringWithDirectoryPathType:RYDirectoryTypeDocuments] error:&error]) {
                RYCONDITIONLOG(DEBUG, @"%@", error);
            }
        }
    }
    error = NULL;
    if (![fileManager removeItemAtPath:self.cacheFileRecentUsers error:&error]) {
        RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    [self.recentUsers removeAllObjects];
}

- (void)saveCityIDs
{
    NSMutableArray *arr = [NSMutableArray array];
    for (GTCityBase *city in self.cityIDs) {
        [arr addObject:[city dictionary]];
    }
    [arr writeToFile:self.cacheFileCityIDs atomically:YES];
}

- (void)removeCityIDs
{
    NSError *error = NULL;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager removeItemAtPath:self.cacheFileCityIDs error:&error]) {
        RYCONDITIONLOG(DEBUG, @"%@", error);
    }
    [self.cityIDs removeAllObjects];
}

#pragma mark - Public Methods
- (instancetype)init
{
    if (self = [super init]) {
        [self initializedCache];
    }
    return self;
}

static GTCacheUnit *sharedInstance = nil;
+ (GTCacheUnit *)sharedCache
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
        return sharedInstance;
    }
    return nil;
}

- (void)saveValueToUserDefaults:(NSString *)value forKey:(NSString *)key
{
    if (RYIsValidString(value)) {
        [self.userDefaults setValue:value forKey:key];
    }
    else {
        [self.userDefaults setNilValueForKey:key];
    }
    [self.userDefaults synchronize];
}

- (NSString *)valueInUserDefaultsForKey:(NSString *)key
{
    return [self.userDefaults valueForKey:key];
}

- (void)saveObjectToUserDefaults:(id)object forKey:(NSString *)key
{
    if (object == nil) {
        [self.userDefaults removeObjectForKey:key];
    }
    else {
        [self.userDefaults setObject:object forKey:key];
    }
    [self.userDefaults synchronize];
}

- (id)objectInUserDefaultsForKey:(NSString *)key
{
    return [self.userDefaults objectForKey:key];
}

- (void)saveValueToKeyChain:(NSString *)value forKey:(NSString *)key
{
    if (RYIsValidString(value)) {
        [DTKeychain save:key data:value];
    }
    else
        [DTKeychain delete:key];
}

- (NSString *)valueInKeyChainForKey:(NSString *)key
{
    return [DTKeychain load:key];
}

- (void)updateLaunchImages:(NSArray *)images version:(NSString *)version
{
    if ([self.launchImageVersion isEqualToString:version] && self.launchImages.count == images.count) {
        for (GTLaunchImage *imageItem in self.launchImages) {
            for (GTLaunchImage *item in images) {
                if ([imageItem.imageURL isEqualToString:item.imageURL]) {
                    imageItem.detailURL = item.detailURL;
                    break;
                }
            }
        }
    }
    else {
        [self removeLaunchImages];
        self.launchImages = [NSMutableArray arrayWithArray:images];
        self.launchImageVersion = version;
    }
    [self saveLaunchImages];
}

- (void)updateBanners:(NSArray *)banners version:(NSString *)version
{
    if ([self.bannerImageVersion isEqualToString:version] && self.banners.count == banners.count) {
        for (GTBannerImage *imageItem in self.banners) {
            for (GTBannerImage *item in banners) {
                if ([imageItem.imageURL isEqualToString:item.imageURL]) {
                    imageItem.detailURL = item.detailURL;
                    break;
                }
            }
        }
    }
    else {
        [self removeBanners];
        self.banners = [NSMutableArray arrayWithArray:banners];
        self.bannerImageVersion = version;
    }
    [self saveBanners];
}

- (void)updateTips:(NSArray *)tips version:(NSString *)version
{
    if (![self.tipImageVersion isEqualToString:version]) {
        [self removeTipItems];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSArray *ar in tips) {
            [arr addObject:[NSMutableArray arrayWithArray:ar]];
        }
        self.tipItems = arr;
        self.tipImageVersion = version;
        [self saveTipItems];
    }
}

- (void)updateCityListWithTitle:(NSString *)title cities:(NSArray *)cities atIndex:(NSInteger)index
{
    self.titleOfCities = title;
    if (index == 0) {
        [self removeCityItems];
        self.cities = [NSMutableArray arrayWithArray:cities];
    }
    else {
        [self.cities addObjectsFromArray:cities];
    }
    [self saveCityItems];
}

- (void)updateRouteListWithTitle:(NSString *)title routes:(NSArray *)routes atIndex:(NSInteger)index
{
    self.titleOfRoutes = title;
    if (index == 0) {
        [self removeRouteItems];
        self.routes = [NSMutableArray arrayWithArray:routes];
    }
    else {
        [self.routes addObjectsFromArray:routes];
    }
    [self saveRouteItems];
}

- (void)saveImageData:(NSData *)data forUserItem:(GTravelUserItem *)item
{
    NSString *filePath = [self.cacheFolderRoot stringByAppendingPathComponent:item.userID];
    if ([data writeToFile:filePath atomically:YES]) {
        item.localImageURL = [filePath relativePathString];
    }
}

- (void)saveImageData:(NSData *)data forImageItem:(GTravelImageItem *)item
{
    if ([[item class] isSubclassOfClass:[GTLaunchImage class]]) {
        NSString *fileName = [item.imageURL lastPathComponent];
        NSString *filePath = [self.cacheFolderLaunchImages stringByAppendingPathComponent:fileName];
        if ([data writeToFile:filePath atomically:YES]) {
            item.localImagePath = [filePath relativePathString];
            [self saveLaunchImages];
        }
    }
    else {
        NSString *fileName = [item.imageURL lastPathComponent];
        NSString *filePath = [self.cacheFolderBanners stringByAppendingPathComponent:fileName];
        if ([data writeToFile:filePath atomically:YES]) {
            item.localImagePath = [filePath relativePathString];
            [self saveBanners];
        }
    }
}

- (void)saveImageData:(NSData *)data forToolItem:(GTravelToolItem *)item
{
    NSString *fileName = [item.imageURL lastPathComponent];
    NSString *filePath = [self.cacheFolderTips stringByAppendingPathComponent:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
        item.localImage = [filePath relativePathString];
        [self saveTipItems];
    }
}

- (void)saveThumbnail:(NSData *)data forTipsItem:(GTravelToolItem *)item
{
    NSString *fileName = [item.thumbnailURL lastPathComponent];
    NSString *filePath = [self.cacheFolderTips stringByAppendingPathComponent:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
        item.localThumbnail = [filePath relativePathString];
        [self saveTipItems];
    }
}

- (void)saveImageData:(NSData *)data forCityItem:(GTravelCityItem *)item
{
    NSString *fileName = [item.thumbnailURL lastPathComponent];
    NSString *filePath = [self.cacheFolderCities stringByAppendingPathComponent:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
        item.localThumbnail = [filePath relativePathString];
        [self saveCityItems];
    }
}

- (void)saveImageData:(NSData *)data forTownItem:(GTravelTownItem *)item
{
    NSString *fileName = [item.thumbnailURL lastPathComponent];
    NSString *filePath = [self.cacheFolderCities stringByAppendingPathComponent:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
        item.localThumbnail = [filePath relativePathString];
        [self saveTownItems];
    }
}

- (void)saveImageData:(NSData *)data forRouteItem:(GTravelRouteItem *)item
{
    NSString *fileName = [item.thumnail lastPathComponent];
    NSString *filePath = [self.cacheFolderRoutes stringByAppendingPathComponent:fileName];
    if ([data writeToFile:filePath atomically:YES]) {
        item.localThumbnail = [filePath relativePathString];
        [self saveRouteItems];
    }
}

- (void)saveImageData:(NSData *)data forRouteUserItem:(GTUserBase *)item
{
    NSString *filePath = [self.cacheFolderRoutes stringByAppendingPathComponent:item.userID];
    if ([data writeToFile:filePath atomically:YES]) {
        item.localImageURL = [filePath relativePathString];
        [self saveRouteItems];
    }
}

- (void)updateCityIDs:(NSArray *)cityIDs
{
    [self removeCityIDs];
    self.cityIDs = [NSMutableArray arrayWithArray:cityIDs];
    [self saveCityIDs];
}

- (GTCityBase *)getCityIDofCityName:(NSString *)name
{
    GTCityBase *city = nil;
    for (GTCityBase *ci in self.cityIDs) {
        if ([name rangeOfString:ci.nameCN].location != NSNotFound) {
            city = ci;
            break;
        }
    }
    return city;
}

- (void)updateRecentUsers:(NSArray *)users
{
    [self removeRecentUsers];
    self.recentUsers = [NSMutableArray arrayWithArray:users];
    [self saveRecentUsers];
}

- (void)saveImageData:(NSData *)data forRecentUser:(GTUserBase *)item
{
    NSString *filePath = [self.cacheFolderRecentUsers stringByAppendingPathComponent:item.userID];
    if ([data writeToFile:filePath atomically:YES]) {
        item.localImageURL = [filePath relativePathString];
        [self saveRecentUsers];
    }
}
@end
