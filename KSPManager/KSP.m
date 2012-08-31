//
//  KSP.m
//  KSPManager
//
//  Created by Erik O'Shaughnessy on 8/14/12.
//  Copyright (c) 2012 Symbolic Armageddon. All rights reserved.
//

#import "KSP.h"
#import "KSP_Constants.h"
#import "PersistenceFile.h"
#import "Part.h"
#import "Plugin.h"

@implementation KSP

@synthesize baseURL = _baseURL;

@synthesize bundleURL = _appURL;
@synthesize internalsURL = _internalsURL;
@synthesize partsURL = _partsURL;
@synthesize pluginsURL = _pluginsURL;
@synthesize pluginDataURL = _pluginDataURL;
@synthesize resourcesURL = _resourcesURL;
@synthesize persistentURL = _persistentURL;
@synthesize savesURL = _savesURL;
@synthesize screenshotsURL = _screenshotsURL;
@synthesize soundsURL = _soundsURL;
@synthesize settingsURL = _settingsURL;
@synthesize shipsURL = _shipsURL;
@synthesize vabURL = _vabURL;
@synthesize sphURL = _sphURL;
@synthesize availablePartsURL = _availablePartsURL;
@synthesize availablePluginsURL = _availablePluginsURL;
@synthesize availableShipsURL = _availableShipsURL;

@synthesize parts = _parts;
@synthesize plugins = _plugins;

@synthesize persistenceFile = _persistenceFile;
@synthesize unzipURL = _unzipURL;
@synthesize unrarURL = _unrarURL;

@synthesize validInstallation = _validInstallation;



- (id)initWithURL:(NSURL *)fileURL
{
    self = [super init];
    if (self) {
        _baseURL = fileURL;
    }
    return self;
}

#pragma mark -
#pragma mark Readonly Properties

- (NSURL *)buildRelativeFileURL:(NSString *)path
{
    NSError *error = nil;
    
    NSURL *url = [self.baseURL URLByAppendingPathComponent:path];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    
    if( error ) {
        [[NSAlert alertWithError:error] runModal];
        return nil;
    }

    return url;
}

- (NSURL *)buildValidRelativeFileURL:(NSString *)path
{
    
    NSURL *url = [self.baseURL URLByAppendingPathComponent:path];
    NSError *error = nil;
    
    if( [url checkResourceIsReachableAndReturnError:&error ] == NO)
        url = nil;
    
    if( error )
        [[NSAlert alertWithError:error] runModal];
    
    return url;
}

- (NSURL *)bundleURL
{
    if( _appURL == nil ) {
        _appURL = [self buildValidRelativeFileURL:kKSP_APP];
    }
    return _appURL;
}

- (NSURL *)internalsURL
{
    if( _internalsURL == nil ) {
        _internalsURL = [self buildValidRelativeFileURL:kKSP_INTERNALS];
    }
    return _internalsURL;
}

- (NSURL *)partsURL
{
    if( _partsURL == nil ) {
        _partsURL = [self buildValidRelativeFileURL:kKSP_PARTS];
    }
    return _partsURL;
}

- (NSURL *)pluginsURL
{
    if( _pluginsURL == nil ) {
        _pluginsURL =[self buildValidRelativeFileURL:kKSP_PLUGINS];

    }
    return _pluginsURL;
}

- (NSURL *)pluginDataURL
{
    if( _pluginDataURL == nil ) {
        _pluginDataURL =[self buildValidRelativeFileURL:kKSP_PLUGINDATA];
        
    }
    return _pluginDataURL;
}

- (NSURL *)resourcesURL
{
    if( _resourcesURL == nil ) {
        _resourcesURL = [self buildValidRelativeFileURL:kKSP_RESOURCES];
    }
    return _resourcesURL;
}

- (NSURL *)persistentURL
{
    if( _persistentURL == nil ){
        _persistentURL = [self buildValidRelativeFileURL:kKSP_PERSISTENT];
    }
    return _persistentURL;
}

- (NSURL *)savesURL
{
    if( _savesURL == nil ) {
        _savesURL = [self buildValidRelativeFileURL:kKSP_SAVES];
    }
    return _savesURL;
}

- (NSURL *)screenshotsURL
{
    if( _screenshotsURL == nil ) {
        _screenshotsURL = [self buildValidRelativeFileURL:kKSP_SCREENSHOTS];
    }
    return _screenshotsURL;
}

- (NSURL *)soundsURL
{
    if( _soundsURL == nil ) {
        _soundsURL = [self buildValidRelativeFileURL:kKSP_SOUNDS];
    }
    return _soundsURL;
}

- (NSURL *)settingsURL
{
    if( _settingsURL == nil ) {
        _settingsURL = [self buildValidRelativeFileURL:kKSP_SETTINGS];
    }
    return _settingsURL;
}

- (NSURL *)shipsURL
{
    if( _shipsURL == nil ) {
        _shipsURL = [self buildValidRelativeFileURL:kKSP_SHIPS];
    }
    return _shipsURL;
}

- (NSURL *)vabURL
{
    if( _vabURL == nil ) {
        _vabURL = [self buildValidRelativeFileURL:kKSP_VAB];
    }
    return _vabURL;
}

- (NSURL *)sphURL
{
    if( _sphURL == nil ) {
        _sphURL = [self buildValidRelativeFileURL:kKSP_SPH];
    }
    return _sphURL;
}

- (NSURL *)availablePartsURL
{
    if( _availablePartsURL == nil ) {
        _availablePartsURL = [self buildRelativeFileURL:kKSP_MODS_PARTS];
    }
    return _availablePartsURL;
}

- (NSURL *)availablePluginsURL
{
    if( _availablePluginsURL == nil ) {
        _availablePluginsURL = [self buildRelativeFileURL:kKSP_MODS_PLUGINS];
    }
    return _availablePluginsURL;
}

- (NSURL *)availableShipsURL
{
    if( _availableShipsURL == nil ) {
        _availableShipsURL = [self buildRelativeFileURL:kKSP_MODS_SHIPS];
    }
    return _availableShipsURL;
}

- (NSMutableArray *)parts
{
    if( _parts == nil) {
        
        _parts = [[NSMutableArray alloc] init];
        [_parts addObjectsFromArray:[Part inventory:self.partsURL]];
        [_parts addObjectsFromArray:[Part inventory:self.availablePartsURL]];
    }
    return _parts;
}

- (NSMutableArray *)plugins
{
    if( _plugins == nil ) {
        _plugins = [[NSMutableArray alloc] init];
        [_plugins addObjectsFromArray:[Plugin inventory:self.pluginsURL]];
        [_plugins addObjectsFromArray:[Plugin inventory:self.availablePluginsURL]];
    }
    return _plugins;
}

- (PersistenceFile *)persistenceFile
{
    if( _persistenceFile == nil ){
        _persistenceFile = [[PersistenceFile alloc] initWithURL:self.persistentURL];
    }
    return _persistenceFile;
}
- (NSURL *)unzipURL
{
    if( _unzipURL == nil) {
        
        _unzipURL = [NSURL fileURLWithPath:kKSP_DEFAULT_UNZIP_PATH];
        
    }
    return _unzipURL;
    
}

- (NSURL *)unrarURL
{
    if( _unrarURL == nil ){
        _unrarURL = nil;
    }
    return _unrarURL;
    
}

#pragma mark -
#pragma mark Instance Methods

- (BOOL)isValidInstallation
{
    _validInstallation = ( (self.bundleURL != nil) &&
                          (self.internalsURL != nil) &&
                          (self.partsURL != nil) &&
                          (self.pluginsURL != nil) &&
                          (self.screenshotsURL != nil) &&
                          (self.shipsURL != nil ) &&
                          (self.soundsURL != nil)) ;
    
    return _validInstallation;
}


- (BOOL)install:(id)object
{

    if( [[object class] isSubclassOfClass:[Part class]] == YES ) {
        Part *part = (Part *)object;
        [part movePartTo:self.partsURL];
        return part.isInstalled;
    }
    
    if( [[object class] isSubclassOfClass:[Plugin class]] == YES ) {
        Plugin *plugin = (Plugin *)object;
        [plugin movePluginTo:self.pluginsURL];
        return plugin.isInstalled;
    }
    
    return NO;
}

- (BOOL)uninstall:(id)object
{
    if( [[object class] isSubclassOfClass:[Part class]] == YES ) {
        Part *part = (Part *)object;
        [part movePartTo:self.availablePartsURL];
        return !part.isInstalled;
    }
    
    if( [[object class] isSubclassOfClass:[Plugin class]] == YES ) {
        Plugin *plugin = (Plugin *)object;
        [plugin movePluginTo:self.availablePluginsURL];
        return !plugin.isInstalled;
    }
    
    return NO;
}

- (BOOL)add:(id)object
{
    
    if( [[object class] isSubclassOfClass:[Part class]] == YES) {
        Part *part = (Part *)object;
        
        [part copyPartTo:self.availablePartsURL];
        [self.parts addObject:part];
        
        return !part.isInstalled;
    }
    
    if( [[object class] isSubclassOfClass:[Plugin class]] == YES ) {
        Plugin *plugin = (Plugin *)object;
        
        [plugin copyPluginTo:self.availablePluginsURL];
        [self.plugins addObject:plugin];
        
        return !plugin.isInstalled;
    }
 
    return NO;
}

- (BOOL)remove:(id)object
{
    if( [[object class] isSubclassOfClass:[Part class]] ) {
        Part *part = (Part *)object;
        NSMutableArray *tmp = (NSMutableArray *)_parts;
        
        [tmp removeObject:part];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        
        [fileManager removeItemAtURL:part.baseURL error:&error];
        
        if( error ) {
            [[NSAlert alertWithError:error] runModal];
            return NO;
        }
        return YES;
    }
 
    if( [[object class] isSubclassOfClass:[Plugin class]] == YES ){
        
        Plugin *plugin = (Plugin *)object;
        
        NSMutableArray *tmp = (NSMutableArray *)_plugins;
        
        [tmp removeObject:plugin];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        
        [fileManager removeItemAtURL:plugin.baseURL error:&error];
        
        if( error ) {
            [[NSAlert alertWithError:error] runModal];
            return NO;
        }
        return YES;
    }
    
    return NO;
}

- (NSURL *)inflateZipFile:(NSURL *)fileURL inDestination:(NSURL *)dstURL
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ( dstURL == nil ) {
        NSURL *caches = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
        dstURL = [caches URLByAppendingPathComponent:kKSP_TEMP_ASSETS isDirectory:YES];
    }
    
    NSError *error = nil;

    NSString *fname = [fileURL lastPathComponent];
    
    NSURL *tmpURL = [dstURL URLByAppendingPathComponent:[fname stringByDeletingPathExtension]];
    
    if( [tmpURL checkResourceIsReachableAndReturnError:&error] == YES )
        [fileManager removeItemAtURL:tmpURL error:&error];

    // tmpURL is NOT reachable, for sure.
    
    error = nil;
    [fileManager createDirectoryAtURL:tmpURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    if( error ){
        NSLog(@"createDirectory: %@",error);
        return nil;
    }
    
    NSURL *copyURL = [tmpURL URLByAppendingPathComponent:fname];
    
    error = nil;
    [fileManager copyItemAtURL:fileURL toURL:copyURL error:&error];

    if( error ) {
        NSLog(@"copy %@ to %@: %@",fileURL,copyURL,error);
        return nil;
    }
    
    NSTask *task = [[NSTask alloc] init];
    
    [task setCurrentDirectoryPath:tmpURL.path];
    [task setLaunchPath:self.unzipURL.path];
    [task setArguments:@[ fileURL.lastPathComponent]];
    
    [task launch];
    [task waitUntilExit];
    
    if([task terminationStatus] != 0)
        return nil;
    
    return tmpURL;
}


- (NSArray *)createAssetsWith:(NSURL *)url install:(BOOL)install
{
    NSMutableArray *assets = [[NSMutableArray alloc] init];
 
    // if the URL is a file
    //   - can we unarchive/access it?
    //   - locate temporary directory to store/unarchive into
    //   - copy file to temporary directory
    //   - unarchive
    //   - create a new URL of the unarchived directory
    //   - the URL is now a directory
    
    // if the URL is a directory
    //   - conduct a deep part inventory of directory
    //        append results to assets
    //   - conduct a deep plugin inventory
    //        append restuls to assets
    //   - unassociated game assets ( sounds destined for kKSP_SOUNDS, etc )
    //   - other stuff to handle?
    
    NSError *error = nil;
    NSNumber *isDir;
        
    [url getResourceValue:&isDir forKey:NSURLIsDirectoryKey error:&error];
    
    if( [isDir boolValue] == NO) {
        NSString *ext = url.lastPathComponent.pathExtension;
        
        if( [ext caseInsensitiveCompare:@"zip"] == NSOrderedSame ){
            url = [self inflateZipFile:url inDestination:nil];
        }
        
        if( [ext caseInsensitiveCompare:@"dll"] == NSOrderedSame ){
            // it's a trap! err. a plugin.
            
        }
        
        if( [ext caseInsensitiveCompare:@"rar"] == NSOrderedSame ){
            // it's a RAR which needs a third-party helper to unarchive
            
        }
        
    }

    [assets addObjectsFromArray:[Part inventory:url]];
    [assets addObjectsFromArray:[Plugin inventory:url]];
    
    
    for (id asset in assets) {
        [self add:asset];
        if( install )
            [self install:asset];
    }
    
    return assets;
}

- (BOOL)launchKSP
{
    NSTask *task = [[NSTask alloc] init];
    
    [task setLaunchPath:[NSBundle bundleWithURL:self.bundleURL].executablePath];
    [task setCurrentDirectoryPath:self.baseURL.path];
    [task launch];
    
    return task.isRunning;
}

#pragma mark -
#pragma mark Class Methods


+ (NSArray *)locateInstallationDirectories
{
    NSMutableArray *searchPaths = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSSearchPathDomainMask domainMask = NSUserDomainMask | NSLocalDomainMask;

    
    [searchPaths addObjectsFromArray:[fileManager URLsForDirectory:NSAllApplicationsDirectory
                                                         inDomains:domainMask]];

    [searchPaths addObjectsFromArray:[fileManager URLsForDirectory:NSDesktopDirectory
                                                         inDomains:domainMask]];

    [searchPaths addObjectsFromArray:[fileManager URLsForDirectory:NSDownloadsDirectory
                                                         inDomains:domainMask]];

    [searchPaths addObjectsFromArray:[fileManager URLsForDirectory:NSDocumentDirectory
                                                         inDomains:domainMask]];
    
    for (NSURL *url in searchPaths) {
        for (NSString *dirName in @[ kKSP_OSX, kKSP_SHORT, kKSP_LONG ] ){
            KSP *ksp = [[KSP alloc] initWithURL:[url URLByAppendingPathComponent:dirName]];
            if ( ksp.isValidInstallation == YES)
                [results addObject:ksp];
        }
    }
    
    return results;
}

+ (BOOL)terminateRunningKSP
{
    BOOL result = NO;

    NSArray *selectedApps =
    [NSRunningApplication runningApplicationsWithBundleIdentifier:kKSP_BUNDLE_ID ];

    [selectedApps makeObjectsPerformSelector:@selector(terminate)];
    result = YES;
    
    return result;
}




@end