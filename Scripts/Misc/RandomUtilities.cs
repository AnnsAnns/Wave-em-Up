using Godot;
using System;

namespace GodotWildJam.Misc
{
    public class RandomUtilities
    {
        private RandomNumberGenerator generatorRandom1;
        private RandomNumberGenerator generatorRandom2;
        private RandomNumberGenerator generatorRandom3;

        public RandomUtilities(ulong seed1 = 0, ulong seed2 = 0)
        {
            generatorRandom1 = new RandomNumberGenerator();
            if (seed1 != 0)
                generatorRandom1.Seed = seed1;
            generatorRandom2 = new RandomNumberGenerator();
            if (seed2 != 0)
                generatorRandom2.Seed = seed2;
            generatorRandom3 = new RandomNumberGenerator();
            generatorRandom3.Seed = generatorRandom1.Randi() + generatorRandom2.Randi() + 13;
        }

        public int GetIntInRange(int minRange, int maxRange)
        {
            if (maxRange <= 1)
                return 1;
            generatorRandom2.Randomize();
            return generatorRandom2.RandiRange(minRange, maxRange);
        }

        public float GetFloatInRange(float minRange, float maxRange)
        {
            generatorRandom3.Randomize();
            return generatorRandom3.RandfRange(minRange, maxRange);
        }

        public float[] GenerateFloatArray(int count, float minRange, float maxRange, int offset = 0, bool cumulative = false)
        {
            generatorRandom3.Randomize();
            float[] res = new float[count];
            for (int index = 0; index < count; index++)
            {
                if ((cumulative) && (index >= 1))
                {
                    res[index] = offset + res[index - 1] + generatorRandom3.RandfRange(minRange, maxRange);
                }
                else
                    res[index] = offset + generatorRandom3.RandfRange(minRange, maxRange);
            }
            return res;
        }

        public int[] GenerateArray(int count, int minRange, int maxRange, int offset = 0, bool cumulative = false)
        {
            generatorRandom1.Randomize();
            int[] res = new int[count];
            for (int index = 0; index < count; index++)
            {
                if ((cumulative) && (index >= 1))
                {
                    res[index] = offset + res[index - 1] + generatorRandom1.RandiRange(minRange, maxRange);
                }
                else
                    res[index] = offset + generatorRandom1.RandiRange(minRange, maxRange);
            }
            return res;
        }
    }
}
