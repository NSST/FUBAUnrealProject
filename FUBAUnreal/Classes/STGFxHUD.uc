class STGFxHUD extends GFxMoviePlayer;


var CyberPlayerController PlayerOwner;
var int MAX_ITEMS;

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
        showItems();
	`log("[STGFxHUD].[showInventory] begins");
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

 function renderItems(int slot)
{
local array<ASValue> args;
local ASValue asval;
local Pawn player;

player = PlayerOwner.Pawn;

asval.Type = AS_String;
asval.s = AwesomePawn(player).items[slot].type;
args[0] = asval;

asval.Type = AS_Number;
asval.n = 4;
args[1] = asval;

        switch(slot)
        {
                case 0:
                GetVariableObject("root").Invoke("showSlot1",args );
                break;
                
                case 1:
                GetVariableObject("root").Invoke("showSlot2",args );
                break;
        }

}

function UpgradeWeapon(int grade)
{

local Pawn player;

player = PlayerOwner.Pawn;

AwesomeWeapon(player.Weapon).UpgradeWeapon(grade);

`log('UPGRADED TO ' @ grade);

}

function showItems()
{
        local Pawn player;
        local int i;
        
        player = PlayerOwner.Pawn;

        for(i = 0; i < MAX_ITEMS ;i++)
        {
                if(AwesomePawn(player).items[i] != none)
                {
                      //   `log('NOT FOUND IT AAT ' @ i);
                       renderItems(i);

                }


        }
}



DefaultProperties
{
 //this is the HUD. If the HUD is off, then this should be off
 bDisplayWithHudOff=false
 //The path to the swf asset we will create later
 MovieInfo=SwfMovie'Hotshot.Inventory'
 MAX_ITEMS = 6;
}