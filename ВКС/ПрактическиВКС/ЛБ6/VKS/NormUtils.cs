using System;
using System.Collections.Generic;

static public class NormUtils
{
    static public IEnumerable<T> GenerateArray<T>(Func<T> itemBuilder, int length)
    {
        List<T> l = new List<T>();
        for (int i = 0; i < length; i++)
            l.Add(itemBuilder());
        return l;
    }

    static public void Print<T>(this IEnumerable<T> collection) =>
        Console.WriteLine(string.Join(' ', collection));
}
