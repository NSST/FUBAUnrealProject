class AwesomeWeapon extends UTWeapon;

const MAX_LEVEL = 5;
var int CurrentWeaponLevel;
var float FireRates[MAX_LEVEL];

function UpgradeWeapon()
{
        CurrentWeaponLevel++;
        FireInterval[0] = FireRates[CurrentWeaponLevel - 1];
}

replication
{
        if(bNetDirty)
        CurrentWeaponLevel;
}

defaultproperties
{

        FireRates(0)=1.5
        FireRates(1)=1.0
        FireRates(2)=0.5
        FireRates(3)=0.3
        FireRates(4)=0.1

}
