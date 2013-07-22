class CyberGame extends UTDeathmatch;

var array<EnemyFactory> EnemySpawners;

enum Type {

	BLUE_BOT,
	GREEN_BOT,
	RED_BOT,
	BOSS_TYPE,

};

defaultproperties
{

          PlayerControllerClass=class'CyberPlayerController'
          HUDType=class'MouseInterfaceHUD'
          DefaultPawnClass=class'AwesomePawn'
          GameReplicationInfoClass=class'AwesomeGameReplicationInfo'

          bUseClassicHUD=true
          bDelayedStart=false
}

function PostBeginPlay()
{
                local EnemyFactory EF;

                super.PostBeginPlay();

                foreach DynamicActors(class'EnemyFactory', EF)
                        EnemySpawners[EnemySpawners.length] = EF;

                ActivateSpawners();
}

function ActivateSpawners()
{

        local int i;

        for(i=0; i<EnemySpawners.length; i++)
        {
                 EnemySpawners[i].ID = i;
                 EnemySpawners[i].SpawnEnemyRandomly();
        }


}
