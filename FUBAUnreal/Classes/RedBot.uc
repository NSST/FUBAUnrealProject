class RedBot extends Enemy;

DefaultProperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0025.000000
		CollisionHeight=+0044.000000
	End Object

    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'CH_TwinSouls_Cine.Mesh.SK_CH_RedGuard_Custom'
     //   Materials(2)=Material'EditorMaterials.WidgetMaterial_X'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
        HiddenGame=FALSE
        HiddenEditor=FALSE
        BlockActors=false
        CollideActors=false
    End Object
 
    Mesh=SandboxPawnSkeletalMesh


    Components.Add(SandboxPawnSkeletalMesh)

    Begin Object Class=SkeletalMeshComponent Name=MyWeaponSkeletalMesh
    CastShadow=true
    bCastDynamicShadow=true
    bOwnerNoSee=false
    SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
    End Object

    WeaponSkeletalMesh=MyWeaponSkeletalMesh
    ControllerClass=class'BotAIController'

    bJumpCapable=false
    bCanJump=false
    bCanStrafe=True

    GroundSpeed=200.0 //Making the bot slower than the player
    HP = 100;
    AttackDistance=500.0


}


function Attack(Actor target)
{
        local RedProjectile projectile;
        local Vector temp;

        //Bullet Lane 1
        projectile = spawn(class' RedProjectile', self,, Location);
        projectile.Damage = 2;
        
        temp = target.Location;
        temp.X = temp.X + 100;
        temp.Y = temp.Y + 100;
        projectile.Init(normal(temp - Location));
        
        //Bullet Lane 2
        projectile = spawn(class' RedProjectile', self,, Location);
        projectile.Damage = 2;
        
        temp = target.Location;
        temp.X = temp.X - 100;
        temp.Y = temp.Y - 100;
        projectile.Init(normal(temp - Location));
        

        //Main Lane
        projectile = spawn(class' RedProjectile', self,, Location);
        projectile.Damage = 2;
        
        projectile.Init(normal(target.Location - Location));
        

}

simulated function PostBeginPlay()
{

       super.PostBeginPlay();

       if (Mesh != none && WeaponSkeletalMesh != none)
       Mesh.AttachComponentToSocket(WeaponSkeletalMesh, 'WeaponPoint');

}








