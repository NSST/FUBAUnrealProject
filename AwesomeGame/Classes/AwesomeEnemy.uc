class AwesomeEnemy extends AwesomeActor;

var Pawn Enemy;
var float AttackDistance;
var float MovementSpeed;
var bool bAttacking;

event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        if(AwesomeEnemySpawner(Owner) != none)
                AwesomeEnemySpawner(Owner).EnemyDied();
        Destroy();
}

replication
{
        if(bNetDirty)
        Enemy,bAttacking;
}

defaultproperties
{
        bBlockActors=True
        bCollideActors=True

        Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
        bEnabled=TRUE
        End Object

        Components.Add(MyLightEnvironment)

        Begin Object Class=StaticMeshComponent Name=PickupMesh
        StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
        Materials(0)=Material'EditorMaterials.WidgetMaterial_X'
        LightEnvironment=MyLightEnvironment
        Scale3D=(X=0.25,Y=0.25,Z=0.5)
        End Object

        Components.Add(PickupMesh)

        Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=32.0
        CollisionHeight=64.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
        End Object

        CollisionComponent=CollisionCylinder
        Components.Add(CollisionCylinder)
        
        AttackDistance=300.0
        MovementSpeed=128.0
        bCanBeDamaged = true;

        RemoteRole=ROLE_SimulatedProxy
        bAlwaysRelevant=true

}

 auto state Seeking
{


        simulated  function Tick(float DeltaTime)
        {

        local vector NewLocation;
        
       // `log("Enemy walking" @ bAttacking);
        
        if(bAttacking)
        return;

        if(Enemy == none)
        GetEnemy();


        NewLocation = Location;
        NewLocation += normal(Enemy.Location - Location) *
        MovementSpeed * DeltaTime;
        SetLocation(NewLocation);
        


         if(VSize(NewLocation - Enemy.Location) < AttackDistance)
                GoToState('Attacking');

        }



}

state Attacking
{
        simulated  function Tick(float DeltaTime)
        {

        bAttacking = true;

        if(Enemy == none)
        GetEnemy();

        if(Enemy != none)
        {

        SetTimer(1, false, 'Attack');

        if(VSize(Location - Enemy.Location) > AttackDistance)
        GoToState('Seeking');

        }

        }
        
        function EndState(name NextStateName)
        {
        SetTimer(1, false, 'EndAttack');
        }
}

state Frozen
{
        function Tick(float DeltaTime)
        {

        }
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

function Attack()
{
        local UTProj_Rocket MyRocket;
        MyRocket = spawn(class'UTProj_Rocket', self,, Location);
        MyRocket.Damage = 5;
        MyRocket.Init(normal(Enemy.Location - Location));
        SetTimer(1, false, 'EndAttack');
}

simulated function EndAttack()
{
        bAttacking = false;
        `log("ATTACK ENDED");
}



