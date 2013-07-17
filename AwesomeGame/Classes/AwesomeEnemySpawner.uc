class AwesomeEnemySpawner extends AwesomeActor
placeable;

var AwesomeBot MySpawnedBot;

defaultproperties
{

        Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=True
        End Object

        Components.Add(Sprite)

}

function SpawnEnemy()
{

        MySpawnedBot = spawn(class'AwesomeBot', self,,Location);
        MySpawnedBot.SetOwner(self);

}

function EnemyDied()
{

        SetTimer(2, false, 'SpawnEnemy');

}

