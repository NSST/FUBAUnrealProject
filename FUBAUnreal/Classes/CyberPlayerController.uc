class CyberPlayerController extends UTPlayerController;

var vector PlayerViewOffset;
var bool bLeftMousePressed; //leftmouse button
var bool bRightMousePressed; //rightmouse button


var rotator CurrentCameraRotation;
var vector destination;

/*****************************************************************/
var Vector2D    PlayerMouse;                //Hold calculated mouse position (this is calculated in HUD)

var Vector      MouseHitWorldLocation;      //Hold where the ray casted from the mouse in 3d coordinate intersect with world geometry. We will
											//use this information for our movement target when not in pathfinding.

var Vector      MouseHitWorldNormal;        //Hold the normalized vector of world location to get direction to MouseHitWorldLocation (calculated in HUD, not used)
var Vector      MousePosWorldLocation;      //Hold deprojected mouse location in 3d world coordinates. (calculated in HUD, not used)
var Vector      MousePosWorldNormal;        //Hold deprojected mouse location normal. (calculated in HUD, used for camera ray from above)

/***************************************************************** 
 *  Calculated in Hud after mouse deprojection, uses MousePosWorldNormal as direction vector
 *  This is what calculated MouseHitWorldLocation and MouseHitWorldNormal.
 *
 *  See Hud.PostRender, Mouse deprojection needs Canvas variable.
 *  
 *  **/

var Waypoint CursorDirection;

/**
 * The location the controller should move to (XXX 0,0,0 is 
 * considered un initialiszed)
 */
var vector		targetLocation;

/** 
 * The direction the pawn should move in (XXX 0,0,0 is considered
 * uninitialized)
 */
var vector		targetDirection;
var bool bAttack;

replication
{
        if(bNetDirty)
        CursorDirection;
}

defaultproperties
{
        PlayerViewOffset=(X=-64,Y=0,Z=1024)

        InputClass=class'MouseInterfacePlayerInput'
}

simulated function PostBeginPlay()
{

        super.PostBeginPlay();
        bNoCrosshair = true;

}

simulated event GetPlayerViewPoint(out vector out_Location, out
Rotator out_Rotation)
{

        super.GetPlayerViewPoint(out_Location, out_Rotation);

         if(Pawn != none)
        {

        Pawn.Mesh.SetOwnerNoSee(false);
        if(Pawn.Weapon != none)
                Pawn.Weapon.SetHidden(true);

        out_Location = Pawn.Location + PlayerViewOffset;
        out_Rotation = rotator(Pawn.Location - out_Location);

        }

        CurrentCameraRotation = out_Rotation;

}

//tick function
event PlayerTick( float deltaTime )
{

	super.PlayerTick( deltaTime );
//	`log(MouseHitWorldLocation);
	FaceCursor(MouseHitWorldLocation);
	Pawn.ClientSetRotation(Rotator(MouseHitWorldLocation - Pawn.Location));
//	Pawn.StartFire(0);


}


state PlayerWalking
{
        function PlayerMove(float DeltaTime)
        {

        local vector X, Y, Z, AltAccel;
        local rotator OldRotation;

        GetAxes(CurrentCameraRotation, X, Y, Z);
        AltAccel = PlayerInput.aForward * Z + PlayerInput.aStrafe* Y;
        AltAccel.Z = 0;
        AltAccel = Pawn.AccelRate * Normal(AltAccel);

        OldRotation = Rotation;

        UpdateRotation(DeltaTime);

        if(Role < ROLE_Authority)
        ReplicateMove(DeltaTime, AltAccel, DCLICK_None,OldRotation - Rotation);
        else
        ProcessMove(DeltaTime, AltAccel, DCLICK_None,OldRotation - Rotation);

        }
        
        simulated exec function StartFire(optional byte FireModeNum)
        {

	bLeftMousePressed = FireModeNum == 0;
	bRightMousePressed = FireModeNum == 1;

	//for debug purposes - maybe call another function from here?
	if(bLeftMousePressed)
        FaceCursor(MouseHitWorldLocation);

	if(bRightMousePressed)
        {
        bAttack = true;
        Fire();
        }

}
}





function UpdateRotation(float DeltaTime){



}


function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc)
{
if (CursorDirection != none)
{
return Rotator(CursorDirection.Location - Pawn.Location);
}
else
{
`log('asasddasasd');
return Pawn.Rotation;
}


}

function Fire()
{

        if(bAttack)
        Pawn.StartFire(0);

        bAttack = false;
        //ServerFire(MouseHitWorldLocation);

}

function FaceCursor(vector aLocation) {
	local rotator directionVector;

	aLocation.Z = 60;

	targetDirection = aLocation - pawn.location ;
	Normal(targetDirection);

	directionVector = rotator(targetDirection);
	Pawn.FaceRotation(directionVector, 0.01);
	targetDirection *= 1000;
}

reliable server function ServerFire(Vector loc)
{
 loc.Z = 60;
 CursorDirection = spawn(class'Waypoint', self,,loc);
 //FaceCursor(CursorDirection.Location);
 Pawn.StartFire(0);
}











