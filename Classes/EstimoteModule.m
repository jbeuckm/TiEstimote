
#import "EstimoteModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"



@interface EstimoteModule ()

@property (nonatomic, strong) BeaconManager *beaconManager;
@property (nonatomic, assign) ZoneName currentZone;

@end


@implementation EstimoteModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"d8df286a-a7f9-4f2a-ae80-5c47fdac1e24";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"estimote";
}

#pragma mark Lifecycle

-(void)startup
{
    _beaconManager = [BeaconManager new];
    _beaconManager.delegate = self;
    
    _currentZone = Unknown;


	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs


-(void)startLookingForBeacons:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    [_beaconManager startLookingForBeacons];
}



#pragma mark - BeaconManager delegate methods

- (void)managerDidConnectToBeaconWithID:(NSString *)beaconID
{
    [_beaconManager startMonitoringZones];

    NSDictionary *beaconEvent = [[NSDictionary alloc] initWithObjectsAndKeys:
                                beaconID, @"beaconID",
                                nil];
    
    [self fireEvent:@"connect" withObject:beaconEvent];
}

- (void)managerDidDisconnectBeaconWithID:(NSString *)beaconID
{
    [_beaconManager startLookingForBeacons];
    
    NSDictionary *beaconEvent = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 beaconID, @"beaconID",
                                 nil];
    
    [self fireEvent:@"disconnect" withObject:beaconEvent];
}

/*
 The beacon zones are simply determined by the RSSI which is already stabilised and processed by BeaconManager
 */
- (void)enteredZone:(ZoneName)zone forBeaconWithID:(NSString *)beaconID
{
    if (zone == Immediate && _currentZone != Immediate) {
        
        _currentZone = Immediate;
        
    }
    
    else if (zone == Near && _currentZone != Near) {
        
        _currentZone = Near;
        
    }
    
    else if (zone == Far && _currentZone != Far) {
        
        _currentZone = Far;
        
    }

    NSDictionary *beaconEvent = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 beaconID, @"beaconID",
                                 [NSNumber numberWithInt:_currentZone], @"zone",
                                 nil];
    
    [self fireEvent:@"enterZone" withObject:beaconEvent];
}


@end
