class STGFxHUD extends GFxMoviePlayer;


var CyberPlayerController PlayerOwner;

//Called from STHUD'd PostBeginPlay()
function Init2(CyberPlayerController PC)
{
	//Start and load the SWF Movie
	Start();
	Advance(0.f);

}

function showInventory()
{

local array<ASValue> args;
local ASValue asval;

asval.Type = AS_String;
asval.s = "Matthew";
args[0] = asval;

asval.Type = AS_Number;
asval.n = 38;
args[1] = asval;
        GetVariableObject("root").Invoke("showInventory",args );
	//`log("[STGFxHUD].[showInventory] begins");
}

function hideInventory()
{
local array<ASValue> args;
local ASValue asval;

asval.Type = AS_String;
asval.s = "Matthew";
args[0] = asval;

asval.Type = AS_Number;
asval.n = 38;
args[1] = asval;
        GetVariableObject("root").Invoke("hideInventory",args );
	`log("[STGFxHUD].[hideInventory] begins");
}

DefaultProperties
{
 //this is the HUD. If the HUD is off, then this should be off
 //bDisplayWithHudOff=false
 //The path to the swf asset we will create later
 MovieInfo=SwfMovie'Hotshot.Inventory'
 //Just put it in...
 //bGammaCorrection = false
}