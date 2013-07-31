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
	
	Begin Object Class=SkeletalMeshComponent Name=SandboxPawnSkeletalMesh
        SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
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
    InvManager.CreateInventory(class'AwesomeWeapon_RocketLauncher');
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    AddDefaultInventory(); //GameInfo calls it only for players, so we have to do it ourselves for AI.
}

function addItem(Item item)
{
        local int index;
        
        `log('CALLED');
        for(index = 0; index < MAX_ITEMS ; index++)
        {
        
                if(items[index] == none)
                {

                        items[index] = item;
                        ClientAddItem(item);
                            `log(items[0] @ ' INDEX 0');
                            `log(items[1] @ ' INDEX 1');
                            `log(items[2] @ ' INDEX 2');
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


    


