class BlueBot extends Enemy;

DefaultProperties
{


    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
     //   Materials(2)=Material'EditorMaterials.WidgetMaterial_X'
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
    CollideActors=false;
    SkeletalMesh=SkeletalMesh'WP_ShockRifle.Mesh.SK_WP_ShockRifle_3P'
    End Object

    WeaponSkeletalMesh=MyWeaponSkeletalMesh
    ControllerClass=class'BotAIController'

    bBlockActors=false
    bJumpCapable=false
    bCanJump=false
    GroundSpeed=200.0 //Making the bot slower than the player
    HP = 100;

    AttackDistance=500.0

    


}


function Attack(Actor target)
{
        local BlueProjectile projectile;
        local Vector TempLocation;
        local Vector TempEnemLocation;

        projectile = spawn(class' BlueProjectile', self,, Location);
        projectile.Damage = 2;
        projectile.Init(normal(target.Location - Location));

        //Bullet Lane 1
        TempLocation = Location;
        TempLocation.Y = TempLocation.Y - 15;
        TempLocation.X = TempLocation.X - 15;

        TempEnemLocation = target.Location;
        TempEnemLocation.Y = TempEnemLocation.Y - 15;
        TempEnemLocation.X = TempEnemLocation.X - 15;

        projectile = spawn(class' BlueProjectile', self,, TempLocation);
        projectile.Damage = 2;
        projectile.Init(normal(TempEnemLocation - TempLocation));
        
        //Bullet Lane 2
        TempLocation = Location;
        TempLocation.Y = TempLocation.Y + 15;
        TempLocation.X = TempLocation.X + 15;

        TempEnemLocation = target.Location;
        TempEnemLocation.Y = TempEnemLocation.Y + 15;
        TempEnemLocation.X = TempEnemLocation.X + 15;

        projectile = spawn(class' BlueProjectile', self,, TempLocation);
        projectile.Damage = 2;
        projectile.Init(normal(TempEnemLocation - TempLocation));

}

simulated function PostBeginPlay()
{

       super.PostBeginPlay();

       if (Mesh != none && WeaponSkeletalMesh != none)
       Mesh.AttachComponentToSocket(WeaponSkeletalMesh, 'WeaponPoint');


}








