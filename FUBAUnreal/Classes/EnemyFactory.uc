class EnemyFactory extends Actor
placeable;



var Enemy MySpawnedBot;
var int ID;
var () array<NavigationPoint> MyNavigationPoints;//for patrol route

enum Type {

	BLUE_BOT,
	GREEN_BOT,
	RED_BOT,
	BOSS_TYPE,

};

//initialize
defaultproperties
{

        Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=True
        End Object

        Components.Add(Sprite)


}

function SpawnEnemy(int EnemyTypeRequested)
{



        switch(EnemyTypeRequested)
        {
                case Type.BLUE_BOT:
                MySpawnedBot = spawn(class'BlueBot', self,,Location);
                MySpawnedBot.SetOwner(self);
                break;
                
                case Type.GREEN_BOT:
                MySpawnedBot = spawn(class'GreenBot', self,,Location);
                MySpawnedBot.SetOwner(self);
                break;
                
                case Type.RED_BOT:
                MySpawnedBot = spawn(class'RedBot', self,,Location);
                MySpawnedBot.SetOwner(self);
                break;

        }

        MySpawnedBot.BotID = ID;

}

function EnemyDied()
{

        SetTimer(2, false, 'SpawnEnemyRandomly');
      // MySpawnedBot.Location = Location;

}

function SpawnEnemyRandomly()
{

        local int RandomNumber;

        RandomNumber = Rand(3);

        SpawnEnemy(RandomNumber);
}


