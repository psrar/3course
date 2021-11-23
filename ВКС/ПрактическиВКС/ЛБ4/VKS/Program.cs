using System;
using VKS.Geometry;

namespace VKS
{
	class Program
	{
		static void Main()
		{
			Console.CursorVisible = false;

			Point a = new(51, 25);
			Point b = new(10, 10);

			Canvas.DrawLine(a, b, ConsoleColor.Red);

			Console.ReadKey();
		}
	}
}