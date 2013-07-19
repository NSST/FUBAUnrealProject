class AwesomePawn extends UTPawn;

var bool bWalking;

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
}

replication
{
        if(bNetDirty)
        bWalking ;
}


    


