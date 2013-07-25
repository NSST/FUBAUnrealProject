Class Item extends Actor
abstract;

var string type;

event Touch(Actor Other, PrimitiveComponent OtherComp, vector
HitLocation, vector HitNormal)
{
        if (AwesomePawn(Other) != none)

        {
                `log(' Added ');
                AwesomePawn(Other).addItem(self);
                Destroy();

        }
        

}
