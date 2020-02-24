using System;
using Godot;
using GodotWildJam.Misc;

namespace GodotWildJam.Generate
{
	public class SceneMapGenerator : TileMap
	{
		private int xSize { get; set; } = 40;
		private int ySize { get; set; } = 30;
		private int tilesX { get; set; } = 16;
		private int tilesY { get; set; } = 9;
		private Color startColor { get; set; } = Colors.Green;
		private Color pathColor { get; set; } = Colors.Blue;
		private Color endColor { get; set; } = Colors.Red;
		private int tilesLimit { get; set; } = 6;

		private Vector2 currentTilePos { get; set; }
		private int tilesPlaced = 0;
		private RandomUtilities randomGen1 = new RandomUtilities();
		private RandomUtilities randomGen2 = new RandomUtilities();

		public override void _Ready()
		{
			base._Ready();
		}

		private void PlaceEndTile(Image workingImage, Vector2 place) {
			var np = place + Vector2.Down;
			workingImage.Lock();
			var pc = workingImage.GetPixelv(np);
			if ((pc.r > 0.01f) || (pc.g > 0.01f) || (pc.b > 0.01f))
			{
				np = place + Vector2.Right;
				if ((pc.r > 0.01f) || (pc.g > 0.01f) || (pc.b > 0.01f))
				{
					np = place + Vector2.Left;
					tilesPlaced += 1;
					workingImage.SetPixelv(np, endColor);
				} else 
				{
					tilesPlaced += 1;
					workingImage.SetPixelv(np, endColor);
				}
			} else
			{
				tilesPlaced += 1;
				workingImage.SetPixelv(np, endColor);
			}
			workingImage.Unlock();
		}


		private void PlaceTile(Image workingImage, Vector2 place, int id, bool End)
		{
			var np = place + Vector2.Up;
			switch (id)
			{
				//1 = DOWN
				case 1:
					np = place + Vector2.Down;
					break;
				//2 = LEFT
				case 2:
					np = place + Vector2.Left;
					break;
				//3 = RIGHT
				case 3:
					np = place + Vector2.Right;
					break;
			}
			GD.Print($"PlaceTile, place={place}, id={id}, end={End}");
			workingImage.Lock();
			var pc = workingImage.GetPixelv(np);
			GD.Print($"PlaceTile, pixel color={pc}");
			if ((pc.r > 0.01f) || (pc.g > 0.01f) || (pc.b > 0.01f))
			{
				workingImage.Unlock();
				currentTilePos = np;
				GD.Print("PlaceTile, color - return called");
				return;
			}
			workingImage.Unlock();

			workingImage.Lock();
			if (End == false)
				workingImage.SetPixelv(np, pathColor);
			else
				workingImage.SetPixelv(np, endColor);
			workingImage.Unlock();
			tilesPlaced += 1;
			currentTilePos = np;
		}

		public override void _EnterTree()
		{
			base._EnterTree();
			Generate();
		}

		public String DebugPrintTimeDifference(String preHeader, DateTime early, DateTime recent)
		{
			var timeDiff = recent - early;
			return $"{preHeader}\t{timeDiff.TotalMilliseconds} milli-seconds\n";
		}

		public void Generate()
		{
			DateTime dtStarted = DateTime.Now;
			bool endTilePlaced = false;
			var dynamicImage = new Image();
			var start = new Vector2((xSize - 1) / 2, (ySize - 1) / 2);
			var tilesXSize = tilesX * (this.CellSize.x * this.Scale.x);
			var tilesYSize = tilesY * (this.CellSize.y * this.Scale.y);
			Position = new Vector2((-start.x * tilesXSize) - tilesXSize / 2, (-start.y * tilesYSize) - tilesYSize / 2);
			dynamicImage.Create(xSize, ySize, false, Image.Format.Rgba8);
			dynamicImage.Fill(Colors.Black);
			dynamicImage.Lock();
			dynamicImage.SetPixelv(start, startColor);
			dynamicImage.Unlock();

			dynamicImage.SavePng("desert_walkpath_start.png");
			currentTilePos = start;
			int gencounter = 0;
			while (!endTilePlaced)
			{
				var rndSel = randomGen1.GetIntInRange(0, 3);
				endTilePlaced = tilesPlaced >= tilesLimit;
				GD.Print($"Generate, rndSel={rndSel}, tilesPlaced={tilesPlaced}, tilesLimit={tilesLimit}, endTilePlaced={endTilePlaced}");
				PlaceTile(dynamicImage, currentTilePos, rndSel, endTilePlaced);
				gencounter += 1;
				if (gencounter >= 1200)
					break;
			}
			PlaceEndTile(dynamicImage, currentTilePos);
			DateTime dtWalkGenerated = DateTime.Now;
			String timeDebug1 = DebugPrintTimeDifference("Walk generated=", dtStarted, dtWalkGenerated);
			GD.Print(timeDebug1);
			dynamicImage.SavePng("desert_walkpath_end.png");
			DrawTileMap(dynamicImage, start);
			DateTime dtDrawMap = DateTime.Now;
			String timeDebug2 = DebugPrintTimeDifference("Draw Map=", dtStarted, dtDrawMap);
			GD.Print(timeDebug2);
		}

		public void DrawTileMap(Image workingImage, Vector2 start)
		{
			Clear();
			workingImage.Lock();

			for (int y = 0; y < ySize; y++)
				for (int x = 0; x < xSize; x++)
				{
					var pv = new Vector2(x, y);
					var pc = workingImage.GetPixelv(pv);
					pv = new Vector2(x * tilesX, y * tilesY);
					if (pc == Colors.Black)
					{
						for (int ntx = 0; ntx < tilesX; ntx++)
							for (int nty = 0; nty < tilesY; nty++)
							{
								var newtilePos = new Vector2(pv.x + ntx, pv.y + nty);
								SetCellv(newtilePos, 0);
							}
					}
					else
					{
						var idTile = randomGen1.GetIntInRange(0, 3) + 2;
						SetCellv(pv, idTile);
						GD.Print($"DrawTileMap, pos={pv}, id={idTile}");
					}
				}

			UpdateBitmaskRegion();
			int endid = 7;

			SetCellv(new Vector2(start.x * tilesX, start.y * tilesY), 1);

			if (workingImage.GetPixelv(currentTilePos + Vector2.Up).b > 0.5)
				endid = 8;
			else if (workingImage.GetPixelv(currentTilePos + Vector2.Down).b > 0.5)
				endid = 7;
			else if (workingImage.GetPixelv(currentTilePos + Vector2.Left).b > 0.5)
				endid = 10;
			else if (workingImage.GetPixelv(currentTilePos + Vector2.Right).b > 0.5)
				endid = 9;

			SetCellv(new Vector2(currentTilePos.x * tilesX, currentTilePos.y * tilesY), endid);
			workingImage.Unlock();

			UpdateDirtyQuadrants();
		}
	}
}
