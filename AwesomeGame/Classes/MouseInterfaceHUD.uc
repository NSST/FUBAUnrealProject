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

