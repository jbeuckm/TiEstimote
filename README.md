### Usage ###

```javascript

var estimote = require('estimote');
estimote.startLookingForBeacons();

estimote.addEventListener('connect', function(e){ alert('connect '+e.beaconId); });
estimote.addEventListener('disconnect', function(e){ alert('disconnect '+e.beaconId); });
estimote.addEventListener('enterZone', function(e){ alert('enterZone '+e.beaconId+" "+e.zone); });

```