class GreenBot extends Enemy;

event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
        local int Damage;

        //default damage
        Damage = 10;

        //AwesomeWeapon_GreenLinkGUn fires GreenProjectile
        //What happens when damaged by green weapon
        if (LinkGun_GreenProjectile(DamageCauser) != none)
        {

                BroadcastMessage = "ABSORBED!";
                Damage = 5;

        }

        //AwesomeWeapon_LinkGUn fires LinkPlasma
        //What happens when damaged by white weapon
        if (LinkGun_WhiteProjectile(DamageCauser) != none)
        {

                BroadcastMessage = "CRITICAL HIT!";
                Damage = 50;

        }

        HP -= Damage;

        if(HP <= 0 && EnemyFactory(Owner) != none)
        {
                //Score point
                 if(EventInstigator != none && EventInstigator.PlayerReplicationInfo != none)
                        WorldInfo.Game.ScoreObjective(EventInstigator.PlayerReplicationInfo, 1);

                 Killed();
        }
        

        SetTimer(1, true, 'ResetMessage');


}

DefaultProperties
{



    Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
      //  Materials(1)=Material'EditorMaterials.M_Awning_03'
     //   Materials(0)=Material'Castle_Assets.Textures.M_Awning_05'
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
    ControllerClass=class'DefensiveAIController'

    bJumpCapable=false
    bCanJump=false
    bBlockActors=false
    GroundSpeed=200.0 //Making the bot slower than the player
    HP = 100;
    AttackDistance=500.0
    


}

function Attack(Actor target)
{
        local GreenProjectile projectile;
        projectile = spawn(class' GreenProjectile', self,, Location);
        projectile.Damage = 2;
        projectile.Init(normal(target.Location - Location));
}








