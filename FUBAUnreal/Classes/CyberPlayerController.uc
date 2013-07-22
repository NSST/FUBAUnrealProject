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
 *  **/

var Waypoint waypoint; //Control moving player
var Waypoint CursorDirection;


var Vector DestinationXYLocation;
var Vector PawnXYLocation;


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

//Annouce changes to server for updating
replication
{
        if(bNetDirty)
        waypoint,CursorDirection;
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

//Change the view to top-down view
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
}

//tick function
simulated event PlayerTick( float deltaTime )
{
        super.PlayerTick(deltaTIme);

        if(!AwesomePawn(Pawn).bWalking)
        {
        	targetDirection = vect(0,0,0);
		targetLocation = vect(0,0,0);
        	faceWaypoint();
	}
	else
	{
	       if (waypoint != none)
        	faceWaypoint();
	}
	
	if (CursorDirection != none)
	faceCursor();

}




function SpawnWaypoint()
{

        if (waypoint != none)
       {
        waypoint.Destroy();
        waypoint = spawn(class'Waypoint', self,,MouseHitWorldLocation);
        

       } 
       else
       {
       waypoint = spawn(class'Waypoint', self,,MouseHitWorldLocation);
       }
       
       AwesomePawn(Pawn).bWalking = true;


}

//Mouse direction
function SpawnCursorDirection()
{

        if (CursorDirection!= none)
       {
        CursorDirection.Destroy();
        CursorDirection = spawn(class'Waypoint', self,,MouseHitWorldLocation);


       }
       else 
       {
       CursorDirection = spawn(class'Waypoint', self,,MouseHitWorldLocation);
       }

}
// method used to let character face mouse click
function faceWaypoint()
{
        local rotator r;
        local vector v;
        local vector temp;
        
        if(waypoint == none)
        return;

        temp = waypoint.Location;
        temp.Z = 60;//for shooting in straight line

        v = temp - Pawn.Location;
        r = Rotator(v);
        Pawn.SetRotation(r);
}

//used for shooting face to mouse
simulated function faceCursor()
{
        local rotator r;
        local vector v;

       // `log("afa" @ CursorDirection.Location.X @ CursorDirection.Location.Y @ CursorDirection.Location.Z);
        v = CursorDirection.Location - Pawn.Location;
        r = Rotator(v);
        Pawn.SetRotation(r);
}

//method used to move from A to B
function moveToTarget(vector aLocation) {
	local rotator directionVector;


	targetDirection = aLocation - pawn.location ;
	Normal(targetDirection);

	directionVector = rotator(targetDirection);
	Pawn.FaceRotation(directionVector, 0.01);
	targetDirection *= 1000;

}

 function UpdateRotation( float DeltaTime )
{

}

//method to adjust aim
simulated function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc)
{
if (CursorDirection != none)
{
return Rotator(CursorDirection.Location - Pawn.Location);
}
else
{
return Pawn.GetBaseAimRotation();
}


}
//Server method
reliable server function ServerFire(Vector loc)
{
 loc.Z = 60;
 CursorDirection = spawn(class'Waypoint', self,,loc);
 FireRocket();
}

simulated function FireRocket()
{
    //   local UTProj_Rocket MyRocket;
    //    local vector temp;

    //    temp = CursorDirection.Location;
    //    temp.Z = 60;
    //    MyRocket = spawn(class'UTProj_Rocket', self,, Pawn.Location);
    //  MyRocket.Damage = 5;
   //     MyRocket.Init(normal(temp - Pawn.Location));

   faceCursor();

  Pawn.StartFire(0);
}
//state to move player
state PlayerWalking  {
	/** Override for the non server situation */
	function ProcessMove(float DeltaTime, vector NewAccel,
                                           eDoubleClickDir DoubleClickMove, 
                                           rotator DeltaRot) {

                boo = false;
		// check if the bot is moving towards a specific location
		if (VSize(targetDirection) > 0) {

			// use the targetdirection
			Super.ProcessMove(DeltaTime, targetDirection,
                                                          DoubleClickMove, DeltaRot);
		}
		else {
			// use the normal process move
			Super.ProcessMove(DeltaTime, NewAccel, 
                                                          DoubleClickMove, DeltaRot);
		}
	}

	/** Override for the non server situation */
	function ReplicateMove (float DeltaTime, vector NewAccel,
                                                eDoubleClickDir DoubleClickMove,  
                                                  rotator DeltaRot) {
                boo = false;


		// check if the bot is moving towards a specific location
		if (VSize(targetDirection) > 0) {

			// use the targetdirection
			Super.ReplicateMove(DeltaTime, targetDirection, 
                                                               DoubleClickMove, DeltaRot);
		}
		else {
			// use the normal process move
			Super.ReplicateMove(DeltaTime, NewAccel,
                                                             DoubleClickMove, DeltaRot);
		}
	}

        //method used to shoot
	simulated function StartFire(optional byte FireModeNum)
{

  // Initialise for the mouse over time funtionality
	bLeftMousePressed = FireModeNum == 0;
	bRightMousePressed = FireModeNum == 1;

	//for debug purposes - maybe call another function from here?
	if(bLeftMousePressed)
	{

	        SpawnWaypoint();
	        faceWaypoint();
		targetLocation = waypoint.Location;
		moveToTarget(waypoint.Location);//destination

	}
	if(bRightMousePressed)
	{

	        SpawnCursorDirection();
	        FireRocket();
                ServerFire(MouseHitWorldLocation);


	}
//	Super.StartFire(FireModeNum);
}
}











