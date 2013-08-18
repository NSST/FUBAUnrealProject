class AwesomeWeapon_RocketLauncher extends UTWeap_RocketLauncher;

const MAX_LEVEL = 5;
var float FireRates[MAX_LEVEL];

//Upgrade Weapon, based on grade of the item
simulated function UpgradeWeapon(int grade)
{

        FireInterval[0] = FireRates[grade];
        ServerUpgradeWeapon(grade);
}


defaultproperties
{
        Begin Object Name=PickupMesh
        SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_3P'
        End Object

        AttachmentClass=class'UTGameContent.UTAttachment_RocketLauncher'
        
        WeaponFireTypes(0)=EWFT_Projectile
        WeaponFireTypes(1)=EWFT_Projectile

        WeaponProjectiles(0)=class'UTProj_Rocket'
        WeaponProjectiles(1)=class'UTProj_Rocket'

        FireRates(0)=1.5
        FireRates(1)=1.0
        FireRates(2)=0.5
        FireRates(3)=0.3
        FireRates(4)=0.1

        AmmoCount=9999
        MaxAmmoCount=9999
}

// tell the server to upgrade them too
reliable server function ServerUpgradeWeapon(int grade)
{

        FireInterval[0] = FireRates[grade];

}