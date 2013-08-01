class CyberGame extends UTDeathmatch;

//Hold all the factories
var array<EnemyFactory> EnemySpawners;
var array<ItemFactory> ItemSpawners;

//Declare Bot types
enum Type {

	BLUE_BOT,
	GREEN_BOT,
	RED_BOT,
	BOSS_TYPE,

};

event InitGame( string Options, out string ErrorMessage )
{
    Super.InitGame(Options, ErrorMessage);
    BroadcastHandler = spawn(BroadcastHandlerClass);
}

event Broadcast( Actor Sender, coerce string Msg, optional name btype )
{
    local CyberPlayerController PC;
    local PlayerReplicationInfo PRI;

    // This code gets the PlayerReplicationInfo of the sender. We'll use it to get the sender's name with PRI.PlayerName
    if ( Pawn(Sender) != None )
        PRI = Pawn(Sender).PlayerReplicationInfo;
    else if ( Controller(Sender) != None )
	PRI = Controller(Sender).PlayerReplicationInfo;
	
	// This line executes a "Say"
    BroadcastHandler.Broadcast(Sender,Msg,btype);

   // This is where we broadcast the received message to all players (PlayerControllers)
    if (WorldInfo != None)
    {
	foreach WorldInfo.AllControllers(class'CyberPlayerController',PC)
	{
	    `Log(Self$":: Sending "$PC$" a broadcast message from "$PRI.PlayerName$" which is '"$Msg$"'.");
	     PC.ReceiveBroadcast(PRI.PlayerName, Msg);
	}
    }
}

//Initialize necessary variables
defaultproperties
{

        PlayerControllerClass = class 'CyberPlayerController'
        HUDType = class 'MouseInterfaceHUD'
        DefaultPawnClass = class 'AwesomePawn'
        GameReplicationInfoClass = class 'AwesomeGameReplicationInfo'
        BroadcastHandlerClass=class'Engine.BroadcastHandler'

        bUseClassicHUD = true
        bDelayedStart = false
}

//Loading functions before playing
function PostBeginPlay()
{       

        local EnemyFactory EF;
        local ItemFactory ItF;

        super.PostBeginPlay();
                
                //Find all factories on map and load them into a dynamic array
                foreach DynamicActors(class'EnemyFactory', EF)
                        EnemySpawners[EnemySpawners.length] = EF;
                        
                foreach DynamicActors(class'ItemFactory', ItF)
                        ItemSpawners[ItemSpawners.length] = ItF;

                ActivateSpawners();
}


//Make factory spawns enemies randomly
function ActivateSpawners()
{
        local int i;

        for(i=0; i<EnemySpawners.length; i++)
        {
                 EnemySpawners[i].ID = i;
                 EnemySpawners[i].SpawnEnemyRandomly();
        }
        
        for(i=0; i<ItemSpawners.length; i++)
        {
                 ItemSpawners[i].SpawnItemRandomly();
        }

}

