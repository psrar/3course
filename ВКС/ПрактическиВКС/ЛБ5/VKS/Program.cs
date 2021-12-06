using System;
static class Program
{
    static void Main()
    {
        int b = 0;
        long l = DateTime.Now.Ticks;
        for (int i = 0; i < 10; i++)
        {
            new Action(() => Utils.GenerateRandomNumericalArray(10, 0, 2).PrintLine()).Repeat(5);
            b++;
        }
        l = DateTime.Now.Ticks - l;
        Console.WriteLine("First = " + l / b);

        b = 0;
        l = DateTime.Now.Ticks;
        Random rnd = new Random();
        for (int i = 0; i < 10; i++)
        {
            for (int k = 0; k < 5; k++)
                NormUtils.GenerateArray(() => new Random().Next(0, 2), 10).Print();
            b++;
        }
        l = DateTime.Now.Ticks - l;
        Console.WriteLine("Second = " + l / b);
        Console.ReadKey();
    }
}
