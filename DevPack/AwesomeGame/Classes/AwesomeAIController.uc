class AwesomeAIController extends AIController;

var vector targetDirection;
var vector targetLocation;
var Pawn Enemy;
var float MovementSpeed;
DefaultProperties
{
MovementSpeed=128.0
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition); Pawn.SetMovementPhysics();
}

function moveToTarget(vector aLocation) {
	local rotator directionVector;

	targetDirection = aLocation - pawn.location ;
	Normal(targetDirection);

	directionVector = rotator(targetDirection);
	Pawn.FaceRotation(directionVector, 0.01);
	targetDirection *= 1000;
}

//auto state Follow  {

  //      simulated  function Tick(float DeltaTime)
  //      {
   //             local vector NewLocation;

   //             if(Enemy == none)
   //             GetEnemy();
                
   ////               NewLocation = Location;
   //               NewLocation += normal(Enemy.Location - Location) *
   //               MovementSpeed * DeltaTime;
   //               SetLocation(NewLocation);-

        //	targetLocation = Enemy.Location;
	//	moveToTarget(targetLocation);



    //    }
//}

 function GetEnemy()
{
        local AwesomePlayerController PC;
        foreach DynamicActors(class'AwesomePlayerController',PC)
        {
                 if(PC.Pawn != none)
                          Enemy = PC.Pawn;
        }
}






