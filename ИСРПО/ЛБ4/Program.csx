using static System.Console;
int length;
WriteLine("Введите размер массива:");
length = int.Parse(ReadLine());
int[] s = new int[length];
Random rnd = new Random();
for(int i = 0; i < length; i++)
    s[i] = rnd.Next(10) + 1;

WriteLine("Неотсортированный массив:");
WriteLine(string.Join(' ', s));

int t;
for(int k = 0; k < length; k++)
    for(int i = 0; i < length - 1 - k; i++)
        if(s[i] < s[i+1]){
        t = s[i];
        s[i] = s[i+1];
        s[i+1] = t;
        }

WriteLine("Отсортированный по убыванию массив:");
WriteLine(string.Join(' ', s));