class AwesomePawn extends UTPawn;

var bool bWalking;

defaultproperties
{
bWalking = false;
}

replication
{
        if(bNetDirty)
        bWalking ;
}

event Bump(Actor Other, PrimitiveComponent OtherComp, vector
HitNormal)
{
super.Bump(Other, OtherComp,HitNormal);
`log("Bump!");

}

    //Returns Aim Rotation
simulated singular event Rotator GetBaseAimRotation()
{
   local rotator POVRot, tempRot;

   tempRot = Rotation;
   tempRot.Pitch = 0;
   SetRotation(tempRot);
   POVRot = Rotation;
   POVRot.Pitch = 0;

   return POVRot;
}

simulated function vector GetAimStartLocation()
{
	local Vector pawnAimLocation;
	if (Weapon != none)
	{
		pawnAimLocation = Location + vect(0,0,1) * (Weapon.GetPhysicalFireStartLoc().Z - Location.Z); // just use upvector
		return pawnAimLocation;
	}
	else
	{
		return GetPawnViewLocation(); // eye fallback
	}
}
    


