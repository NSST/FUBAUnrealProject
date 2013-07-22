class BotAIController extends GameAIController;

var vector targetDirection;
var vector targetLocation;
var float MovementSpeed;
var Actor Enem;
var() Vector TempDest;
var Vector NextMoveLocation;
var AnimNodeSlot FullBodyAnimSlot;
var float AttackDistance;


DefaultProperties
{

MovementSpeed=250.0
AttackDistance=800;
NavigationHandleClass=class'NavigationHandle'
RemoteRole=ROLE_SimulatedProxy
bPreciseDestination = False;

}
//allow AI to work
event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super.Possess(inPawn, bVehicleTransition); 
    Pawn.SetMovementPhysics();
}

//function used to move to destination
function moveToTarget(vector aLocation) {
	local rotator directionVector;

	targetDirection = aLocation - pawn.location ;
	Normal(targetDirection);

	directionVector = rotator(targetDirection);
	Pawn.FaceRotation(directionVector, 0.01);
	targetDirection *= 1000;
}

//fuction to die
function Suicide()
{
        local UTProj_Rocket MyRocket;
        MyRocket = spawn(class'UTProj_Rocket', self,, Pawn.Location);
        MyRocket.Damage = 5;
        MyRocket.Init(normal(Enem.Location - Pawn.Location));
}

//patrol from A to B
auto state Patrolling1
{

  	simulated  function Tick(float DeltaTime)
        {

        local Actor destination; 
        destination = EnemyFactory(Pawn.Owner).MyNavigationPoints[0];
        
        if(Enem == none)
        GetEnemy();

         if( !ActorReachable(destination) )
	{
		if( FindNavMeshPath(destination) )
		{
                        NavigationHandle.SetFinalDestination(destination.Location);
			// move to the first node on the path
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
			// suggest move preparation will return TRUE when the edge's
			// logic is getting the bot to the edge point
			     if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
                                MoveToVector( DeltaTime,TempDest,MovementSpeed - 100 );
			}

                        }

			else
			{

			}
		}
		else
		{
			// then move directly to the actor
			MoveToVector(DeltaTime,destination.Location,MovementSpeed - 100);
		}

                if(VSize(destination.Location - Pawn.Location) < 50.0 && !Enemy(Pawn).isDead)
                {
                        GoToState('Patrolling2');

                }
                
                if(VSize(Enem.Location - Pawn.Location) < 500.0 && !Enemy(Pawn).isDead)
                {

                        GoToState('Moving');

                }


                //Run animation
                //SetFocalPoint(destination.Location);
                Enemy(Pawn).Run();
        }

}

//reverse B to A
state Patrolling2
{

  	simulated  function Tick(float DeltaTime)
        {

        local Actor destination; 
        destination = EnemyFactory(Pawn.Owner).MyNavigationPoints[1];
        
        if(Enem == none)
        GetEnemy();

         if( !ActorReachable(destination) )
	{
		if( FindNavMeshPath(destination) )
		{
                        NavigationHandle.SetFinalDestination(destination.Location);
			// move to the first node on the path
			if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			{
			// suggest move preparation will return TRUE when the edge's
			// logic is getting the bot to the edge point
			     if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
                                MoveToVector( DeltaTime,TempDest,MovementSpeed - 100 );
			}

                        }

			else
			{

			}
		}
		else
		{
			// then move directly to the actor
			MoveToVector(DeltaTime,destination.Location,MovementSpeed - 100);
		}

                if(VSize(destination.Location - Pawn.Location) < 50.0 && !Enemy(Pawn).isDead)
                {
                        GoToState('Patrolling1');

                }

                if(VSize(Enem.Location - Pawn.Location) < 500.0 && !Enemy(Pawn).isDead)
                        GoToState('Moving');




                //Run animation
                //SetFocalPoint(destination.Location);
                Enemy(Pawn).Run();
        }

}

//path fiding for bot
function bool FindNavMeshPath(Actor target)
{

	if ( NavigationHandle == None )
	InitNavigationHandle();

	// Clear cache and constraints (ignore recycling for the moment)
	NavigationHandle.ClearConstraints();
	NavigationHandle.PathConstraintList = none;
	NavigationHandle.PathGoalList = none;

	// Create constraints
	class'NavMeshPath_Toward'.static.TowardGoal( NavigationHandle,target );
	class'NavMeshGoal_At'.static.AtActor( NavigationHandle, target );

	// Find path
	return NavigationHandle.FindPath();
}

//move and attack
state Moving
{


	simulated  function Tick(float DeltaTime)
        {

                if(Enem == none)
                GetEnemy();
                
                if (Enemy(Pawn).isDead)
                GoToState('Patrolling1');


		if( !ActorReachable(Enem) )
		{
			if( FindNavMeshPath(Enem) )
			{
                                NavigationHandle.SetFinalDestination(Enem.Location);
			// move to the first node on the path
			     if( NavigationHandle.GetNextMoveLocation( TempDest, Pawn.GetCollisionRadius()) )
			      {
				// suggest move preparation will return TRUE when the edge's
			    // logic is getting the bot to the edge point
				if (!NavigationHandle.SuggestMovePreparation( TempDest,self))
				    {
				MoveToVector( DeltaTime,TempDest,300.0 );
				    }

			     }

			
                        }
			else
			{
				//give up because the nav mesh failed to find a path
				`warn("FindNavMeshPath failed to find a path to"@ Enem);
				Enem = None;
			}   
		}
		else
		{
			// then move directly to the actor
			MoveToVector(DeltaTime,Enem.Location,300.0);
		}


                if(VSize(Pawn.Location - Enem.Location) < 100.0)
                {
                  SetTimer(0.5, true, 'PawnFire');
                }
                
                if(VSize(Pawn.Owner.Location - Pawn.Location) > 900.0 && !Enemy(Pawn).isDead)
                {
                       GoToState('Patrolling1');
                }

   // `log(VSize(Pawn.Owner.Location - Pawn.Location ));

                //Run animation
                Enemy(Pawn).Run();
                //super.Tick(DeltaTime);

        }
        
        function EndState(name NextStateName)
        {
        `log("STATE ENDED!");
        }



}

//bot attact
function PawnFire()
{

        if (IsInState('Patrolling1')) //this gives error
                return;
                
        if (IsInState('Patrolling2')) //this gives error
                return;

        if (RedBot(Pawn) != none)
                RedBot(Pawn).Attack(Enem);
        if (BlueBot(Pawn) != none)
                BlueBot(Pawn).Attack(Enem);
        if (GreenBot(Pawn) != none)
                GreenBot(Pawn).Attack(Enem);

}

//initialize animation tree
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	if (SkelComp == Pawn.Mesh)
	{
		FullBodyAnimSlot = AnimNodeSlot(Pawn.Mesh.FindAnimNode('FullBodySlot'));
        }
}

//move to vector
function MoveToVector(float DeltaTime, Vector destination,float Speed)
{

                  local vector NewLocation;

                  NewLocation = Pawn.Location;
                  NewLocation += normal(destination - Pawn.Location) * Speed * DeltaTime;
                  Pawn.SetLocation(NewLocation);

                  moveToTarget(destination);
}

//test fuction
function MoveAwayFromVector(float DeltaTime, Vector destination,float Speed)
{

                  local vector NewLocation;

                  NewLocation = Pawn.Location;
                  NewLocation +- normal(destination - Pawn.Location) * Speed * DeltaTime;
                  Pawn.SetLocation(NewLocation);

                  moveToTarget(Enem.Location);
}

//get enemy
 function GetEnemy()
{

        local CyberPlayerController PC;
        foreach DynamicActors(class'CyberPlayerController',PC)
        {

                 if(PC.Pawn != none)
                          Enem = PC.Pawn;
        }

}

simulated function InitNavigationHandle()
{
	if( NavigationHandleClass != None && NavigationHandle == none )
		NavigationHandle = new(self) NavigationHandleClass;
}

function InitFullBodyAnim()
{
	if( FullBodyAnimSlot == none )
		FullBodyAnimSlot = AnimNodeSlot(Pawn.Mesh.FindAnimNode('FullBodySlot'));
}


