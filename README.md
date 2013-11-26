~~Please note: I ordered a set of Estimotes but haven't seen them yet, so I can't test this code. 11/22/13~~
Received the estimotes but have not tested yet 11/26/13

### Usage ###

```javascript

var estimote = require('estimote');

estimote.addEventListener('connect', function(e){ alert('connect '+e.beaconId); });
estimote.addEventListener('disconnect', function(e){ alert('disconnect '+e.beaconId); });
estimote.addEventListener('enterZone', function(e){ alert('enterZone '+e.beaconId+" "+e.zone); });

estimote.startLookingForBeacons();
```
