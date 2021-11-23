using System;
using VKS.Geometry;
using static System.Console;

static class Canvas
{
	static Point dimensions = new Point(WindowWidth, WindowHeight); //Размер окна вывода консоли

	static public void DrawLine(Point start, Point end, ConsoleColor color) //Алгоритм Брезенхэма
	{
		float x0 = start.X, x1 = end.X, y0 = start.Y, y1 = end.Y;
		float dx = Math.Abs(x1 - x0), sx = x0 < x1 ? 1 : -1;
		float dy = Math.Abs(y1 - y0), sy = y0 < y1 ? 1 : -1;
		float err = (dx > dy ? dx : -dy) / 2, e2;

		Point p;
		for(; ; )
		{
			p = new(x0, y0);
			DrawPoint(p, color);
			if(x0 == x1 && y0 == y1) break;
			e2 = err;
			if(e2 > -dx) { err -= dy * 0.5f; x0 += sx; }
			if(e2 < dy) { err += dx * 0.5f; y0 += sy; }
		}
	}

	static public void DrawPoint(Point p, ConsoleColor color)
	{
		if(p.X > dimensions.X || p.Y > dimensions.Y || p.X < 0 || p.Y < 0)
			throw new Exception($"Точка отрисовки выходит за пределы экрана консоли ({WindowWidth};{WindowHeight}).");

		SetConsoleCursor(p);
		BackgroundColor = color;
		Write(' ');
	}

	static public void SetConsoleCursor(Point point)
	{
		CursorLeft = (int)point.X;
		CursorTop = (int)point.Y;
	}
}