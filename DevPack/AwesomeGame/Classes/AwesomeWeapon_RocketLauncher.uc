class AwesomeWeapon_RocketLauncher extends AwesomeWeapon;

defaultproperties
{
        Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
        End Object

        Components.Add(PickupMesh)

        AttachmentClass=class'UTGameContent.UTAttachment_RocketLauncher'

        WeaponFireTypes(0)=EWFT_Projectile
        WeaponFireTypes(1)=EWFT_Projectile

        WeaponProjectiles(0)=class'UTProj_Rocket'
        WeaponProjectiles(1)=class'UTProj_Rocket'

        AmmoCount=30
        MaxAmmoCount=30


}

reliable client function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    local AwesomeBot Bot;

    super.ClientGivenTo(NewOwner, bDoNotActivate);

    Bot = AwesomeBot(NewOwner);

    if (Bot != none && Bot.Mesh.GetSocketByName('WeaponPoint') != none)
    {
        Mesh.SetShadowParent(Bot.Mesh);
       // Mesh.SetLightEnvironment(Bot.LightEnvironment);
        Bot.Mesh.AttachComponentToSocket(Mesh, 'WeaponPoint');
       `log( Bot.Mesh.GetSocketByName('WeaponPoint'));
   }

}

simulated function PostBeginPlay()
{


}