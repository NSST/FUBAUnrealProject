class AwesomeGame extends UTDeathmatch;

var array<AwesomeEnemySpawner> EnemySpawners;

defaultproperties
{

          PlayerControllerClass=class'AwesomeGame.AwesomePlayerController'
          HUDType=class'AwesomeGame.MouseInterfaceHUD'
          DefaultPawnClass=class'AwesomeGame.AwesomePawn'
          bUseClassicHUD=true
          bDelayedStart=false
}

function PostBeginPlay()
{

                local AwesomeEnemySpawner ES;

                super.PostBeginPlay();

                foreach DynamicActors(class'AwesomeEnemySpawner', ES)
                        EnemySpawners[EnemySpawners.length] = ES;

                ActivateSpawners();
}

function ActivateSpawners()
{

        local int i;

        for(i=0; i<EnemySpawners.length; i++)
                EnemySpawners[i].SpawnEnemy();

}
