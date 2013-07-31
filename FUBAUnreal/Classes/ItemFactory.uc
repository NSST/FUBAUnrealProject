class ItemFactory extends Actor
placeable;

var Item item;

enum Type {

	ARMOR_TYPE,
	HELMET_TYPE,
	WEAPON_TYPE,

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

function SpawnItem(int EnemyTypeRequested)
{



        switch(EnemyTypeRequested)
        {
                case Type.ARMOR_TYPE:
                item = spawn(class'GreenMedalItem', self,,Location);
                item.SetOwner(self);
                break;
                
                case Type.HELMET_TYPE:
                item = spawn(class'RedMedalItem', self,,Location);
                item.SetOwner(self);
                break;


        }

}

function EnemyDied()
{

        SetTimer(2, false, 'SpawnEnemyRandomly');
      // MySpawnedBot.Location = Location;

}

function SpawnItemRandomly()
{

        local int RandomNumber;

        RandomNumber = Rand(2);

        SpawnItem(RandomNumber);
}


