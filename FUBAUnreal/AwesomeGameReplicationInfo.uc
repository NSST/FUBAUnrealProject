class AwesomeGameReplicationInfo extends UTGameReplicationInfo;

var vector EnemyLocation[4];
var int EnemyHealth[4];

defaultproperties
{

}

replication
{
        if(bNetDirty)
        EnemyLocation,EnemyHealth;
}



