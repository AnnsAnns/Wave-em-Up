using Godot;
using System;
using System.Collections.Generic;
using TeamPunk.Enums;

namespace TeamPunk.Effects
{
	public class LinearFountainParticles : Node2D
	{
		private Particles2D particleSet1;
		private Particles2D particleSet2;
		private Particles2D particleSet3;
		private Particles2D particleSet4;
		private bool symmetricalPlacement;
		private int numberOfSourcePoints;
		private float degreesPerSecond = 0.0f;
		private Dictionary<String, ImageTexture> mapClusterParticleTextures;
		private Dictionary<String, bool> mapActiveSets;
		private Dictionary<String, String> mapParticleImageResources;

		private void LoadPresetResources()
		{
			mapParticleImageResources.Add("light-rain1", "res://Assets/Images/FX/64x64/rain_particles_light1.png");
			mapParticleImageResources.Add("light-rain2", "res://Assets/Images/FX/64x64/rain_particles_light2.png");
			mapParticleImageResources.Add("heavy-rain1", "res://Assets/Images/FX/64x64/rain_particles_heavy1.png");
			mapParticleImageResources.Add("heavy-rain2", "res://Assets/Images/FX/64x64/rain_particles_heavy2.png");
			mapParticleImageResources.Add("feint-smoke1", "res://Assets/Images/FX/64x64/smoke_particles_feint1.png");
			mapParticleImageResources.Add("feint-smoke2", "res://Assets/Images/FX/64x64/smoke_particles_feint2.png");
			mapParticleImageResources.Add("feint-smoke3", "res://Assets/Images/FX/64x64/smoke_particles_feint3.png");
			mapParticleImageResources.Add("medium-smoke1", "res://Assets/Images/FX/64x64/smoke_particles_medium1.png");
			mapParticleImageResources.Add("medium-smoke2", "res://Assets/Images/FX/64x64/smoke_particles_medium2.png");
		}

		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			mapClusterParticleTextures = new Dictionary<string, ImageTexture>();
			mapActiveSets = new Dictionary<string, bool>();
			mapParticleImageResources = new Dictionary<string, string>();
			LoadPresetResources();
			particleSet1 = GetNodeOrNull<Particles2D>("Particles2D-1");
			particleSet2 = GetNodeOrNull<Particles2D>("Particles2D-2");
			particleSet3 = GetNodeOrNull<Particles2D>("Particles2D-3");
			particleSet4 = GetNodeOrNull<Particles2D>("Particles2D-4");
		}

		public void DebugParticleTexture(string filter)
		{
			if (String.IsNullOrEmpty(filter))
			{
				GD.Print($"DebugParticleTexture, set1 texture={particleSet1.Texture}");
				GD.Print($"DebugParticleTexture, set2 texture={particleSet2.Texture}");
				GD.Print($"DebugParticleTexture, set3 texture={particleSet3.Texture}");
				GD.Print($"DebugParticleTexture, set4 texture={particleSet4.Texture}");
			}
		}

		public void SetSourcePoints(int sourceCount, bool symmetrical)
		{
			numberOfSourcePoints = sourceCount;
			symmetricalPlacement = symmetrical;
			GD.Print($"SetSourcePoints sourceCount={sourceCount}, symmetrical={symmetrical}");
			for (int idx = 1; idx <= sourceCount; idx++)
			{
				string strKey = $"set{idx}";
				GD.Print($"SetSourcePoints index={idx}, key={strKey}");
				mapActiveSets.Add(strKey, true);
			}
		}

		public void SetGroupingRotation(float degreesSec)
		{
			degreesPerSecond = degreesSec;
		}

		public bool IsActiveSet(string sourceTag)
		{
			if (mapActiveSets == null)
				return false;
			bool res = mapActiveSets.ContainsKey(sourceTag);
			return res;
		}

		public void Enable(bool enable)
		{
			//If enabled then add active/selected particles to the scene
			if (enable)
			{
				if (IsActiveSet("set1"))
					AddChild(particleSet1);
				if (IsActiveSet("set2"))
					AddChild(particleSet2);
				if (IsActiveSet("set3"))
					AddChild(particleSet3);
				if (IsActiveSet("set4"))
					AddChild(particleSet4);
			}
		}

		public void Emit(bool emit)
		{
			if (IsActiveSet("set1"))
				particleSet1.Emitting = emit;
			if (IsActiveSet("set2"))
				particleSet2.Emitting = emit;
			if (IsActiveSet("set3"))
				particleSet3.Emitting = emit;
			if (IsActiveSet("set4"))
				particleSet4.Emitting = emit;
		}

		public String GetImageResource(string resourceTag)
		{
			string res = "";
			if (mapParticleImageResources != null)
			{
				if (mapParticleImageResources.ContainsKey(resourceTag))
					res = mapParticleImageResources[resourceTag];
			}
			return res;
		}

		public ImageTexture CreateTexture(string resourcePath, bool fill, Color fillColor, Vector2 imgSize)
		{
			ImageTexture res = new ImageTexture();
			if ((imgSize != null) && (imgSize.x >= 16) && (imgSize.y >= 16))
				res.Create((int)imgSize.x, (int)imgSize.y, Image.Format.Rgba8);
			Image myImage = new Image();
			if (fill)
			{
				myImage.Create((int)imgSize.x, (int)imgSize.y, false, Image.Format.Rgba8);
				myImage.Fill(fillColor);
			}
			myImage.Load(resourcePath);
			GD.Print($"CreateTexture resourcePath={resourcePath}, width={myImage.GetWidth()}");
			//FillSolidRectangle(myImage, new Vector2(120, 100), new Vector2(250, 240), selectedFill);
			res.CreateFromImage(myImage);
			return res;
		}

		public void SetVisible(string tag, bool visible)
		{
			if (String.IsNullOrEmpty(tag) == false)
			{
				switch (tag)
				{
					case "all":
						if (IsActiveSet("set1"))
							particleSet1.Visible = visible;
						if (IsActiveSet("set2"))
							particleSet2.Visible = visible;
						if (IsActiveSet("set3"))
							particleSet3.Visible = visible;
						if (IsActiveSet("set4"))
							particleSet4.Visible = visible;
						break;
					default:
						break;
				}
			}
		}

		public void SetActiveSetsMaterialName(string materialName)
		{
			PredefParticleMaterial materialChoice = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_BLOCK;
			switch (materialName)
			{
				case "BLOCK":
					materialChoice = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_BLOCK;
					break;
				case "CIRCLE":
					materialChoice = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_CIRCLE;
					break;
				case "LIGHT_RAIN":
					materialChoice = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_LIGHT_RAIN;
					break;
				case "HEAVY_RAIN":
					materialChoice = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_HEAVY_RAIN;
					break;
				case "FEINT_SMOKE":
					materialChoice = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_FEINT_SMOKE;
					break;
				case "MEDIUM_SMOKE":
					materialChoice = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_MEDIUM_SMOKE;
					break;
				case "THICK_SMOKE":
					materialChoice = PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_THICK_SMOKE;
					break;
			}
			SetActiveSetsMaterial(materialChoice);
		}

		public void SetActiveSetsMaterial(PredefParticleMaterial defMaterial)
		{
			Color defaultFill = new Color(0.0f, 0.0f, 0.0f);
			Vector2 noDefinedSize = new Vector2(0, 0);
			string particleTextureRes1 = "";
			string particleTextureRes2 = "";
			string particleTextureRes3 = "";
			switch (defMaterial)
			{
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_BLOCK:
					//Set the Material to null to use the default block shape
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_CIRCLE:
					//Draw circle on canvas or another node and copy the texture across
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_LIGHT_RAIN:
					particleTextureRes1 = GetImageResource("light-rain1");
					particleTextureRes2 = GetImageResource("light-rain2");
					GD.Print($"SetActiveSetsMaterial (LIGHT_RAIN), res1={particleTextureRes1}, res2={particleTextureRes2}");
					ImageTexture rainLight1Texture = CreateTexture(particleTextureRes1, false, defaultFill, noDefinedSize);
					ImageTexture rainLight2Texture = CreateTexture(particleTextureRes2, false, defaultFill, noDefinedSize);
					GD.Print($"SetActiveSetsMaterial (LIGHT_RAIN), texture1={rainLight1Texture}, texture2={rainLight2Texture}");
					if (IsActiveSet("set1"))
						particleSet1.Texture = rainLight1Texture;
					//GD.Print($"SetActiveSetsMaterial (LIGHT_RAIN), set1 texture={particleSet1.Texture}");
					if (IsActiveSet("set2"))
						particleSet2.Texture = rainLight2Texture;
					if (IsActiveSet("set3"))
						particleSet3.Texture = rainLight1Texture;
					if (IsActiveSet("set4"))
						particleSet4.Texture = rainLight2Texture;
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_HEAVY_RAIN:
					particleTextureRes1 = GetImageResource("heavy-rain1");
					particleTextureRes2 = GetImageResource("heavy-rain2");
					GD.Print($"SetActiveSetsMaterial (HEAVY_RAIN), res1={particleTextureRes1}, res2={particleTextureRes2}");
					ImageTexture rainHeavy1Texture = CreateTexture(particleTextureRes1, false, defaultFill, noDefinedSize);
					ImageTexture rainHeavy2Texture = CreateTexture(particleTextureRes2, false, defaultFill, noDefinedSize);
					if (IsActiveSet("set1"))
						particleSet1.Texture = rainHeavy1Texture;
					if (IsActiveSet("set2"))
						particleSet2.Texture = rainHeavy2Texture;
					if (IsActiveSet("set3"))
						particleSet3.Texture = rainHeavy1Texture;
					if (IsActiveSet("set4"))
						particleSet4.Texture = rainHeavy2Texture;
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_FEINT_SMOKE:
					particleTextureRes1 = GetImageResource("feint-smoke1");
					particleTextureRes2 = GetImageResource("feint-smoke2");
					particleTextureRes3 = GetImageResource("feint-smoke3");
					ImageTexture smokeFeint1Texture = CreateTexture(particleTextureRes1, false, defaultFill, noDefinedSize);
					ImageTexture smokeFeint2Texture = CreateTexture(particleTextureRes2, false, defaultFill, noDefinedSize);
					if (IsActiveSet("set1"))
						particleSet1.Texture = smokeFeint1Texture;
					if (IsActiveSet("set2"))
						particleSet2.Texture = smokeFeint2Texture;
					if (IsActiveSet("set3"))
						particleSet3.Texture = smokeFeint1Texture;
					if (IsActiveSet("set4"))
						particleSet4.Texture = smokeFeint2Texture;
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_MEDIUM_SMOKE:
					particleTextureRes1 = GetImageResource("medium-smoke1");
					particleTextureRes2 = GetImageResource("medium-smoke2");
					ImageTexture smokeMedium1Texture = CreateTexture(particleTextureRes1, false, defaultFill, noDefinedSize);
					ImageTexture smokeMedium2Texture = CreateTexture(particleTextureRes2, false, defaultFill, noDefinedSize);
					if (IsActiveSet("set1"))
						particleSet1.Texture = smokeMedium1Texture;
					if (IsActiveSet("set2"))
						particleSet2.Texture = smokeMedium2Texture;
					if (IsActiveSet("set3"))
						particleSet3.Texture = smokeMedium1Texture;
					if (IsActiveSet("set4"))
						particleSet4.Texture = smokeMedium2Texture;
					break;
				default:
					break;
			}
		}

		public void SetDefaultPredefinedMaterial(PredefParticleMaterial defMaterial)
		{
			switch (defMaterial)
			{
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_BLOCK:
					SetActiveSetsMaterial(PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_BLOCK);
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_CIRCLE:
					SetActiveSetsMaterial(PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_CIRCLE);
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_LIGHT_RAIN:
					SetActiveSetsMaterial(PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_LIGHT_RAIN);
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_HEAVY_RAIN:
					SetActiveSetsMaterial(PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_HEAVY_RAIN);
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_FEINT_SMOKE:
					SetActiveSetsMaterial(PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_FEINT_SMOKE);
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_MEDIUM_SMOKE:
					SetActiveSetsMaterial(PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_MEDIUM_SMOKE);
					break;
				case PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_THICK_SMOKE:
					SetActiveSetsMaterial(PredefParticleMaterial.PREDEF_MATERIAL_DEFAULT_THICK_SMOKE);
					break;
				default:
					break;
			}
		}

		public Particles2D GetParticleSet(string setKey)
		{
			Particles2D res = null;
			switch (setKey)
			{
				case "set1":
					res = particleSet1;
					break;
				case "set2":
					res = particleSet2;
					break;
				case "set3":
					res = particleSet3;
					break;
				case "set4":
					res = particleSet4;
					break;
				default:
					break;
			}
			return res;
		}

		public void SetModulateColor(string setTag, Color modColor)
		{
			GD.Print($"SetModulateColor, setTag={setTag}, modColor={modColor}, source points={numberOfSourcePoints}");
			if (String.IsNullOrEmpty(setTag) || (setTag == "all"))
			{
				for (int idx = 1; idx <= numberOfSourcePoints; idx++)
				{
					string strKey = $"set{idx}";
					Particles2D particleSetCurrent = GetParticleSet(strKey);
					if (particleSetCurrent != null)
					{
						ParticlesMaterial procMaterial = (ParticlesMaterial)particleSetCurrent.ProcessMaterial;
						procMaterial.Color = modColor;
					}
				}
			}
		}

		public void SetBasicAttributes(int amount, float lifetime, float lifeRandomness, float explosiveness, float angularVelocity, float Angle)
		{
			for (int idx = 1; idx <= numberOfSourcePoints; idx++)
			{
				string strKey = $"set{idx}";
				Particles2D particleSetCurrent = GetParticleSet(strKey);
				GD.Print($"SetBasicAttributes, strKey={strKey}, particleSetCurrent={particleSetCurrent}");
				if (particleSetCurrent != null)
				{
					particleSetCurrent.Amount = amount;
					if (lifetime >= 0.1)
						particleSetCurrent.Lifetime = lifetime;
					if (explosiveness > 0.05)
						particleSetCurrent.Explosiveness = explosiveness;
					ParticlesMaterial procMaterial = (ParticlesMaterial)particleSetCurrent.ProcessMaterial;
					procMaterial.AngularVelocity = angularVelocity;
					procMaterial.Angle = Angle;
				}
			}
		}

		//  // Called every frame. 'delta' is the elapsed time since the previous frame.
		//  public override void _Process(float delta)
		//  {
		//
		//  }
	}
}
