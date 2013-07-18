class AwesomeBot extends UDKPawn;

var Pawn Enemy;
var int BotID;
var vector targetDirection;
var vector targetLocation;
var AnimNodeSlot FullBodyAnimSlot;
var() SkeletalMeshComponent WeaponSkeletalMesh;
var int HP;
var float AttackDistance;


event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{


        HP -= 10;

        if(HP<= 0 && AwesomeEnemySpawner(Owner) != none)
        {

                AwesomeEnemySpawner(Owner).EnemyDied();
                Destroy();

        }
        
        `log(DamageCauser);
        
        if (UTProj_LinkPlasma(DamageCauser) != none)
        {
                `log("sDAMAGE CAUSED");
        }
        


}

replication
{
        if(bNetDirty)
        Enemy,HP,BotID;
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	if (SkelComp == Mesh)
	{
		FullBodyAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
        }
}

function AddDefaultInventory()
{
        local AwesomeWeapon_RocketLauncher newWeapon;
        newWeapon = Spawn(class'AwesomeWeapon_RocketLauncher',,,self.Location);
        newWeapon.ClientGivenTo(self,false);
        Weapon = newWeapon;
        if (newWeapon != none)
        {
        newWeapon.GiveTo(Self);
        newWeapon.bCanThrow = false; // don't allow default weapon to be thrown out
        }
        

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

    Begin Object Class=SkeletalMeshComponent Name=MyWeaponSkeletalMesh
    CastShadow=true
    bCastDynamicShadow=true
    bOwnerNoSee=false
    SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_Linkgun_3P'
    End Object

    WeaponSkeletalMesh=MyWeaponSkeletalMesh
    


    ControllerClass=class'AwesomeAIController'

    bJumpCapable=false
    bCanJump=false

    InventoryManagerClass = class'HeroInventoryManager'
    GroundSpeed=200.0 //Making the bot slower than the player
    HP = 100;
    AttackDistance=500.0


}

auto state Follow  {

        simulated  function Tick(float DeltaTime)
        {
                  local vector NewLocation;

                  if(Enemy == none)
                  GetEnemy();

                  NewLocation = Location;
                  NewLocation += normal(Enemy.Location - Location) *
                  128.0 * DeltaTime;
                  SetLocation(NewLocation);

                  targetLocation = Enemy.Location;
	 	  moveToTarget(targetLocation);



                if(VSize(NewLocation - Enemy.Location) < AttackDistance)
                {
                SetTimer(1, true, 'Attack');
             //   Attack();
                }



                  if(AwesomeGameReplicationInfo(WorldInfo.GRI) != none)
                  {
                  
                  AwesomeGameReplicationInfo(WorldInfo.GRI).EnemyLocation[BotID] = Location;
                  AwesomeGameReplicationInfo(WorldInfo.GRI).EnemyHealth[BotID] = HP;

                  }
                  


                FullBodyAnimSlot.PlayCustomAnim('run_fwd_rif', 1);


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

simulated function PostBeginPlay()
{
       super.PostBeginPlay();

       if (Mesh != none && WeaponSkeletalMesh != none)
       Mesh.AttachComponentToSocket(WeaponSkeletalMesh, 'WeaponPoint');



}

function Attack()
{

        local int RandomNumber;

        RandomNumber = Rand(4);

        switch(RandomNumber)
        {
                case 0:
                FireRedProjectile();
                break;

                case 1:
                FireBlueProjectile();
                break;
                
                case 2:
                FireGreenProjectile();
                break;
                
                case 3:
                FireWhiteProjectile();
                break;

        }

}

function FireRedProjectile()
{
        local RedProjectile projectile;
        projectile = spawn(class' Proj.RedProjectile', self,, Location);
        projectile.Damage = 2;
        projectile.Init(normal(Enemy.Location - Location));
}

function FireGreenProjectile()
{
        local GreenProjectile projectile;
        projectile = spawn(class' GreenProjectile', self,, Location);
        projectile.Damage = 2;
        projectile.Init(normal(Enemy.Location - Location));
}

function FireBlueProjectile()
{
        local BlueProjectile projectile;
        projectile = spawn(class' BlueProjectile', self,, Location);
        projectile.Damage = 2;
        projectile.Init(normal(Enemy.Location - Location));
}

function FireWhiteProjectile()
{
        local CustomProjectile projectile;
        projectile = spawn(class' CustomProjectile', self,, Location);
        projectile.Damage = 2;
        projectile.Init(normal(Enemy.Location - Location));
}



function createTwoRandom(out int number1, out int number2, optional int maxValue = 10)
{
   number1 = Rand(maxValue);
   number2 = Rand(maxValue);
}




