Class AwesomeActor extends Actor
placeable;

var vector LocationOffset;
var bool bIsItRaining;

defaultproperties
{

}

function PostBeginPlay()
{

        LocationOffset.Z = 64.0;
        SetLocation(Location + LocationOffset);

}