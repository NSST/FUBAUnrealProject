class AwesomeGameReplicationInfo extends UTGameReplicationInfo;

var vector EnemyLocation[4];
var int EnemyHealth[4];

defaultproperties
{

}

//used to replicate for everyone to see
replication
{
        if(bNetDirty)
        EnemyLocation,EnemyHealth;
}



