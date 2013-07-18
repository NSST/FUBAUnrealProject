class AwesomeEnemySpawner extends AwesomeActor
placeable;

var AwesomeBot MySpawnedBot;
var int ID;

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
        MySpawnedBot.BotID = ID;
       // `log(ID);

}

function EnemyDied()
{

        SetTimer(2, false, 'SpawnEnemy');

}

