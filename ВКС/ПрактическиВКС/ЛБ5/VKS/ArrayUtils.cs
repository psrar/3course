using System;
using System.Linq;
using System.Collections.Generic;
using static System.Console;
static class Utils
{
    public static IEnumerable<int> GenerateRandomNumericalArray(int length, int minIncl, int maxExcl)
    {
        var b = new List<int>().RecursiveAdd(() => new Random().Next(minIncl, maxExcl), length);
        return b;
    }

    static public IEnumerable<T> RecursiveAdd<T>(this IEnumerable<T> collection, Func<T> itemBuilder, int times)
    {
        var c = collection.ToList();
        new Action(() => c.Add(itemBuilder())).Repeat(times);
        return c;
    }

    public static void PrintLine<T>(this IEnumerable<T> collection) =>
        WriteLine(string.Join(' ', collection));

    static public void Repeat(this Action action, int times)
    {
        for (int i = 0; i < times; i++)
            action();
    }
}
