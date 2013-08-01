class AwesomePawn extends UTPawn;

var bool bWalking;
var Item items[6];
var int MAX_ITEMS;

//compute health bar
event TakeDamage(int DamageAmount, Controller EventInstigator,
vector HitLocation, vector Momentum, class<DamageType> DamageType,
optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{


        if(UTProj_Rocket(DamageCauser) != none)
        {

        }
        
        else
        
        {
                 super.TakeDamage(DamageAmount, EventInstigator,HitLocation, Momentum,  DamageType,HitInfo, DamageCauser);
        }

}

defaultproperties
{
	Begin Object Name=CollisionCylinder
		CollisionRadius=+0025.000000
		CollisionHeight=+0044.000000
	End Object


        bWalking = false;
        MAX_ITEMS = 6;
}

replication
{
        if(bNetDirty)
        bWalking ;
}

function AddDefaultInventory()
{
    InvManager.CreateInventory(class'AwesomeWeapon_ShockRifle');
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    AddDefaultInventory(); //GameInfo calls it only for players, so we have to do it ourselves for AI.
}

function addItem(Item item)
{
        local int index;

        for(index = 0; index < MAX_ITEMS ; index++)
        {
        
                if(items[index] == none)
                {

                        items[index] = item;
                        ClientAddItem(item);
                        return;
                }

        }




      //  if(Role < ROLE_Authority)

}

// tell the client to add them too
reliable client function ClientAddItem(Item item)
{

        local int index;
        
        for(index = 0; index < MAX_ITEMS ; index++)
        {
        
                if(items[index] == none)
                {
                        items[index] = item;
                         return;
                }

        }

}


    


