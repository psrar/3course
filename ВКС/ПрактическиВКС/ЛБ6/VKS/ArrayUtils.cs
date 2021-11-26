using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VKS
{
	static class ArrayUtils
	{
		static private readonly Random rnd = new();

		public static void OutputArray<T>(T[] inArray)
		{
			inArray.ToList().ForEach(i => Console.WriteLine(i + " "));
			Console.WriteLine();
		}

		public static int[] GenerateRandomNumericalArray(int length, int minIncl, int maxExcl) =>
			Enumerable.Repeat(0, length).Select(i => rnd.Next(minIncl, maxExcl)).ToArray();
	}
}
