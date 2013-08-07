class MU_Minimap extends Compass;

var() MaterialInstanceConstant Minimap;
var() MaterialInstanceConstant CompassOverlay;

var Vector2D MapRangeMin,MapRangeMax;

var() Bool bForwardAlwaysUp;

var Vector2D MapCenter;

var() Const EditConst DrawSphereComponent MapExtentsComponent;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	MapCenter.X = Location.X;
	MapCenter.Y = Location.Y;
	MapRangeMin.X = MapCenter.X - MapExtentsComponent.SphereRadius;
	MapRangeMax.X = MapCenter.X + MapExtentsComponent.SphereRadius;
	MapRangeMin.Y = MapCenter.Y - MapExtentsComponent.SphereRadius;
	MapRangeMax.Y = MapCenter.Y + MapExtentsComponent.SphereRadius;
}

defaultproperties
{
	Begin Object Class=DrawSphereComponent Name=DrawSphere0
     	SphereColor=(B=0,G=255,R=0,A=255)
     	SphereRadius=5000.000000
	End Object
	MapExtentsComponent=DrawSphere0
	Components.Add(DrawSphere0)

	bForwardAlwaysUp=True
        Minimap = MaterialInstanceConstant'HU_Deco_Pipes.SM.Materials.M_HU_Deco_Pipes_SM_Pipe01'
        CompassOverlay = MaterialInstanceConstant'HU_Deco_Pipes.SM.Materials.M_HU_Deco_Pipes_SM_PipeSetB'
}