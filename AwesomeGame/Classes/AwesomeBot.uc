class AwesomeBot extends Pawn;

var Pawn Enemy;
var vector targetDirection;
var vector targetLocation;
var AnimNodeSlot FullBodyAnimSlot;

event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        if(AwesomeEnemySpawner(Owner) != none)
        {

                AwesomeEnemySpawner(Owner).EnemyDied();
                Destroy();

        }

}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	if (SkelComp == Mesh)
	{
		FullBodyAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
        }
}


// This uses the Pawn version of SetWalking instead of UTPawn
event SetWalking( bool bNewIsWalking )
{
    super(Pawn).SetWalking(bNewIsWalking);
}

DefaultProperties
{
    Begin Object Name=CollisionCylinder
        CollisionHeight=+44.000000
    End Object

    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
        HiddenGame=FALSE
        HiddenEditor=FALSE
    End Object
 
    Mesh=SandboxPawnSkeletalMesh
 
    Components.Add(SandboxPawnSkeletalMesh)
    ControllerClass=class'AwesomeAIController'

    bJumpCapable=false
    bCanJump=false
 
    GroundSpeed=200.0 //Making the bot slower than the player

}

auto state Follow  {

        simulated  function Tick(float DeltaTime)
        {
                local vector NewLocation;


                if(Enemy == none)
                GetEnemy();

                 SetWalking( true);

                  NewLocation = Location;
                  NewLocation += normal(Enemy.Location - Location) *
                  128.0 * DeltaTime;
                  SetLocation(NewLocation);

        	targetLocation = Enemy.Location;
		moveToTarget(targetLocation);

        FullBodyAnimSlot.PlayCustomAnim('Run_Fwd_Dpi', 1.0);


        }
}

function moveToTarget(vector aLocation) {
	local rotator directionVector;

	targetDirection = aLocation - location ;
	Normal(targetDirection);

	directionVector = rotator(targetDirection);
	FaceRotation(directionVector, 0.01);
	targetDirection *= 1000;
}

 function GetEnemy()
{
        local AwesomePlayerController PC;
        foreach DynamicActors(class'AwesomePlayerController',PC)
        {
                 if(PC.Pawn != none)
                          Enemy = PC.Pawn;
        }
}




