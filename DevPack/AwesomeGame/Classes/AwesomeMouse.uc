/*******************************************************************************
	Awesome
*******************************************************************************/

class AwesomeMouse extends Actor;

//The mesh variable
var() StaticMeshComponent Mesh;

defaultproperties
{
	Begin Object Class=StaticMeshComponent Name=MarkerMesh
		BlockActors=false
		CollideActors=true
		BlockRigidBody=false
		
		StaticMesh=StaticMesh'Pickups.Health_Large.Mesh.S_Pickups_Base_HealthGlow01'
				Scale3D=(X=2.0,Y=2.0,Z=5.0)
				Rotation=(Pitch=0,Yaw=0,Roll=0)
		end object

	Mesh=MarkerMesh
	CollisionComponent=MarkerMesh
	Components.Add(MarkerMesh)
}


//Collision flags so the mouse can interpret what is underneath
/*
// Collision flags.
bCollideWhenPlacing;	// This actor collides with the world when placing.
bCollideActors;			// Collides with other actors.
bCollideWorld;			// Collides with the world.
bCollideComplex;		// Ignore Simple Collision on Static Meshes, and collide per Poly.
bBlockActors;			// Blocks other nonplayer actors.
bProjTarget;			// Projectiles should potentially target this actor.
bBlocksTeleport;
/** Controls whether move operations should collide with destructible pieces or not. */
bMoveIgnoresDestruction;
*/
