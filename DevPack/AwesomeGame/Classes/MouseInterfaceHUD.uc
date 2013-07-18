class MouseInterfaceHUD extends HUD;

// The texture which represents the cursor on the screen
var const Texture2D CursorTexture;
// The color of the cursor
var const Color CursorColor;

var Vector WorldOrigin;
var Vector WorldDirection;
var Vector2D    MousePosition;
var Vector test;

event PostRender()
{
  local MouseInterfacePlayerInput MouseInterfacePlayerInput;
  local AwesomePlayerController AwesomePlayerController;

  // Ensure that we have a valid PlayerOwner and CursorTexture
  if (PlayerOwner != None && CursorTexture != None) 
  {
    // Cast to get the MouseInterfacePlayerInput
    MouseInterfacePlayerInput = MouseInterfacePlayerInput(PlayerOwner.PlayerInput); 

    if (MouseInterfacePlayerInput != None)
    {
          // Set the canvas position to the mouse position
        Canvas.SetPos(MouseInterfacePlayerInput.MousePosition.X, MouseInterfacePlayerInput.MousePosition.Y);
         // Set the cursor color
        Canvas.DrawColor = CursorColor;
         // Draw the texture on the screen
        Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,, true);
      
      	MousePosition.X = MouseInterfacePlayerInput.MousePosition.X;
	MousePosition.Y = MouseInterfacePlayerInput.MousePosition.Y;



         //Deproject the mouse from screen coordinate to world coordinate and store World Origin and Dir.
        Canvas.DeProject(MousePosition, WorldOrigin, WorldDirection);

        AwesomePlayerController = AwesomePlayerController(PlayerOwner);
        AwesomePlayerController.PlayerMouse = MousePosition;
        AwesomePlayerController.MouseHitWorldLocation = GetMouseWorldLocation();

    }
  }

  Super.PostRender();
  DrawHUD();
}

function DrawHUD()
{
        local AwesomePlayerController AwesomePlayerController;
        local int playerHealth;
        local vector ScreenPos;
        local int i;

        AwesomePlayerController = AwesomePlayerController(PlayerOwner);
        playerHealth = AwesomePlayerController.Pawn.Health;

        Canvas.Font = class'Engine'.static.GetLargeFont();
        Canvas.SetDrawColor(255, 255, 255); // White
        Canvas.SetPos(1000, 675);
        Canvas.DrawText(playerHealth);
        
        if(playerHealth < 10)
        {
        Canvas.SetDrawColor(255, 0, 0); // Red
        }
        else if (playerHealth < 20)
        {
        Canvas.SetDrawColor(255, 255, 0); // Yellow
        }
        else
        {
        Canvas.SetDrawColor(0, 255, 0); // Green
        }

       // Canvas.SetPos(1050, 675);
       // Canvas.DrawRect(2 * playerHealth, 30);
   //     Canvas.SetDrawColor(255, 0, 0);
   //     Canvas.SetPos(MyGame.EnemySpawners[0].MySpawnedBot.Location.X, MyGame.EnemySpawners[0].MySpawnedBot.Location.Y );
      // `log("!" @ MyGame.EnemySpawners[0].MySpawnedBot.Location.X @ MyGame.EnemySpawners[0].MySpawnedBot.Location.Y);
  //      Canvas.DrawRect(5 * 100, 30);
  


        if(AwesomeGameReplicationInfo(WorldInfo.GRI) != none)
        {
        
                 for (i = 0 ; i < 3 ; i++)
                 {
                ScreenPos = Canvas.Project(AwesomeGameReplicationInfo(WorldInfo.GRI).EnemyLocation[i]);
                Canvas.SetPos(ScreenPos.X ,ScreenPos.Y - 20);
                Canvas.SetDrawColor(255, 0, 0);
                Canvas.DrawRect(0.5 * AwesomeGameReplicationInfo(WorldInfo.GRI).EnemyHealth[i], 5);
              //  `log(AwesomeGameReplicationInfo(WorldInfo.GRI).EnemyHealth[i]);
                 }


        }


//	Canvas.SetPos(ScreenPos.X ,ScreenPos.Y - 20);
//	Canvas.SetDrawColor(255, 0, 0);
//	Canvas.DrawRect(0.3 * MyGame.EnemySpawners[0].MySpawnedBot.Health, 5);


}

defaultproperties
{
  CursorColor=(R=255,G=255,B=255,A=255)
  CursorTexture=Texture2D'EngineResources.Cursors.Arrow'

}


function Vector GetMouseWorldLocation()
{

  local Vector MouseWorldOrigin, MouseWorldDirection, HitLocation, HitNormal;

  // Ensure that we have a valid canvas and player owner
  if (Canvas == None || PlayerOwner == None)
  {
    return Vect(0, 0, 0);
  }

  // Deproject the mouse position and store it in the cached vectors
  Canvas.DeProject(MousePosition, MouseWorldOrigin, MouseWorldDirection);

  // Perform a trace to get the actual mouse world location.
  Trace(HitLocation, HitNormal, MouseWorldOrigin + MouseWorldDirection * 65536.f, MouseWorldOrigin , true,,, TRACEFLAG_Bullet);
  return HitLocation;
}

