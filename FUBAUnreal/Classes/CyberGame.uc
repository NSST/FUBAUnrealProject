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

//Initialize necessary variables
defaultproperties
{

        PlayerControllerClass = class 'CyberPlayerController'
        HUDType = class 'MouseInterfaceHUD'
        DefaultPawnClass = class 'AwesomePawn'
        GameReplicationInfoClass = class 'AwesomeGameReplicationInfo'

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

